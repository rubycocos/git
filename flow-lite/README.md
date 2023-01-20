# flow-lite

flow-lite gem - (yet) another (lite) workflow engine; let's you define your workflow steps in Flowfiles; incl. the flow command line tool


* home  :: [github.com/rubycoco/flow](https://github.com/rubycoco/flow)
* bugs  :: [github.com/rubycoco/flow/issues](https://github.com/rubycoco/flow/issues)
* gem   :: [rubygems.org/gems/flow-lite](https://rubygems.org/gems/flow-lite)
* rdoc  :: [rubydoc.info/gems/flow-lite](http://rubydoc.info/gems/flow-lite)




## Usage


Define the workflow steps in a Flowfile. Example:


``` ruby
step :first_step do
  puts "first_step"
  step :second_step    # note: you can call other steps with step
end

step :second_step do
  puts "second_step"
  step :third_step
end

step :third_step do
  puts "third_step"
end
```

And then use the `flow` command line tool to run a step.
Example:

```
$ flow first_step
```

Note: By default the `flow` command line tool reads in and looks for `./flowfile`, `./Flowfile`, `./flowfile.rb`, `./Flowfile.rb`
in that order.
Use the `-f/--file/--flowfile` option to use a different file.



**Debugging**

Use the `-d/--debug` option to turn on debugging
or pass in `DEBUG=t` as an environment variable on the command line.

Helper.   In your flowfiles you can use the `debug?` helper
to check if debugging is turned on. Example:

``` ruby
step :json do
  outdir = if debug?
             './o'
           else
             realpath( '@openfootball/football.json' )
           end
  #...
end
```


**Prelude / Prolog**

Use the `-r/--require` option to (auto-)require
some extra libraries or scripts.

1) By default the `flow` command line tool will look for
and (auto-)require the `./config.rb` script if it exists
AND if no extra libraries or scripts are passed along with the
`-r/--require` option.

2) By default the "prelude / prolog" that always
gets auto-required (via the flow-lite gem / library) includes:

``` ruby
require 'pp'
require 'time'
require 'date'
require 'json'
require 'yaml'
require 'fileutils'

require 'uri'
require 'net/http'
require 'net/https'
```

Tip: See the [`flow-lite.rb`](https://github.com/rubycoco/flow/blob/master/flow-lite/lib/flow-lite.rb) source for the definite always up-to-date list.



**(Environment) Variables**

On the command line you can pass along (environment) variables
using `NAME=VALUE` to set and `NAME=` to unset. Example:

```
$ flow json DEBUG=t           # -or-
$ flow DEBUG=t json

$ flow build DATA=worldcup
$ flow publish VERSION=1.1.0
```

This will (behind the scene) turn into

``` ruby
ENV[ 'DEBUG' ]   = 't'
ENV[ 'DATA' ]    = 'worldcup'
ENV[ 'VERSION' ] = '1.1.0'
```


That's it for now.



## Backstage Internals / Inside Flowfiles


If you read in a `Flowfile` the flow machinery
builds a new (regular) class derived from `Flow::Base`
and every step becomes a (regular) method. Example:

``` ruby
require 'flow-lite'

flowfile = Flow::Flowfile.load( <<TXT )
  step :hello do
    puts "Hello, world!"
  end

  step :hola do
    puts "¡Hola, mundo!"
  end
TXT

flow = flowfile.flow_class.new   # (auto-)build a flow class (see Note 1)
                                 # and construct/return a new instance
flow.step_hello             #=> "Hello, world!"
flow.step_hola              #=> "¡Hola, mundo!"
flow.step( :hello )         #=> "Hello, world!"
flow.step( :hola )          #=> "¡Hola, mundo!"
flow.class.step_methods     #=> [:hello, :hola]

# or use ruby's (regular) message/metaprogramming machinery
flow.send( :step_hello )    #=> "Hello, world!"
flow.send( :step_hola  )    #=> "¡Hola, mundo!"
# or try
flow.class.instance_methods.grep( /^step_/ ) #=> [:step_hello, :step_hola]
# ...
```

Note 1:  The Flowfile "source / configuration":

``` ruby
step :hello do
  puts "Hello, world!"
end

step :hola do
  puts "¡Hola, mundo!"
end
```

gets used to (auto-) build (via metaprogramming) a flow class like:

``` ruby
class Greeter < Flow::Base
  def step_hello
    puts "Hello, world!"
  end

  def step_hola
    puts "¡Hola, mundo!"
  end
end
```


Note: Behind the stage the metaprogramming "class macro"
`define_step( symbol, method )`
or `define_step( symbol ) { block }` defined in `Flow::Base`
gets used, thus,
if you want to create steps in a "hand-coded" class
use:


``` ruby
class Greeter < Flow::Base
  define_step :hello do
    puts "Hello, world!"
  end

  define_step :hola do
    puts "¡Hola, mundo!"
  end
end
```




**Tips & Tricks**

Auto-include pre-build / pre-defined steps. Use a (regular) Module e.g.:

``` ruby
module GitHubActions
  def step_adduser
     # setup ssh
     ssh_key  = ENV['SSH_KEY']
     ssh_path = File.expand_path( '~/.ssh' )

     FileUtils.mkdir_p( ssh_path )   # make sure path exists
     File.open( "#{ssh_path}/id_rsa", 'w' ) { |f| f.write( ssh_key ) }
     File.chmod( 0600, "#{ssh_path}/id_rsa" )

     # setup git
     user_name  = ENV['GITHUB_NAME']  || 'you'
     user_email = ENV['GITHUB_EMAIL'] || 'you@example.com'

     Git.config( 'user.name',  user_name,  global: true )
     Git.config( 'user.email', user_email, global: true )

     # ...
  end
end
```

and than use (regular) include e.g.:

``` ruby
class Flow::Base
  include GitHubActions
end

#-or-

Flow::Base.include( GitHubActions )
```

Now all your flows can (re)use `adduser` or any other step methods you define.




## Real World Examples

**Collect GitHub Statistics Fortnightly**

Use GitHub Actions to collect
GitHub Statistics via GitHub API calls
and update the JSON datasets
in the `/cache.github` repo at the `yorobot` org(anization):

``` ruby
step :clone do
  Mono.clone( '@yorobot/cache.github' )
end


step :update do
  Hubba.config.data_dir = Mono.real_path( '@yorobot/cache.github' )

  username = 'geraldb'
  h = Hubba.reposet( username )
  pp h

  Hubba.update_stats( h )
  Hubba.update_traffic( h )
  puts "Done."
end


step :push do
  msg = "auto-update week #{Date.today.cweek}"

  Mono.open( '@yorobot/cache.github' ) do |proj|
    if proj.changes?
      proj.add( "." )
      proj.commit( msg )
      proj.push
    end
  end
end
```

(Sources: [`Flowfile`](https://github.com/yorobot/backup/blob/master/Flowfile.rb), [`workflows/update.yml`](https://github.com/yorobot/backup/blob/master/.github/workflows/update.yml) @ `yorobot/backup`)


**Build SQLite database (from Scratch) and Update .JSON Datasets Nightly**

Use GitHub Actions to build a SQLite football.db
from zero / scratch from the sources in the football.TXT format
and than update / generate the football.json datasets.


(Sources: [`Flowfile`](https://github.com/yorobot/football.json/blob/master/Flowfile.rb), [`workflows/update.yml`](https://github.com/yorobot/football.json/blob/master/.github/workflows/update.yml) @ `yorobot/football.json`)




Add your example / setup here!



## Installation

Use

    gem install flow-lite

or add to your Gemfile

    gem 'flow-lite'



## License

The `flow-lite` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

