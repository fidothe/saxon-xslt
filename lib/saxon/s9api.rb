require 'java'
$CLASSPATH << File.expand_path('../../../vendor/saxonica/saxon9he.jar', __FILE__)
$CLASSPATH << File.expand_path('../../../vendor/saxonica/saxon9-unpack.jar', __FILE__)

module Saxon
  # Puts the Saxon Java classes into a sensible namespace
  module S9API
    java_import 'net.sf.saxon.s9api.Processor'
    java_import 'net.sf.saxon.Configuration'
    java_import 'net.sf.saxon.lib.FeatureKeys'
    java_import 'net.sf.saxon.s9api.XdmDestination'
    java_import 'net.sf.saxon.s9api.QName'
  end
end
