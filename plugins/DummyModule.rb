#!/usr/bin/ruby1.9.1
# encoding: UTF-8


class DummyModule < Module

	def query(agent,item,output)
	  price=(rand(1000)/10.0)
    url=("http://dummy.net/products/%s" % item["name"])
		output <<( { "shop" => "dummy.net" , "price" => price, "currency" => "Euro", "url" => url } )
		true
	end

end

Run.system.register("dummy.net",DummyModule.new)
