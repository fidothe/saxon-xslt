require 'saxon-xslt'
require 'stringio'

describe Saxon::Xslt do
  def fixture_path(path)
    File.expand_path(File.join('../../fixtures', path), __FILE__)
  end

  context "compiling the stylesheet" do
    it "can compile a stylesheet from a File object" do
      expect(Saxon::Xslt.compile(File.open(fixture_path('eg.xsl')))).to respond_to(:transform)
    end

    it "can compile a stylesheet from a string" do
      xsl = File.read(fixture_path('eg.xsl'))
      expect(Saxon::Xslt.compile(xsl)).to respond_to(:transform)
    end

    it "can compile a stylesheet from an IO object" do
      xsl = File.read(fixture_path('eg.xsl'))
      io = StringIO.new(xsl)
      expect(Saxon::Xslt.compile(io)).to respond_to(:transform)
    end
  end

  context "transforming a document" do
    let(:xsl) { Saxon::Xslt.compile(File.open(fixture_path('eg.xsl'))) }

    it "can transform a document from a File object" do
      expect(xsl.transform(File.open(fixture_path('eg.xml')))).to respond_to(:toString)
    end

    it "can transform a document from a string" do
      xml = File.read(fixture_path('eg.xml'))
      expect(xsl.transform(xml)).to respond_to(:toString)
    end

    it "can transform a document from an IO object" do
      xml = File.read(fixture_path('eg.xml'))
      io = StringIO.new(xml)
      expect(xsl.transform(io)).to respond_to(:toString)
    end
    
    context "the transform result" do
      let(:result) { xsl.transform(File.open(fixture_path('eg.xml'))) }

      it "can be serialised to a string with to_s" do
        expect(result.to_s.strip).to eq('<output/>')
      end

      it "can be used as the input document for a transform"
    end
  end
end
