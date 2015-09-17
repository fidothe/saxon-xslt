require 'spec_helper'
require 'saxon-xslt'
require 'stringio'

describe Saxon::XSLT do
  let(:processor) { Saxon::Processor.create }

  context "compiling the stylesheet" do
    it "can compile a stylesheet from a File object" do
      expect(processor.XSLT(File.open(fixture_path('eg.xsl')))).to respond_to(:transform)
    end

    it "can compile a stylesheet from a string" do
      xsl = File.read(fixture_path('eg.xsl'))
      expect(processor.XSLT(xsl)).to respond_to(:transform)
    end

    it "can compile a stylesheet from an IO object" do
      xsl = File.read(fixture_path('eg.xsl'))
      io = StringIO.new(xsl)
      expect(processor.XSLT(io)).to respond_to(:transform)
    end

    it "can set the system ID of the Stylesheet correctly" do
      xml = File.read(fixture_path('simple-xsl-import.xsl'))
      xslt = processor.XSLT(xml, system_id: fixture_path('samedir.xsl'))

      # We test this by using an XSL which calls xsl:import with a relative path
      # The relative path breaks unless the system ID is correctly set
      expect(xslt).to respond_to(:transform)
    end

    it "can compile a stylesheet from a Saxon::XML::Document" do
      input = processor.XML(File.open(fixture_path('eg.xsl')))
      xslt = Saxon::XSLT::Stylesheet.new(input)
      expect(xslt).to respond_to(:transform)
    end

    it "provides the parse_stylesheet_doc method to compile from a Saxon::XML::Document" do
      input = processor.XML(File.open(fixture_path('eg.xsl')))
      xslt = Saxon::XSLT::Stylesheet.parse_stylesheet_doc(input)
      expect(xslt).to respond_to(:transform)
    end
  end

  context "transforming a document" do
    context "emitting a Document object as the result" do
      let(:xsl) { processor.XSLT(File.open(fixture_path('eg.xsl'))) }
      let(:xml) { processor.XML(File.open(fixture_path('eg.xml'))) }

      it "takes a Document object as input for a transformation" do
        expect { xsl.transform(xml) }.not_to raise_error
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

      context "when passing global parameters at transform time" do
        let(:xsl) { processor.XSLT(File.open(fixture_path('params-eg.xsl'))) }

        context "using hash params" do
          let(:result) { xsl.transform(xml, {"testparam" => "'non-default'"}) }

          it "contains the parameter value string" do
            expect(result.to_s.strip).to include("non-default")
          end
        end

        context "using hash params with symbol keys" do
          let(:result) { xsl.transform(xml, testparam: "'non-default'") }

          it "contains the parameter value string" do
            expect(result.to_s.strip).to include("non-default")
          end
        end

        context "using array params" do
          let(:result) { xsl.transform(xml, ["testparam", "'non-default'"]) }

          it "contains the parameter value string" do
            expect(result.to_s.strip).to include("non-default")
          end
        end

        context "using malformed array params" do
          it "should raise ArgumentError" do
            expect{xsl.transform(xml, ["testparam", "'non-default'", "'wrongo'"])}.to raise_error(ArgumentError)
          end
        end

        context "using a selection from the input" do
          let(:result) { xsl.transform(xml, ["testparam", "local-name(/input)"]) }

          it "should contain the name of the tag" do
          expect(result.to_s.strip).to include('Select works')
          end
        end
      end
    end
  end

  describe "applying a stylesheet to a document and returning a serialised XML string" do
    let(:xsl) { processor.XSLT(File.open(fixture_path('eg.xsl'))) }
    let(:xml) { processor.XML(File.open(fixture_path('eg.xml'))) }

    it "returns XML as a string" do
      result = xsl.apply_to(xml)

      expect(result).to match(/<output\/>/)
    end

    it "correctly invokes transform" do
      expect(xsl).to receive(:transform).with(xml, {})

      xsl.apply_to(xml)
    end

    it "correctly passes params through to transform" do
      expect(xsl).to receive(:transform).with(xml, {"param" => "'value'"})

      xsl.apply_to(xml, {"param" => "'value'"})
    end
  end

  describe "the default processor convenience" do
    it "passes through to XSLT() on the default processor" do
      expect(Saxon::Processor.default).to receive(:XSLT).with(:io, :opts)

      Saxon.XSLT(:io, :opts)
    end
  end
end
