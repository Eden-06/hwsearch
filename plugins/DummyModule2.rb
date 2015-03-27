#!/usr/bin/ruby1.9.1
# encoding: UTF-8


class DummyModule2 < Module

	def query(agent,item,output)
	  price=1000.00
    url=("http://dummy.com/products/%s"% item["name"])
		output <<( { "shop" => "dummy.net" , "price" => price, "currency" => "Dollar", "url" => url } )
		true
	end

end

Run.system.register("dummy.com",DummyModule2.new)
