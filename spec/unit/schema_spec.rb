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

  context "#[]" do
    it "returns Attribute Header containing name, type, and index when given name" do
      attribute = schema[:name]
      expect(attribute[:name]).to eq(:name)
      expect(attribute[:type]).to eq(String)
      expect(attribute[:index]).to be_a(Integer)
    end

    it "returns Attribute Header containing name, type, and index when given index" do
      index = schema[:name].index
      attribute = schema[index]
      expect(attribute[:name]).to eq(:name)
      expect(attribute[:type]).to eq(String)
      expect(attribute[:index]).to be_a(Integer)
    end
  end
end
