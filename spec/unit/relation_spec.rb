require 'spec_helper'

describe Relation do
  context "#add_tuple" do
    
    it "adds a tuple to the relation" do
      menu.add_tuple ["supreme", 10]
      expect( menu ).to include(["supreme", 10])
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

  %w[𝜎 select].each do |method|
    context "##{method}" do
      it "performs select operation with given block as condition" do
        result = Relation.new do |r|
          r.schema = Schema.new(name: String, pizza: String)
          r.add_tuple ["Amy", "mushroom"]
          r.add_tuple ["Gus", "mushroom"]
        end
        expect( favorites.send(method) {|t| t[:pizza] == "mushroom" }).to eq(result)
      end
    end
  end

  %w[π project].each do |method|
    context "##{method}" do
      it "performs projection with given attribute names" do
        result = Relation.new do |r|
          r.schema = Schema.new(name: String)
          r.add_tuple ["Amy"]
          r.add_tuple ["Gus"]
          r.add_tuple ["Ben"]
        end
        expect( favorites.send(method, [:name])).to eq(result)
      end
    end
  end

  %w[ρ rename].each do |method|
    context "##{method}" do
      it "performs rename of attributes in relation" do
        result = Relation.new do |r|
          r.schema = Schema.new(person_name: String, pizza_name: String)
          r.add_tuple ["Amy", "mushroom"]
          r.add_tuple ["Amy", "pepperoni"]
          r.add_tuple ["Ben", "cheese"]
          r.add_tuple ["Gus", "mushroom"]
        end
        expect(favorites.send(method, [:person_name, :pizza_name])).to eq(result)
      end
    end
  end

  %w[∩ intersection].each do |method|
    context "##{method}" do
      it "performs intersection" do
        people2 = Relation.new do |r|
          r.schema = Schema.new(name: String, age: Numeric, gender: String)
          r.add_tuple ["Ben", 21, "male"]
          r.add_tuple ["Gus", 45, "male"]
        end
        result = Relation.new do |r|
          r.schema = Schema.new(name: String, age: Numeric, gender: String)
          r.add_tuple ["Ben", 21, "male"]
        end
        expect( people2.send(method, people) ).to eq(result)
      end
    end
  end

  %w[∪ union].each do |method|
    context "##{method}" do
      it "performs union" do
        people2 = Relation.new do |r|
          r.schema = Schema.new(name: String, age: Numeric, gender: String)
          r.add_tuple ["Ben", 21, "male"]
          r.add_tuple ["Gus", 45, "male"]
        end
        result = Relation.new do |r|
          r.schema = Schema.new(name: String, age: Numeric, gender: String)
          r.add_tuple ["Ben", 21, "male"]
          r.add_tuple ["Amy", 16, "female"]
          r.add_tuple ["Gus", 45, "male"]
        end
        expect( people2.send(method, people) ).to eq(result)
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
