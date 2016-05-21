require 'spec_helper'

describe Related::Tuple do
  let(:w) { Tuple.new(pizzeria: "Dominos", pizza: "supreme", price: 11)}
  let(:x) { Tuple.new(name: "Amy", age: 16, gender: "female") }
  let(:y) { Tuple.new(name: "Amy", pizzeria: "Dominos") }
  let(:z) { Tuple.new(name: "Amy", age: 16, gender: "female", pizzeria: "Dominos")}
  
  context "#& (natural_join)" do
    it "returns nil when no matching keys" do
      expect(w & x).to be_nil
    end

    it "returns tuple joined on matching key" do
      expect(x & y).to eq(z)
    end
  end
end
