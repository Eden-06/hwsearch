#!/usr/bin/ruby1.9.1
# encoding: UTF-8

require 'mechanize'

class System

 def initialize
  @modules=Hash.new
  @verbose=false
 end

 attr_reader( :verbose)
 attr_writer( :verbose)

 def [](shortcut)
  @modules[shortcut]
 end

 def register(key,mod)
  return nil if mod.nil? and mod.class < Module
  return nil if @modules.has_key?(key) or mod.nil? # should raise an error
  @modules[key]=mod
  self
 end

 def unregister(key)
  @modules[key]=nil
  self
 end

 def query(item,output)
  $stderr.puts "querying for %s..." % item if @verbose
	shops=[]
 	Mechanize.start do |agent|
		@modules.each_pair do|k,m|
			$stderr.puts " looking on %s" % k if @verbose
	 		m.query(agent,item,shops)
		end
	end
	a=item.clone
	a["available at"] = shops
	output << a
	# It may be more efficient to do the following
	#	item["available at"] = shops
	#	output << item
  true
 end

end
