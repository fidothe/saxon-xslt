require 'java'
$CLASSPATH << File.expand_path('../../vendor/saxonica/saxon9he.jar', __FILE__)
$CLASSPATH << File.expand_path('../../vendor/saxonica/saxon9-unpack.jar', __FILE__)

java_import javax.xml.transform.stream.StreamSource

require 'saxon/s9api'
require 'saxon/source_helpers'
require 'saxon/processor'
require 'saxon/xml'
require 'saxon/xslt'