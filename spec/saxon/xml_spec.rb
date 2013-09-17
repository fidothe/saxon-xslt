require 'spec_helper'
require 'saxon/xml'

describe Saxon::XML do
  context "parsing a document" do
    it "can parse a document from a File object" do
      expect(Saxon.XML(File.open(fixture_path('eg.xml')))).to respond_to(:getNodeKind)
    end

    it "can parse a document from a string" do
      xml = File.read(fixture_path('eg.xml'))
      expect(Saxon.XML(xml)).to respond_to(:getNodeKind)
    end

    it "can parse a document from an IO object" do
      xml = File.read(fixture_path('eg.xml'))
      io = StringIO.new(xml)
      expect(Saxon.XML(io)).to respond_to(:getNodeKind)
    end
  end
end
