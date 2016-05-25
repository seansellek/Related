module Related
  module Operations
    def natural_join(other)
      NaturalJoin.new(self, other).call
    end
    alias ⋈ natural_join

    class NaturalJoin
      def initialize(r1, r2)
        @r1 = r1
        @r2 = r2
      end

      def call
        join = @r1.cross_product( @r2.rename(rename_hash) )
        select = join.select { |t| rename_hash.all? { |k, v| t[k] == t[v] } }
        select.project( result_keys )
      end

      private

      def rename_hash
        return @rename_hash if @rename_hash
        common_attributes = @r1.schema.names & @r2.schema.names
        @rename_hash = {}
        common_attributes.each do |attr|
          old_key, = @r2.schema.heading.assoc(attr)
          @rename_hash[old_key] = old_key.to_s.concat('_temp').to_sym
        end

        @rename_hash
      end

      def result_keys
        @r1.schema.names | @r2.schema.names
      end
    end
  end
end
