# The Tuple class exists to allow for quick lookup of values in a tuple.
# The Tuple class makes use of a schema to lookup values, allowing it to be unaffected by Rename operations.
module Related
  class Tuple
    extend Forwardable
    attr_accessor :values

    def_delegators :@values, :each
    def initialize ary
      @values = ary
    end

     def [] key, schema = nil
      key = schema ? schema.index_for(key) : key
      @values[key]
    end

    def project schema, attribute_names
      new_values = attribute_names.map do |name| 
        @values[ schema.index_for name ]
      end
      self.class.new(new_values)
    end

    def attributes schema
      schema.heading.each_with_index.map do |pair, i|
        attribute_name, _ = pair
        [attribute_name, @values[i]]
      end.to_h
    end

    def == other
      if other.respond_to? :values
        values == other.values
      else
        values == other
      end
    end
    alias_method "eql?", "=="

    def hash
      values.hash
    end
  end
end
