require 'spec_helper'

describe Schema do
  let(:schema) { described_class.new name: String, age: Numeric, gender: String }

  context "#match" do
    it "returns true if array's types match schema" do
      expect( schema.match? ["Amy", 16, "female"] ).to be_truthy
    end
    it "returns false if array's types does not match schema" do
      expect( schema.match? [16, "Amy", "female"] ).to be_falsey
    end
  end

  context "#rename" do
    it "takes a hash of attributes to rename and returns a new schema" do
      expect(schema.rename(gender: :sex)).to eq(described_class.new name: String, age: Numeric, sex: String)
    end
  end

  context "#similar" do
    it "returns a new schema with the same attributes" do
      expect(schema.similar).to eq(schema)
    end
  end

  context "#names" do
    it "returns array of attribute names" do
      expect(schema.names).to eq([:name, :age, :gender])
    end
  end

  context "#project" do
    it "returns schema with projection applied" do
      expect(schema.project([:gender, :age])).to eq(Schema.new(gender: String, age: Numeric))
    end

  end
end
