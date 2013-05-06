require 'linguist'
puts Linguist::FileBlob.new(ARGV[0]).language.name

