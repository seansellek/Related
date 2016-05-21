require 'spec_helper'

describe Relation do
  context "#add_tuple" do
    let(:pizza) { Relation.new name: String, price: Numeric }
    it "adds a tuple to the relation" do
      pizza.add_tuple ["supreme", 10]
      expect( pizza.tuples ).to eq(Set[["supreme", 10]])
    end
    it "throws an error if tuple is illegal for schema" do
      expect { pizza.add_tuple ["supreme", "10"] }.to raise_error TypeError
    end
  end

  %w[⋈ natural_join].each do |method| 
    context "##{method}" do
      it "performs a natural join"
    end
  end

  let(:people) do 
    Relation.new(name: String, age: Fixnum, gender: String) do |r|
      r.add_tuple ["Amy", 16, "female"]
      r.add_tuple ["Ben", 21, "male"]
      r.add_tuple ["Fay", 45, "female"]
    end
  end
  let(:favorites) do 
    Relation.new(name: String, pizza: String) do |r|
      r.add_tuple ["Amy", "mushroom"]
      r.add_tuple ["Amy", "pepperoni"]
      r.add_tuple ["Fay", "cheese"]
      r.add_tuple ["Fay", "pepperoni"]
      r.add_tuple ["Ben", "cheese"]
      r.add_tuple ["Gus", "mushroom"]
    end
  end
end
