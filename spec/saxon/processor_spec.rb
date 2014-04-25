require 'spec_helper'
require 'stringio'

describe Saxon::Processor do
  let(:processor) { Saxon::Processor.new }
  let(:xsl_file) { File.open(fixture_path('eg.xsl')) }

  it 'can make a new XSLT instance' do
    expect(processor.XSLT(xsl_file)).to respond_to(:transform)
  end

  it 'can make a new XML instance' do
    expect(processor.XML(xsl_file)).to respond_to(:getNodeKind)
  end

  describe 'initialization with configuration' do
    let(:config) { StringIO.new('<configuration xmlns="http://saxon.sf.net/ns/configuration"
                                  edition="HE"><global versionOfXml="1.1"/></configuration>') }
    let(:processor) { Saxon::Processor.new(config) }

    it 'can load an optional Saxon configuration file' do
      expect(processor.configuration).not_to be_nil
      expect(processor.configuration.xml_version).to eq(11)
    end
  end
end
