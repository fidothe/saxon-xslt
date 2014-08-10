require 'spec_helper'
require 'stringio'
require 'open-uri'
require 'saxon/source_helper'

java_import org.jruby.embed.io.ReaderInputStream

describe Saxon::SourceHelper do
  describe "returning a StreamSource" do
    context "for input backed by a StringReader" do
      it "converts a String correctly" do
        input = "Hello mum"
        source = Saxon::SourceHelper.to_stream_source(input)
        stream = ReaderInputStream.new(source.reader)

        expect(source).to respond_to(:system_id)
        expect(stream.to_io.read).to eq(input)
      end
    end

    context "for input backed by an InputStream" do
      it "converts a File correctly" do
        path = fixture_path('eg.xml')
        source = Saxon::SourceHelper.to_stream_source(File.open(path))

        expect(source).to respond_to(:system_id)
        expect(source.input_stream.to_io.read).to eq(File.read(path))
      end

      it "converts a StringIO correctly" do
        input = "Hello mum"
        source = Saxon::SourceHelper.to_stream_source(StringIO.new(input))

        expect(source).to respond_to(:system_id)
        expect(source.input_stream.to_io.read).to eq(input)
      end

      it "converts an open-uri'd File correctly" do
        path = fixture_path('eg.xml')
        uri = "file://#{path}"
        source = Saxon::SourceHelper.to_stream_source(open(uri))

        expect(source).to respond_to(:system_id)
        expect(source.input_stream.to_io.read).to eq(File.read(path))
      end

      it "converts an open-uri'd Uri correctly", :vcr do
        uri = "http://example.org/"
        expected = open(uri).read
        source = Saxon::SourceHelper.to_stream_source(open(uri))

        expect(source).to respond_to(:system_id)
        expect(source.input_stream.to_io.read).to eq(expected)
      end
    end

    context "StreamSource systemId" do
      context "for inputs where we can't infer the path or URI" do
        it "is set to nil for Strings" do
          input = "Hello mum"
          source = Saxon::SourceHelper.to_stream_source(input)

          expect(source.system_id).to be(nil)
        end

        it "is set to nil for StringIOs" do
          input = "Hello mum"
          source = Saxon::SourceHelper.to_stream_source(StringIO.new(input))

          expect(source.system_id).to be(nil)
        end

        it "can be set explicitly" do
          input = "Hello mum"
          source = Saxon::SourceHelper.to_stream_source(input,
            system_id: '/path/to/src'
          )

          expect(source.system_id).to eq('/path/to/src')
        end
      end

      context "for inputs where we can infer the path or URI" do
        it "is set to a File's path" do
          path = fixture_path('eg.xml')
          source = Saxon::SourceHelper.to_stream_source(File.open(path))

          expect(source.system_id).to eq(path)
        end

        it "is set to an open-uri'd File's URI" do
          path = fixture_path('eg.xml')
          uri = "file://#{path}"
          source = Saxon::SourceHelper.to_stream_source(open(uri))

          expect(source.system_id).to eq(uri)
        end

        it "is set to an open-uri'd URI's URI", :vcr do
          uri = "http://example.org/"
          source = Saxon::SourceHelper.to_stream_source(open(uri))

          expect(source.system_id).to eq(uri)
        end

        it "overrides the inferred system ID if set explicitly", :vcr do
          uri = "http://example.org/"
          source = Saxon::SourceHelper.to_stream_source(open(uri),
            system_id: '/path/to/src'
          )

          expect(source.system_id).to eq('/path/to/src')
        end
      end
    end
  end
end
