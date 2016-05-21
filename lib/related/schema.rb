module Related
  Attribute = Struct.new(:name, :type, :index)
  class Schema
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

  def attribute_for_index index
    name, type = @tuple_heading[index]
    Attribute.new name, type, index
  end

  def attribute_for_name name
    type, index = @type_hash[name], @index_hash[name]
    Attribute.new name, type, index
  end

  def match? ary
    ary.each.with_index.all? { |obj, i| obj.is_a? self[i][:type] }
  end
end
