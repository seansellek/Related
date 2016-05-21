require 'spec_helper'

describe Related::Tuple do
  let(:tuple) { Tuple.new(["Amy", 16, "female"]) }
  let(:schema) { Schema.new({name: String, age: 16, gender: "female"})}
  context "#[]" do
    it "when given name and schema returns triple" do
      expect(tuple[:name, schema]).to eq("Amy")
    end
    it "when given index returns value" do
      expect(tuple[0]).to eq("Amy")
    end
  end

  context "#values" do
    it "returns an array of values" do
      expect(tuple.values).to eq(["Amy", 16, "female"])
    end
  end

  context "#attributes" do
    it "returns a hash of attributes" do
      expect(tuple.attributes(schema)).to eq(name: "Amy", age: 16, gender: "female")
    end
  end

  context "#==" do
    it "matches against values when given array" do
      expect(tuple).to eq(["Amy", 16, "female"])
    end

  end
end
