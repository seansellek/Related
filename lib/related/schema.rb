# The Schema class allows for quick lookup of Attribute types, indexes, and names.
# Two hashes and an array are used to allow for any of these items to be retrieved at order 1 speed.
# During a Rename operation, each of these three structures must be updated,
# however, this is still significantly faster than updating every tuple in a relation.
module Related
  class Schema
    attr_accessor :heading
    def initialize(input)
      @type_hash = input.to_h()
      @heading = input.to_a()
    end

    def similar
      self.class.new(@type_hash)
    end

    def rename(rename_hsh)
      new_attrs = []
      @heading.each do |atr|
        name, type = atr
        new_attrs << (rename_hsh[name] ? [rename_hsh[name], type] : [name, type])
      end
      self.class.new(new_attrs)
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
