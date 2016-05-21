# The Schema class allows for quick lookup of Attribute types, indexes, and names.
# Two hashes and an array are used to allow for any of these items to be retrieved at order 1 speed.
# During a Rename operation, each of these three structures must be updated,
# however, this is still significantly faster than updating every tuple in a relation.
module Related
  Attribute = Struct.new(:name, :type, :index)
  class Schema
    attr_accessor :tuple_heading
    def initialize schema_hash
        @type_hash, @index_hash = schema_hash, {}
        @tuple_heading = @type_hash.to_a
        @tuple_heading.each_with_index do |*args|
          name, type, i = args.flatten
          @index_hash[name] = i
        end
    end

    def [] lookup
      if lookup.is_a? Integer
        attribute_for_index lookup
      elsif lookup.is_a? Symbol
        attribute_for_name lookup
      end
    end
  end

  def similar
    self.class.new(@type_hash)
  end

  def attribute_for_index index
    name, type = @tuple_heading[index]
    Attribute.new name, type, index
  end

  def attribute_for_name name
    type, index = @type_hash[name], @index_hash[name]
    Attribute.new name, type, index
  end

  def rename new_names
    new_attribute_hash = new_names.each.with_index.map do |name, i|
       [ name, @tuple_heading[i][1] ]
     end.to_h
    self.class.new(new_attribute_hash)
  end

  def match? ary
    ary.each.with_index.all? { |obj, i| obj.is_a? self[i][:type] }
  end

  def same_as? schema
    @tuple_heading == schema.tuple_heading
  end

  def names 
    @type_hash.keys
  end
end
