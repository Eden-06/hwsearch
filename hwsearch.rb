#!/usr/bin/ruby1.9.1
# encoding: UTF-8

Version="0.1"
Documentation=<<EOS
NAME
 hwsearch - is a tool to collect informations on hardware products from internet shops.

SYNOPSIS
 ruby hwsearch.rb FILES
 ruby bibfilter.rb -h
 ruby bibfilter.rb -V

DESCRIPTION
 This commandline tool to query various shoping sites for products.
 The list of products to search for must be given in yaml files.
 Each product should at least have a name, but there might be other
 additional informations given.
 For each product, the tool queries the all shops for which a plugin
 exists, and should return a combined result in the YAML.
 Currently, the tool only supports Dummy plugins meant as a coding 
 template for plugin developers. Notably, each plugin can reuse the 
 **Mechanize** agent provided by the tool to perform the queries, in 
 cases where the shop does not provides an API.
 Any new plugin must be a subclass of Module and placed in the
 plugins directory.

OPTIONS
 -h    Show this document.
 -v    produces verbose output.
 -V    Shows the version number.

USAGE
 ruby hwsearch.rb items.yaml 1> pricelist.yaml 

AUTHOR
 Thomas "Eden_06" Kuehn

VERSION
 %s
EOS

require 'yaml'
require "./core/System.rb"
require "./core/Module.rb"


#Class Defintiion

class Run

    def Run.system
       @@system
    end
    
    def Run.verbose
      @@system.verbose
    end

    def Run.verbose=(value)
      @@system.verbose=value
    end

    system=@@system=System.new

    if FileTest.directory?("plugins") then
      $stderr.puts "loading plugins..." if system.verbose
      Dir.open("plugins") do|dir|
        dir.each do |file|
          path=sprintf("./plugins/%s",file)
          ext=file.split(".").last
          next if not FileTest.file?(path)
          next if not FileTest.readable?(path)
          next if not (ext.downcase == "rb")
          require path
        end
      end
    end

end

# begin of execution
files=[]
key='-q'
Run.verbose=false

ARGV.each do|x| 
 case x
  when /^-q$/
  	key=$~.to_s
  when /^-[hV]$/
   key=$~.to_s
  when /^-v$/
   Run.verbose=true
  else
   files << x
  end
end

if files.empty? or key=="-h"
 puts Documentation % Version
 exit(1)
end

if key=="-V"
 puts Version
 exit(1)
end

files.each do|file|
  unless File.exists?(file)
   $stderr.puts "The selected file %s did not exist." % file
   exit(2)
  end
end

items=[]
files.each do|file|
  open(file,"r") do|f|
   yaml=YAML.load(f)
   if yaml.respond_to?(:has_key?) and yaml.has_key?("Products")
     items.concat yaml["Products"]
   elsif yaml.respond_to?(:to_a)
     items.concat yaml.to_a 
   else
     #items << yaml would be unsafe
   end
  end
end

$stderr.puts items
$stderr.puts "got %d products to search for"%items.size if Run.verbose

output=[]

items.each do|i|
 Run.system.query(i,output)
end

$stdout.puts( ({ "Products" => output }).to_yaml() )
