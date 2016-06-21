require 'spec_helper'

describe Relation do
  let(:menu) do
    Relation.new do |r|
      r.schema = Schema.new(pizza: String, price: Numeric)
      r.add_tuple ['mushroom', 8]
      r.add_tuple ['cheese', 7]
    end
  end

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

  context '#add_tuple' do
    it 'adds a tuple to the relation' do
      menu.add_tuple ['supreme', 10]
      expect(menu).to include(['supreme', 10])
    end
    it 'throws an error if tuple is illegal for schema' do
      expect { menu.add_tuple ['supreme', '10'] }.to raise_error TypeError
    end
  end

	context '#clone' do
		it "doesn't change when tuples are added to the original" do
			clone = people.clone
			people.add_tuple ['New', 25, 'female']
			expect(clone).to_not include ['New', 25, 'female']
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

  context "#𝜎, #select" do
    it 'perform select operation with given block as condition' do
      selection = favorites.select { |t| t[:pizza] == 'mushroom' }
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, pizza: String)
        r.add_tuple ['Amy', 'mushroom']
        r.add_tuple ['Gus', 'mushroom']
      end

      expect(selection).to eq(result)
    end
  end

  context "#π, #project" do
    it 'perform projection with given attribute names' do
      projection = favorites.project(:name)
      result = Relation.new do |r|
        r.schema = Schema.new(name: String)
        r.add_tuple ['Amy']
        r.add_tuple ['Gus']
        r.add_tuple ['Ben']
      end

      expect(projection).to eq(result)
    end
  end


  context "#ρ, #rename" do
    before do
      @rename = favorites.rename(name: :person_name)
      @result = Relation.new do |r|
        r.schema = Schema.new(person_name: String, pizza: String)
        r.add_tuple ['Amy', 'mushroom']
        r.add_tuple ['Amy', 'pepperoni']
        r.add_tuple ['Ben', 'cheese']
        r.add_tuple ['Gus', 'mushroom']
      end
    end
    it 'performs rename of attributes in relation' do
      expect(@rename).to eq(@result)
    end
    it "does not alter original relation" do
      expect(favorites.schema).to eq(Schema.new(name: String, pizza: String))
    end
  end

  context "#∩, #intersection" do
    it 'perform intersection' do
      people2 = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String)
        r.add_tuple ['Ben', 21, 'male']
        r.add_tuple ['Gus', 45, 'male']
      end

      intersection = people2.intersection(people)
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String)
        r.add_tuple ['Ben', 21, 'male']
      end

      expect(intersection).to eq(result)
    end
  end

  context "#∪, #union" do
    it 'perform union' do
      people2 = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String)
        r.add_tuple ['Ben', 21, 'male']
        r.add_tuple ['Gus', 45, 'male']
      end

      union = people2.union(people)
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String)
        r.add_tuple ['Ben', 21, 'male']
        r.add_tuple ['Amy', 16, 'female']
        r.add_tuple ['Gus', 45, 'male']
      end

      expect(union).to eq(result)
    end
  end

  context "#/, #-, #difference" do
    it 'performs the difference' do
      people2 = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String)
        r.add_tuple ['Ben', 21, 'male']
        r.add_tuple ['Gus', 45, 'male']
      end

      difference = people.difference(people2)
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String)
        r.add_tuple ['Amy', 16, 'female']
      end

      expect(difference).to eq(result)
    end
  end

  context "#×, cross_product" do
    it 'performs the cartesian product' do
      cross = people.cross_product(menu)
      result = Relation.new do |r|
        r.schema = Schema.new(name: String, age: Numeric, gender: String, pizza: String,  price: Numeric)
        r.add_tuple ['Amy', 16, 'female', 'mushroom', 8]
        r.add_tuple ['Amy', 16, 'female', 'cheese', 7]
        r.add_tuple ['Ben', 21, 'male', 'mushroom', 8]
        r.add_tuple ['Ben', 21, 'male', 'cheese', 7]
      end

      expect(cross).to eq(result)
    end
  end
end
