module Related
  module Operations
    def natural_join(other)
      mapping = schema.join_mapping_for other.schema
      Relation.new do |r|
        r.schema = Schema.new((schema.heading + other.schema.heading).uniq)
        cross_action other do |tuple, other_tuple|
          if tuple.matches? other_tuple, mapping: mapping
            # reject to avoid duplications on join columns
            join_indexes = mapping.map(&:last)
            other_values = other_tuple.values.reject.with_index {|_,i| join_indexes.include? i}
            r.add_tuple Tuple.new(tuple.values + other_values)
          end
        end
      end
    end
    alias ⋈ natural_join
  end
end
