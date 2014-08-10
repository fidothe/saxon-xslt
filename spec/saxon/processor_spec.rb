require 'spec_helper'
require 'saxon/processor'

describe Saxon::Processor do
  let(:xsl_file) { File.open(fixture_path('eg.xsl')) }

  context "without configuration" do
    let(:processor) { Saxon::Processor.new }

    it "can make a new XSLT instance" do
      expect(processor.XSLT(xsl_file)).to respond_to(:transform)
    end

    it "can make a new XML instance" do
      expect(processor.XML(xsl_file)).to respond_to(:node_kind)
    end
  end

  context "with a configuration file" do
    it "works, given a valid config XML file" do
      processor = Saxon::Processor.new(File.open(fixture_path('config.xml')))

      saxon_processor = processor.instance_variable_get(:@processor)
      configuration = saxon_processor.underlying_configuration
      expect(configuration.xml_version).to eq(11)
    end
  end
end
