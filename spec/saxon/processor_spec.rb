require 'spec_helper'
require 'saxon/processor'

describe Saxon::Processor do
  let(:processor) { Saxon::Processor.new }
  let(:xsl_file) { File.open(fixture_path('eg.xsl')) }

  it "can make a new XSLT instance" do
    expect(processor.XSLT(xsl_file)).to respond_to(:transform)
  end

  it "can make a new XML instance" do
    expect(processor.XML(xsl_file)).to respond_to(:node_kind)
  end
end
