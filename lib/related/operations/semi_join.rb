module Related
  module Operations
    def left_semi_join(other)
      mapping = schema.join_mapping_for other.schema
      Relation.new(schema.similar) do |r|
        cross_action other do |tuple, other_tuple|
          if tuple.matches? other_tuple, mapping: mapping
            r.add_tuple tuple
          end
        end
      end
    end
    alias ⋉ left_semi_join
    alias semi_join left_semi_join

    def right_semi_join(other)
      other.left_semi_join self
    end
    alias ⋊ right_semi_join
  end
end
