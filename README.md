# Saxon::Xslt

Wraps the Saxon 9 HE XSLT processor Java API so it's easy to use from your JRuby project

This is a super-minimal first cut, it doesn't do many, many, things that it should and it is entirely untested. You probably shouldn't be using in production systems.

It only runs under JRuby.

You can find Saxon HE at http://sourceforge.net/projects/saxon/ and Saxonica at http://www.saxonica.com/

Saxon HE is (c) Michael H. Kay and released under the Mozilla MPL 1.0 (http://www.mozilla.org/MPL/1.0/)

## Installation

Add this line to your application's Gemfile:

    gem 'saxon-xslt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install saxon-xslt

## Usage

```ruby
require 'saxon-xslt'
transformer = Saxon::Xslt.new('/path/to/your.xsl')
output = transformer.transform('/path/to/your.xml')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
