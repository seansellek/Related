module Related
  module Formatters
    module TableFormatter
      def to_table
        output = "Relation\n|"
        length = {}
        @schema.names.each {|n| length[n] = n.length }
        if @tuples
          @tuples.each do |tuple|
            tuple.attributes(schema).each do |key, value|
              length[key] = value.to_s.length if value.to_s.length > ( length[key] || 0 )
            end
          end
        end
        output << @schema.names.map{ |n| n.to_s.capitalize.center(length[n] + 2)}.join("|") << "|\n"
        output << "_" * output.lines.last.length << "\n"
        if @tuples
          @tuples.each do |tuple|
            output << "|"
            tuple.attributes(schema).each do |name, value|
              output << value.to_s.center( length[name] + 2 ) << "|"
            end
            output << "\n"
          end
        end
        output
      end
    end
  end
end
