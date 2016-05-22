Dir[File.expand_path('related/*', File.dirname(__FILE__))].each { |file| require file }
require "related/version"

module Related
  # Your code goes here...
end

include Related
