require 'spec_helper'

describe Operations do
  let(:people) do
    Relation.new do |r|
      r.schema = Schema.new(name: String, age: Numeric, gender: String)
      r.add_tuple ['Amy', 16, 'female']
      r.add_tuple ['Ben', 21, 'male']
    end
  end

  let(:favorites) do
    Relation.new do |r|
      r.schema = Schema.new(name: String, pizza: String)
      r.add_tuple ['Amy', 'mushroom']
      r.add_tuple ['Amy', 'pepperoni']
      r.add_tuple ['Ben', 'cheese']
      r.add_tuple ['Gus', 'mushroom']
    end
  end

  let(:menus) do
    Relation.new do |r|
      r.schema = Schema.new(pizzeria: String, item: String, price: Numeric)
      r.add_tuple ['Dominos', 'mushroom',  7.75]
      r.add_tuple ['Pizza Hut', 'pepperoni', 8.5]
      r.add_tuple ['Papa Johns', 'mushroom', 9.5]
    end
  end

  context "#⋈, natural_join" do
    it 'performs a natural join' do
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String, pizza: String)
        r.add_tuple ['Amy', 16, 'female', 'mushroom']
        r.add_tuple ['Amy', 16, 'female', 'pepperoni']
        r.add_tuple ['Ben', 21, 'male', 'cheese']
      end
      expect( people.natural_join(favorites) ).to eq(result)
    end
  end

  context "#𝛳, theta_join" do
    it "performs a join on given condition" do
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, pizza: String, pizzeria: String, item: String, price: Numeric)
        r.add_tuple ['Amy', 'mushroom', 'Dominos', 'mushroom',  7.75]
        r.add_tuple ['Amy', 'mushroom', 'Papa Johns', 'mushroom', 9.5]
        r.add_tuple ['Amy', 'pepperoni', 'Pizza Hut', 'pepperoni', 8.5]
        r.add_tuple ['Gus', 'mushroom', 'Dominos', 'mushroom',  7.75]
        r.add_tuple ['Gus', 'mushroom', 'Papa Johns', 'mushroom', 9.5]
      end
      theta_join = favorites.theta_join(menus) do |t|
        t[:pizza] == t[:item]
      end

      expect(theta_join).to eq(result)
    end
  end

  context "#⋉, semi_join, left_semi_join" do
    it 'performs a left semi join' do
      result = people.clone
      people.add_tuple ['No-counterpart', 44, 'male']
      expect( people.semi_join favorites ).to eq(result)
    end
  end

  context "#⋊, right_semi_join" do
    it 'performs a right semi join' do
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, pizza: String)
        r.add_tuple ['Amy', 'mushroom']
        r.add_tuple ['Amy', 'pepperoni']
        r.add_tuple ['Ben', 'cheese']
      end
      expect( people.right_semi_join favorites ).to eq(result)
    end
  end
end
