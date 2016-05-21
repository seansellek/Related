# The Tuple class exists to allow for quick lookup of values in a tuple.
# The Tuple class makes use of a schema to lookup values, allowing it to be unaffected by Rename operations.
module Related
  class Tuple
    extend Forwardable
    attr_accessor :values

    def initialize schema, ary
      @schema, @values = schema, ary
    end

    def [] key
      @values[ @schema[key].index ]
    end

    def attributes
      @schema.names.each_with_object({}) do |name, attrs|
        attrs[name] = self[ name ]
      end
    end

    def == other
      if other.respond_to? :schema
        return false unless @schema.same_as? other.schema
      end
      other == values
    end
    alias_method "eql?", "=="

    def hash
      [@schema.tuple_heading, *values].hash
    end
  end
end
