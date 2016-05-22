# The Schema class allows for quick lookup of Attribute types, indexes, and names.
# Two hashes and an array are used to allow for any of these items to be retrieved at order 1 speed.
# During a Rename operation, each of these three structures must be updated,
# however, this is still significantly faster than updating every tuple in a relation.
module Related
  class Schema
    attr_accessor :heading
    def initialize(input)
      build_schema_from_hash input if input.is_a? Hash
      build_schema_from_array input if input.is_a? Array
    end

    def similar
      self.class.new(@type_hash)
    end

    def rename(rename_hash)
      new_attribute_array = @heading.clone
      rename_hash.each do |k, v|
        new_attribute_array[index_for(k)][0] = v
      end

      self.class.new(new_attribute_array)
    end

    def project(attributes)
      attr_types_hash = attributes.each_with_object({}) do |name, hash|
        hash[name] = type_for name
      end
      self.class.new(attr_types_hash)
    end

    def match?(input)
      input.each.with_index.all? do |obj, i|
        obj.is_a? type_at_index(i)
      end
    end

    def names
      @type_hash.keys
    end

    def ==(other)
      @heading == other.heading
    end
    alias eql? ==

    def hash
      @heading.hash
    end

    def type_for(key)
      @type_hash[key]
    end

    def index_for(key)
      @index_hash or build_index_hash
      @index_hash[key]
    end

    private

    def build_schema_from_hash(hash)
      @type_hash = hash
      @heading = hash.to_a
    end

    def build_schema_from_array(ary)
      @type_hash = ary.to_h
      @heading = ary
    end

    def build_index_hash
      @index_hash = {}
      @heading.each_with_index do |pair, i|
        name, = pair
        @index_hash[name] = i
      end
    end

    def type_at_index(i)
      heading[i][1]
    end
  end
end
