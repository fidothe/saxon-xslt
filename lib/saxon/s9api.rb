require 'java'
$CLASSPATH << File.expand_path('../../../vendor/saxonica/saxon9he.jar', __FILE__)
$CLASSPATH << File.expand_path('../../../vendor/saxonica/saxon9-unpack.jar', __FILE__)

java_import javax.xml.transform.stream.StreamSource 

module Saxon
  module S9API
    java_import 'net.sf.saxon.s9api.Processor'
    java_import 'net.sf.saxon.s9api.XdmDestination'
  end
end
