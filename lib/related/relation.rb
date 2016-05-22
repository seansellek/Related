require 'forwardable'
require 'set'

module Related
  class Relation
    extend Forwardable
    attr_accessor :tuples, :schema
    def_delegators :@tuples, :each, :empty?, :&, :|

    def initialize schema = nil, tuples = nil
      @schema = schema
      @tuples = tuples if tuples.is_a? Set
      yield self if block_given?
      raise ArgumentError unless @schema
    end

    def add_tuple ary
      @schema.match? ary or raise TypeError
      @tuples ||= Set.new
      @tuples << Tuple.new(ary)
    end
    alias_method "<<", "add_tuple"

    #Select operation; returns relation with tuples where block evaluates to true
    def select &block
      Relation.new do |r|
        r.schema = schema.similar
        @tuples.each do |tuple|
            r.add_tuple(tuple.values) if yield tuple.attributes(r.schema)
        end
      end
    end
    alias_method "𝜎", "select"

    def project attribute_names
      attr_hash = attribute_names.each_with_object({}) do |name, hash|
        hash[name] = schema[name][:type]
      end
      Relation.new do |r|
        r.schema = Schema.new(attr_hash)
        @tuples.each do |tuple|
          r.add_tuple tuple.project(schema, attribute_names)
        end
      end
    end
    alias_method "π", "project"

    def cross_product other
      attributes = ( schema.tuple_heading + other.schema.tuple_heading ).to_h
      Relation.new do |r|
        r.schema = Schema.new(attributes)
        tuples.each do |tuple|
          other.tuples.each do |other_tuple|
            r.add_tuple tuple.values + other_tuple.values
          end
        end
      end
    end
    alias_method "×", "cross_product"

    def natural_join other
    end
    alias_method "⋈", "natural_join"

    def rename new_attribute_names
      Relation.new(schema.rename(new_attribute_names), tuples)
    end
    alias_method "ρ", "rename"

    def intersection other
      raise ArgumentError unless schema.same_as? other.schema
      Relation.new(schema.similar, other & tuples)
    end
    alias_method "∩", "intersection"

    def union other
      raise ArgumentError unless schema.same_as? other.schema
      Relation.new(schema, other | tuples)
    end
    alias_method "∪", "union"

    def - other
      raise ArgumentError unless schema.same_as? other.schema
      Relation.new(schema, @tuples - other.tuples)
    end

    def include? other
      @tuples.each do |tuple|
        return true if tuple == other
      end
      return false
    end

    def == other
      return false unless schema.same_as? other.schema
      self.tuples == other.tuples
    end

    def inspect
      output = "Relation\n|"
      length = {}
      @schema.names.each {|n| length[n] = n.length }
      @tuples.each do |tuple|
        tuple.attributes(schema).each do |key, value|
          length[key] = value.to_s.length if value.to_s.length > ( length[key] || 0 )
        end
      end
      output << @schema.names.map{ |n| n.to_s.capitalize.center(length[n] + 2)}.join("|") << "|\n"
      output << "_" * output.lines.last.length << "\n"
      @tuples.each do |tuple|
        output << "|"
        tuple.attributes(schema).each do |name, value|
          output << value.to_s.center( length[name] + 2 ) << "|"
        end
        output << "\n"
      end
      output
    end
  end
end
