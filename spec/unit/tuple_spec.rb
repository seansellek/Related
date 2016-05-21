require 'spec_helper'

describe Related::Tuple do
  let(:tuple) { Tuple.new(Schema.new(name: String, age: Integer, gender: String), ["Amy", 16, "gender"]) }
  context "#[]" do
    it "when given name returns triple" do
      expect(tuple[:name]).to eq("Amy")
    end
    it "when given index returns value" do
      expect(tuple[0]).to eq("Amy")
    end
  end
end
