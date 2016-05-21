Dir[File.expand_path("related/*", File.dirname(__FILE__))].each { |file| require file }

module Related

end

include Related
