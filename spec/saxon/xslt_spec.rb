require 'spec_helper'
require 'saxon-xslt'
require 'stringio'

describe Saxon::XSLT do
  context "compiling the stylesheet" do
    it "can compile a stylesheet from a File object" do
      expect(Saxon.XSLT(File.open(fixture_path('eg.xsl')))).to respond_to(:transform)
    end

    it "can compile a stylesheet from a string" do
      xsl = File.read(fixture_path('eg.xsl'))
      expect(Saxon.XSLT(xsl)).to respond_to(:transform)
    end

    it "can compile a stylesheet from an IO object" do
      xsl = File.read(fixture_path('eg.xsl'))
      io = StringIO.new(xsl)
      expect(Saxon.XSLT(io)).to respond_to(:transform)
    end
  end

  context "transforming a document" do
    context "emitting a Document object as the result" do
      let(:xsl) { Saxon.XSLT(File.open(fixture_path('eg.xsl'))) }
      let(:xml) { Saxon.XML(File.open(fixture_path('eg.xml'))) }

      it "takes a Document object as input for a transformation" do
        expect(xsl.transform(xml)).to respond_to(:getNodeKind)
      end

      context "the transform result" do
        let(:result) { xsl.transform(xml) }

        it "was produced by a correctly executed XSLT" do
          expect(result.to_s.strip).to eq('<output/>')
        end

        it "can be used as the input document for a transform" do
          expect(xsl.transform(result).to_s.strip).to eq('<piped/>')
        end
      end
    end
  end
end
