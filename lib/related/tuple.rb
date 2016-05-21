require 'forwardable'
require 'set'
module Related
  class Tuple
    extend Forwardable
    def_delegators :@hash, :keys, :[]
    def initialize tuple_hash
      @hash = tuple_hash
    end

    # Used in natural join to determine whether to join with another tuple
    def & other
      matches = self.schema & other.schema
      return nil if matches.empty? || matches.any? {|k| self[k] != other[k] }
      Tuple.new( self.merge other )
    end

    def schema
      Set[*keys]
    end

    def merge other
      @hash.merge other.to_hash
    end

    def to_hash
      @hash
    end

    def == other_tuple
      other_tuple == @hash
    end
  end
end
