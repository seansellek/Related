require 'forwardable'
require 'set'

module Related
  class Relation
    extend Forwardable
    attr_accessor :tuples, :schema
    def_delegators :@tuples, :each, :empty?, :&

    def initialize schema = nil, tuples = nil
      @schema = schema
      @tuples = tuples if tuples.is_a? Set
      yield self if block_given?
      raise ArgumentError unless @schema
    end

    def add_tuple ary
      @schema.match? ary or raise TypeError
      @tuples ||= Set.new
      @tuples << Tuple.new(@schema, ary)
    end
    alias_method "<<", "add_tuple"

    #Select operation; returns relation with tuples where block evaluates to true
    def selection &block
      Relation.new(schema, @tuples.select!(&block))
    end
    alias_method "𝜎", "selection"


    def natural_join other
    end
    alias_method "⋈", "natural_join"

    def intersection other
      raise ArgumentError unless schema.same_as? other.schema
      Relation.new(schema, other & tuples)
    end
    alias_method "∩", "intersection"

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
        tuple.attributes.each do |key, value|
          length[key] = value.to_s.length if value.to_s.length > length[key]
        end
      end
      output << @schema.names.map{ |n| n.to_s.capitalize.center(length[n] + 2)}.join("|") << "|\n"
      output << "_" * output.lines.last.length << "\n"
      @tuples.each do |tuple|
        output << "|"
        tuple.attributes.each do |name, value|
          output << value.to_s.center( length[name] + 2 ) << "|"
        end
        output << "\n"
      end
      output
    end
  end
end
