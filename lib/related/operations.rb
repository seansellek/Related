Dir[File.expand_path('operations/*', File.dirname(__FILE__))].each { |file| require file }
module Related
  module Operations
  end
end
