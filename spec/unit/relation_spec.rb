require 'spec_helper'

describe Relation do
  let(:menu) do 
    Relation.new do |r|
      r.schema = Schema.new(name: String, price: Numeric)
      r.add_tuple [ "mushroom", 8 ]
      r.add_tuple [ "cheese", 7 ]
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

  context "#add_tuple" do
    it "adds a tuple to the relation" do
      menu.add_tuple ["supreme", 10]
      expect( menu ).to include(["supreme", 10])
    end
    it "throws an error if tuple is illegal for schema" do
      expect { menu.add_tuple ["supreme", "10"] }.to raise_error TypeError
    end
  end

  context "#⋈" do
    it "raises TypeError when no common attributes"
    it "performs a natural join"
  end


  context "#𝜎, #select" do
    it "perform select operation with given block as condition" do
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, pizza: String)
        r.add_tuple ["Amy", "mushroom"]
        r.add_tuple ["Gus", "mushroom"]
      end
      expect( favorites.𝜎 {|t| t[:pizza] == "mushroom" } ).to eq(result)
      expect( favorites.select {|t| t[:pizza] == "mushroom" } ).to eq(result)
    end
  end

  context "#π, #project" do
    it "perform projection with given attribute names" do
      result = Relation.new do |r|
        r.schema = Schema.new(name: String)
        r.add_tuple ["Amy"]
        r.add_tuple ["Gus"]
        r.add_tuple ["Ben"]
      end
      expect( favorites.π([:name]) ).to eq(result)
      expect( favorites.project([:name]) ).to eq(result)
    end
  end


  context "#ρ, #rename" do
    it "performs rename of attributes in relation" do
      result = Relation.new do |r|
        r.schema = Schema.new(person_name: String, pizza_name: String)
        r.add_tuple ["Amy", "mushroom"]
        r.add_tuple ["Amy", "pepperoni"]
        r.add_tuple ["Ben", "cheese"]
        r.add_tuple ["Gus", "mushroom"]
      end
      expect( favorites.ρ([:person_name, :pizza_name]) ).to eq(result)
      expect( favorites.rename([:person_name, :pizza_name]) ).to eq(result)
    end
  end


  context "#∩, #intersection" do
    it "perform intersection" do
      people2 = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String)
        r.add_tuple ["Ben", 21, "male"]
        r.add_tuple ["Gus", 45, "male"]
      end
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String)
        r.add_tuple ["Ben", 21, "male"]
      end
      expect( people2.∩ people ).to eq(result)
      expect( people2.intersection people ).to eq(result)
    end
  end

  context "#∪, #union" do
    it "perform union" do
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
      expect( people2.∪ people ).to eq(result)
      expect( people2.union people ).to eq(result)
    end
  end

  context "#×, cross_product" do
    it "performs the cartesian product" do
      menu_rename = menu.rename( [:pizza_name, :price] )
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String, pizza_name: String,  price: Numeric)
        r.add_tuple [ "Amy", 16, "female", "mushroom", 8 ]
        r.add_tuple [ "Amy", 16, "female", "cheese", 7 ]
        r.add_tuple [ "Ben", 21, "male", "mushroom", 8 ]
        r.add_tuple [ "Ben", 21, "male", "cheese", 7 ]
      end

      expect( people.cross_product(menu_rename) ).to eq(result)
    end
  end
end
