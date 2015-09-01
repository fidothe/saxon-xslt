# Saxon::Xslt

Wraps the Saxon 9 HE XSLT processor Java API so it's easy to use from your JRuby project, with an API modelled on Nokogiri's.

Saxon HE is a Java library, so saxon-xslt only runs under JRuby.

[![Gem Version](https://badge.fury.io/rb/saxon-xslt.svg)](http://badge.fury.io/rb/saxon-xslt)
[![Build Status](https://travis-ci.org/fidothe/saxon-xslt.png)](https://travis-ci.org/fidothe/saxon-xslt)
[![Code Climate](https://codeclimate.com/github/fidothe/saxon-xslt/badges/gpa.svg)](https://codeclimate.com/github/fidothe/saxon-xslt)
[![Test Coverage](https://codeclimate.com/github/fidothe/saxon-xslt/badges/coverage.svg)](https://codeclimate.com/github/fidothe/saxon-xslt/coverage)

You can find Saxon HE at http://saxon.sourceforge.net/ and Saxonica at http://www.saxonica.com/

Saxon HE is (c) Michael H. Kay and released under the Mozilla MPL 1.0 (http://www.mozilla.org/MPL/1.0/)

## Installation

Add this line to your application's Gemfile:

    gem 'saxon-xslt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install saxon-xslt

## Simple usage

```ruby
require 'saxon-xslt'
transformer = Saxon.XSLT(File.open('/path/to/your.xsl'))
input = Saxon.XML(File.open('/path/to/your.xml'))
output = transformer.transform(input)
```

XSL parameters can be passed to `#transform` as a flat array of `name`, `value` pairs, or as a hash. `name` can be either a string or a symbol, e.g.

```ruby
output = transformer.transform(input, ["my-param", "'my-value'",
                                       :'my-other-param', "/take-from@id"])

# or

output = transformer.transform(input, {"my-param" => "'my-value'",
                                       :'my-other-param' => "/select-from@id",
                                       my_third_param: "'value-again'"})
```

For those familiar with the Saxon API, names are passed directly to the QName constructor.

Values are evaluated as XPath expressions in context of the document being transformed; this means
that, to pass a string, you must pass an XPath that resolves to a string, i.e. "'You must wrap strings in quotes'"

## Saxon version
`saxon-xslt` 0.7 includes Saxon HE 9.5.1.7

## Differences between Saxon and Nokogiri

Saxon uses a `Processor` class as its central object: it holds configuration information and acts as a Factory for creating documents or XSLT stylesheet compilers. Unless you need to tweak the config you don't need to worry about this – `saxon-xslt` creates a shared instance behind the scenes when you call `Saxon.XSLT` or `Saxon.XML`. If you need to change the configuration you can create your own instance of `Saxon::Processor` and pass it an open `File` pointing at a Saxon configuration file. (See http://www.saxonica.com/documentation/index.html#!configuration/configuration-file for details of the configuration file.) Once you have a `Saxon::Processor` instance you can call the `XML` and `XSLT` methods on it directly:

```ruby
require 'saxon-xslt'
processor = Saxon::Processor.new(File.open('/path/to/config.xml'))
transformer = processor.XSLT(File.open('/path/to/your.xsl'))
input = processor.XML(File.open('/path/to/your.xml'))
output = transformer.transform(input)
```

### System IDs
XML has this idea of 'Public' and 'System' identifiers for documents. The public ID is a kind of abstract name and the system ID is a URI, for example:

```xml
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
            "http://www.w3.org/TR/html4/loose.dtd">
```

There the Public ID is `-//W3C//DTD HTML 4.01 Transitional//EN` and the System ID is `http://www.w3.org/TR/html4/loose.dtd`. An XML or XSLT processor uses the System ID as a base URI for resolving linked objects, e.g. `<xsl:import>` or `<xsl:include>` calls with relative URIs.

With Nokogiri the System ID for a document is inferred from its file path, if you hand in a `File` object to `Nokogiri::XML`. With `saxon-xslt` you can also explicitly set the System ID:

```ruby
xslt = Saxon.XSLT("<xsl:stylesheet>...</xsl:stylesheet>",
  system_id: "/path/to/resources/file.xsl")
```

So, if you have other XSLT stylesheets in `/path/to/resources/` then your dynamically generated XSLT can refer to them with import statements like `<xsl:import href="other_stylesheet.xsl"/>`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
