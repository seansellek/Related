module Related
  class Tuple
    extend Forwardable
    attr_accessor :values

    def_delegators :@values, :each
    def initialize(ary)
      @values = ary
    end

    def [](key, schema = nil)
      key = schema ? schema.index_for(key) : key
      @values[key]
    end

    def project(schema, attribute_names)
      new_values = attribute_names.map do |name|
        @values[schema.index_for(name)]
      end
      self.class.new(new_values)
    end

    def attributes(schema)
      schema.heading.each_with_index.map do |pair, i|
        attribute_name, = pair
        [attribute_name, @values[i]]
      end.to_h
    end

    def +(other)
      self.class.new(values + values_for(other))
    end

    def ==(other)
      values == values_for(other)
    end
    alias eql? ==

    def hash
      values.hash
    end

    def matches?(other, mapping:)
      mapping.each do |i, j|
        return false if values[i] != other.values[j]
      end
      true
    end

    private

    def values_for(other)
      other.respond_to?(:values) ? other.values : other
    end
  end
end
