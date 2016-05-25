require 'forwardable'
require 'set'

module Related
  class Relation
    extend Forwardable
    include Operations
    include Formatters::TableFormatter

    attr_accessor :tuples, :schema
    def_delegators :@tuples, :each, :empty?, :&, :|

    def initialize(schema = nil, tuples = nil)
      @schema = schema
      @tuples = tuples if tuples.is_a? Set
      yield self if block_given?
      raise ArgumentError unless @schema
    end

    def add_tuple(input)
      @schema.match? input or raise TypeError
      @tuples ||= Set.new
      tuple = input.is_a?(Tuple) ? input : Tuple.new(input)
      @tuples << tuple
    end
    alias << add_tuple

    def select(&_block)
      Relation.new do |r|
        r.schema = schema.similar
        @tuples.each do |tuple|
          r.add_tuple(tuple.values) if yield tuple.attributes(r.schema)
        end
      end
    end
    alias 𝜎 select

    def project(*args)
      attribute_names = args.flatten
      Relation.new do |r|
        r.schema = schema.project attribute_names
        tuples.each do |tuple|
          r.add_tuple tuple.project(schema, attribute_names)
        end
      end
    end
    alias π project

    def cross_product(other)
      Relation.new do |r|
        r.schema = Schema.new(schema.heading + other.schema.heading)
        tuples.each do |tuple|
          other.tuples.each do |other_tuple|
            r.add_tuple tuple + other_tuple
          end
        end
      end
    end
    alias × cross_product

    def rename(rename_hash)
      Relation.new(schema.rename(rename_hash), tuples)
    end
    alias ρ rename

    def intersection(other)
      raise ArgumentError unless schema == other.schema
      Relation.new(schema.similar, other & tuples)
    end
    alias ∩ intersection

    def union(other)
      raise ArgumentError unless schema == other.schema
      Relation.new(schema, other | tuples)
    end
    alias ∪ union

    def -(other)
      raise ArgumentError unless schema == other.schema
      Relation.new(schema, @tuples - other.tuples)
    end

    def include?(other)
      @tuples.each do |tuple|
        return true if tuple == other
      end
      false
    end

    def ==(other)
      return false unless other.respond_to?(:tuples) && other.respond_to?(:schema)
      tuples == other.tuples && schema == other.schema
    end

    def to_s
      to_table
    end
  end
end
