require 'spec_helper'
require 'saxon/configuration'
require 'saxon/processor'

describe Saxon::Configuration do
  it "is instantiated from a java Configuration instance" do
    config = Saxon::Configuration.new(Saxon::S9API::Configuration.new)
    expect(config).to be_a(Saxon::Configuration)
  end

  context "creating a new instance safely" do
    it "can be created without a pre-existing processor" do
      expect(Saxon::Configuration.create).to be_a(Saxon::Configuration)
    end

    it "can be created correctly from a Processor" do
      processor = Saxon::Processor.create
      expect(Saxon::Configuration.create(processor)).to be_a(Saxon::Configuration)
    end
  end

  context "getting and setting options" do
    let(:config) { Saxon::Configuration.new(Saxon::S9API::Configuration.new) }

    it "can get a configuration option's current value" do
      expect(config[:line_numbering]).to be(false)
    end

    it "can set a configuration option to a new value" do
      config[:line_numbering] = true
      expect(config[:line_numbering]).to be(true)
    end

    it "returns the passed-in value when setting an option" do
      expect(config[:default_country] = 'NO').to eq('NO')
    end

    it "doesn't allow you to set a non-existent configuration option" do
      expect { config[:rubbish] = "value" }.to raise_error(NameError)
    end

    it "doesn't allow you to get a non-existent configuration option" do
      expect { config[:rubbish] }.to raise_error(NameError)
    end
  end
end
