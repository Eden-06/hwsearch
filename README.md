# hwsearch

**Hwsearch** is a tool to collect informations on hardware products from internet shops.

# Synopsis

```bash
ruby hwsearch.rb FILES
ruby bibfilter.rb -h
ruby bibfilter.rb -V
```

# Description

This is a commandline tool to query various shoping sites for products.
The list of products to search for must be given in yaml files.
Each product should at least have a name, but there might be other
additional informations given, as follows:
```yaml
Products:
- name: Test Product2
  manufacturer: Manu 2
  id: 1232341432
- name: Product 5
  manufacturer: Manu 2
  id: 1232341433
- ...
```
For each product, the tool queries the all shops for which a plugin
exists, and should return a combined result in the YAML, as follows:
```yaml
Products:
- name: Test Product
  manufacturer: Manu 1
  id: 1232341432
  available at:
  - shop: dummy.net
    price: 80.6
    currency: Euro
    url: http://dummy.net/products/Test Product
  - shop: dummy.net
    price: 1000.0
    currency: Dollar
    url: http://dummy.com/products/Test Product
  - ...
```
Currently, the tool only supports Dummy plugins meant as
a coding template for plugin developers.
Notably, each plugin can reuse the **Mechanize** agent provided by the tool
to perform the queries, in cases where the shop does not provides an API.
Any new plugin must be a subclass of Module and placed in the plugins 
directory.

# Options

  Flag | Description
 ----- | -------------------------
  -h   | Show this document.
  -v   | Produces verbose output.
  -V   | Shows the version number.-

# Requirements

* [ruby](https://github.com/ruby/ruby) => 1.9.1
* [mechanize](https://github.com/sparklemotion/mechanize) => 2.7.3
* [yaml](https://github.com/rubysl/rubysl-yaml) => 1.2.1

# Usage

```bash
ruby hwsearch.rb items.yaml 1> pricelist.yaml 
```

# Version
 0.1
