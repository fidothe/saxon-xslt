require 'spec_helper'
require 'saxon/xml'

java_import 'net.sf.saxon.s9api.XdmNodeKind'
java_import 'net.sf.saxon.s9api.XdmNode'

describe Saxon::XML do
  let(:processor) { Saxon::Processor.create }

  context "parsing a document" do
    it "returns a Document (wrapper) object" do
      doc = processor.XML('<input/>')
      expect(doc.class).to be(Saxon::XML::Document)
    end

    it "makes the underlying Saxon XDM document available" do
      doc = processor.XML('<input/>')
      expect(doc.to_java.class).to be(XdmNode)
    end

    it "can parse a document from a File object" do
      doc = processor.XML(File.open(fixture_path('eg.xml')))
      expect(doc.to_java.node_kind).to eq(XdmNodeKind::DOCUMENT)
    end

    it "can parse a document from a string" do
      xml = File.read(fixture_path('eg.xml'))
      doc = processor.XML(xml)
      expect(doc.to_java.node_kind).to eq(XdmNodeKind::DOCUMENT)
    end

    it "can parse a document from an IO object" do
      xml = File.read(fixture_path('eg.xml'))
      io = StringIO.new(xml)
      doc = processor.XML(io)
      expect(doc.to_java.node_kind).to eq(XdmNodeKind::DOCUMENT)
    end

    it "can set the system ID of a parsed document" do
      xml = File.read(fixture_path('eg.xml'))
      doc = processor.XML(xml, system_id: 'http://example.org/')

      expect(doc.to_java.document_uri.to_s).to eq('http://example.org/')
    end
  end

  it "can produce a simple serialisation of its content" do
    doc = processor.XML('<input/>')
    expect(doc.to_s.strip).to eq('<input/>')
  end

  it "can return the Saxon::Processor it was created with" do
    doc = processor.XML('<input/>')
    expect(doc.processor).to eq(processor)
  end

  describe "the default processor convenience" do
    it "passes through to XML() on the default processor" do
      expect(Saxon::Processor.default).to receive(:XML).with(:io, :opts)

      Saxon.XML(:io, :opts)
    end
  end
end
