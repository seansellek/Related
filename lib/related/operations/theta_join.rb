module Related
  module Operations
    def theta_join(other, &condition)
      ThetaJoin.new(self, other).call(&condition)
    end
    alias 𝛳 theta_join

    class ThetaJoin
      def initialize(r1, r2)
        @r1 = r1
        @r2 = r2
      end

      def call
        join = @r1.cross_product(@r2)
        join.select { |t| yield t }
      end
    end
  end
end
