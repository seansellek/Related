require 'forwardable'
require 'set'

module Related
  class Relation
    attr_accessor :tuples
    def initialize schema_hash
      @schema = schema_hash
    end

    def add_tuple ary
      match_schema? ary or raise TypeError
      @tuples ||= Set.new
      @tuples << ary
    end
    alias_method "<<", "add_tuple"

    def match_schema? ary
      ary.each_with_index.all? do |klass, i|
        klass.is_a? @schema.values[i]
      end
    end
  end
end
