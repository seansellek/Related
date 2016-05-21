require 'forwardable'
require 'set'

module Related
  class Relation
    extend Forwardable
    attr_accessor :tuples, :schema
    def_delegators :@tuples, :each

    def initialize schema_hash
      @schema = Schema.new schema_hash
      yield self, @schema if block_given?
    end

    def add_tuple ary
      @schema.match? ary or raise TypeError
      @tuples ||= Set.new
      @tuples << ary
    end
    alias_method "<<", "add_tuple"

    #Select operation; returns relation with tuples where block evaluates to true
    def select &block
      Relation.new(schema).tuples = @tuples.select(&block)
    end
    alias_method "𝜎", "select"


    def natural_join other
    end
    alias_method "⋈", "natural_join"

  end
end
