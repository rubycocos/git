module Flow

class Tool
  def self.main( args=ARGV )
    options = {}
    OptionParser.new do |parser|
      parser.on( '-f FILE', '--file FILE', '--flowfile FILE',
                    'Read FILE as a flowfile.'
               ) do |file|
        options[:flowfile] = file
      end

      ## note:
      ##  you can add many/multiple modules
      ##  e.g. -r gitti -r mono etc.
      parser.on( '-r NAME', '--require NAME') do |name|
        options[:requires] ||= []
        options[:requires] << name
      end

      parser.on( '-d', '--debug') do |debug|
        options[:debug] = debug
        ## note: for no auto-set env here - why? why not
        ENV['DEBUG']='1'   ## use t or true or such - why? why not?
        puts "[flow]   set >DEBUG< env variable to >1<"
      end

      ## todo/check/reserve:  add  -e/--env(iornmanet)  e.g.  dev/test/prod(uction) etc.
      ##             plus (convenience) shortcuts  e.g.  --dev, --prod(uction), --test
    end.parse!( args )


    ## check for any (dynamic/auto) requires
    if options[:requires]
      names = options[:requires]
      names.each do |name|
        ## todo/check: add some error/exception handling here - why? why not?
        puts "[flow] auto-require >#{name}<..."
        require( name )
      end
    else  ## use/try defaults
      config_path = "./config.rb"
      if File.exist?( config_path )
        puts "[flow] auto-require (default) >#{config_path}<..."
        require( config_path )
      end
    end


    path = nil
    if options[:flowfile]
      path = options[:flowfile]
    else
      path = Flowfile.find_file

      if path.nil?
        STDERR.puts "!! ERROR - no flowfile found, sorry - looking for: #{Flowfile::NAMES.join(', ')} in (#{Dir.pwd})"
        exit 1
      end
    end


    ### split args into vars and steps
    vars = []
    args = args.select do |arg|
      ## note: mark freestanding = as fatal error (empty var)
      if arg == '='
        STDERR.puts "!! ERROR - empty var (=) in args; sorry - make sure there are NO spaces before ="
        exit 1
      elsif arg =~ /^[A-Za-z][A-Za-z0-9_]*=/
        vars << arg
        false    ## filter -- do NOT include
      else
        true
      end
    end

    if args.size > 0
      puts "[flow] #{args.size} arg(s):"
      pp args
    end

    if vars.size > 0
      puts "[flow] #{vars.size} var(s):"
      pp vars

      ## auto-add vars to ENV
      ##   note: if the value is empty e.g. DEBUG= or such
      ##         the variable gets deleted / undefined / unset!!
      vars.each do |var|
        pos = var.index('=')   ## split on first =
        name  = var[0..(pos-1)]
        value = var[(pos+1)..-1]
        # print "[flow] splitting "
        # print "%-24s  "  % ">#{var}<"
        # print "=>  name: "
        # print "%-18s " % ">#{name}<,"
        # print "value: >#{value}< (#{value.class.name})"
        # print "\n"

        if value.empty?  ## note: variable gets deleted / undefined / unset
           puts "[flow]   UNSET >#{name}< env variable"
           ENV[ name ] = nil
        else
           puts "[flow]   set >#{name}< env variable to >#{value}<"
           ENV[ name ] = value
        end
      end
    end



    puts "[flow] loading >#{path}<..."
    flowfile = Flowfile.load_file( path )



    ## allow multipe steps getting called - why? why not?
    ##   flow setup clone update   etc.  - yes, yes
    ##    follow make model and allow variables with FOO= or bar= too
    ##    note:  mark freestanding = as fatal error (empty var)

    args.each do |arg|
      flowfile.run( arg )
    end
  end # method self.main
end # class Tool


end # module Flow