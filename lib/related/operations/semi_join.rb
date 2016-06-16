module Related
  module Operations
    def left_semi_join(other)
      mapping = schema.join_mapping_for other.schema
      Relation.new(schema.similar) do |r|
        each do |tuple|
          other.each do |other_tuple|
            r.add_tuple tuple if tuple.matches?(other_tuple, index_mapping: mapping)
          end
        end
      end
    end
    alias ⋉ left_semi_join
    alias semi_join left_semi_join

    def right_semi_join(other)
      mapping = schema.join_mapping_for other.schema
      Relation.new(other.schema.similar) do |r|
        each do |tuple|
          other.each do |other_tuple|
            r.add_tuple other_tuple if tuple.matches?(other_tuple, index_mapping: mapping)
          end
        end
      end
    end
    alias ⋊ right_semi_join
  end
end
