require 'spec_helper'

describe Schema do
  let(:schema) do
    described_class.new name: String, age: Numeric, gender: String
  end

  context '#match' do
    it 'returns true if array types match schema' do
      match = schema.match?(['Amy', 16, 'female'])
      expect(match).to be_truthy
    end
    it 'returns false if array types do not match schema' do
      match = schema.match?([16, 'Amy', 'female'])
      expect(match).to be_falsey
    end
  end

  context '#rename' do
    it 'takes a hash of attributes to rename and returns a new schema' do
      result = described_class.new(name: String, age: Numeric, sex: String)
      expect(schema.rename(gender: :sex)).to eq(result)
    end
  end

  context '#similar' do
    it 'returns a new schema with the same attributes' do
      expect(schema.similar).to eq(schema)
    end
  end

  context '#names' do
    it 'returns array of attribute names' do
      expect(schema.names).to eq([:name, :age, :gender])
    end
  end

  context '#project' do
    it 'returns schema with projection applied' do
      result = Schema.new(gender: String, age: Numeric)
      expect(schema.project([:gender, :age])).to eq(result)
    end
  end
end
