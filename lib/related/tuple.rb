require 'forwardable'
require 'set'
module Related
  class Tuple
    def initialize schema, ary
      @schema, @attributes = schema, ary
    end

    def [] key
      @attributes[ @schema[key].index ]
    end
  end
end
