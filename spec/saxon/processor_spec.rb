require 'spec_helper'
require 'saxon/processor'

describe Saxon::Processor do
  let(:xsl_file) { File.open(fixture_path('eg.xsl')) }

  context "without configuration" do
    let(:processor) { Saxon::Processor.create }

    it "can make a new XSLT instance" do
      expect(processor.XSLT(xsl_file)).to respond_to(:transform)
    end

    it "can make a new XML instance" do
      expect(processor.XML(xsl_file)).to be_a(Saxon::XML::Document)
    end

    it "can return the underlying Saxon Processor" do
      expect(processor.to_java).to respond_to(:new_xslt_compiler)
    end
  end

  context "with a configuration file" do
    it "works, given a valid config XML file" do
      processor = Saxon::Processor.create(File.open(fixture_path('config.xml')))

      saxon_processor = processor.to_java
      configuration = saxon_processor.underlying_configuration
      expect(configuration.xml_version).to eq(11)
    end
  end

  context "with configuration set post-creation" do
    it "works, with configuration set and gotten" do
      processor = Saxon::Processor.create()

      processor.set_config(:linenumbering => true)
      expect(processor.get_config(:linenumbering)).to eq(true)
      expect(processor.XML(File.open(fixture_path('eg.xml'))).xpath('/input').line_number).to be > 0

      processor.set_config(:linenumbering => false)
      expect(processor.get_config(:linenumbering)).to eq(false)
      expect(processor.XML(File.open(fixture_path('eg.xml'))).xpath('/input').line_number).to eq(-1)
    end
  end

  context "the default configuration" do
    it "creates a processor on demand" do
      expect(Saxon::Processor.default).to be_a(Saxon::Processor)
    end

    it "returns the same processor instance if called repeatedly" do
      expected = Saxon::Processor.default
      expect(Saxon::Processor.default).to be(expected)
    end
  end
end
