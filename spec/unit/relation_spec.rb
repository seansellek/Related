require 'spec_helper'

describe Relation do
  context "#add_tuple" do
    
    it "adds a tuple to the relation" do
      menu.add_tuple ["supreme", 10]
      expect( menu.tuples ).to eq(Set[["supreme", 10]])
    end
    it "throws an error if tuple is illegal for schema" do
      expect { menu.add_tuple ["supreme", "10"] }.to raise_error TypeError
    end
  end

  %w[⋈].each do |method| 
    xcontext "##{method}" do
      it "raises TypeError when no common attributes" do
        expect { menu.send method, people }.to raise_error TypeError
      end
      it "performs a natural join" do
        result = Relation.new(name: String, age: Numeric, gender: String, pizza: String) do |r|
          r.add_tuple ["Amy", 16, "female", "mushroom"]
          r.add_tuple ["Amy", 16, "female", "pepperoni"]
          r.add_tuple ["Ben", 21, "male", "cheese"]
        end
        expect(people.send(method, favorites)).to eq result
      end
    end
  end

  %w[𝜎].each do |method|
    context "##{method}" do
      it "performs select operation with given block as condition" do
        schema = Schema.new(name: String, pizza: String)
        result = Relation.new(schema) do |r|
          r.add_tuple ["Amy", "mushroom"]
          r.add_tuple ["Gus", "mushroom"]
        end
        expect( favorites.send(method) {|t| t[:pizza] == "mushroom" }).to eq(result)
      end
    end
  end
  
  let(:menu) do 
    Relation.new do |r|
      r.schema = Schema.new(pizza: String, price: Numeric)
    end 
  end
  let(:people) do 
    Relation.new do |r|
      r.schema = Schema.new(name: String, age: Numeric, gender: String)
      r.add_tuple ["Amy", 16, "female"]
      r.add_tuple ["Ben", 21, "male"]
    end
  end
  let(:favorites) do 
    Relation.new do |r|
      r.schema = Schema.new(name: String, pizza: String)
      r.add_tuple ["Amy", "mushroom"]
      r.add_tuple ["Amy", "pepperoni"]
      r.add_tuple ["Ben", "cheese"]
      r.add_tuple ["Gus", "mushroom"]
    end
  end
end
