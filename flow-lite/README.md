# flow-lite

flow-lite gem - (yet) another (lite) workflow engine; let's you define your workflow steps in Flowfiles; incl. the flow command line tool


* home  :: [github.com/rubycoco/git](https://github.com/rubycoco/git)
* bugs  :: [github.com/rubycoco/git/issues](https://github.com/rubycoco/git/issues)
* gem   :: [rubygems.org/gems/flow-lite](https://rubygems.org/gems/flow-lite)
* rdoc  :: [rubydoc.info/gems/flow-lite](http://rubydoc.info/gems/flow-lite)



## Usage


Define the workflow steps in a Flowfile. Example:


``` ruby
step :first_step do
  puts "first_step"
  second_step    # note: you can call other steps like methods
end

step :second_step do
  puts "second_step"
  third_step
end

step :third_step do
  puts "third_step"
end
```

And than use the `flow` command line tool to run a step.
Example:

```
$ flow first_step
```

Note: By default the `flow` command line tool reads in the `Flowfile`. Use `-f/--flowfile` option to use a different file.


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

flow = flowfile.flow   # (auto-)builds a flow class (see Note 1)
                       # and constructs/returns an instance
flow.hello             #=> "Hello, world!"
flow.hola              #=> "¡Hola, mundo!"

# or use ruby's (regular) message/metaprogramming machinery
flow.send( :hello )    #=> "Hello, world!"
flow.send( :hola  )    #=> "¡Hola, mundo!"
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
  def hello
    puts "Hello, world!"
  end
  alias_method :step_hello, :hello

  def hola
    puts "¡Hola, mundo!"
  end
  alias_method :step_hola, :hola
end
```



**Tips & Tricks**

Auto-include pre-build / pre-defined steps. Use a (regular) Module e.g.:

``` ruby
module GitHubActions
  def setup
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
  # optional - for auto-discovery add a step alias
  alias_method :step_setup, :setup
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

Now all your flows can (re)use `setup` or any other methods you define.





## Installation

Use

    gem install flow-lite

or add to your Gemfile

    gem 'flow-lite'



## License

The `flow-lite` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

