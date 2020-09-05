###
##  check for VERSION if accessible in modules if included


module AAA
  AAA = "AAA"
end

module BBB
  VERSION = "2.2.BBB"


  def self.root
    puts "BBB.root"
  end
end


puts BBB::VERSION   #  2.2.BBB

module AAA
  include BBB
end

puts AAA::VERSION    # 2.2.BBB


module AAA
  VERSION = "1.1.AAA"
end

puts AAA::VERSION   # 1.1.AAA
puts BBB::VERSION   # 2.2.BBB


puts BBB.root
## puts AAA.root   #=> undefined method `root' for AAA:Module (NoMethodError)


