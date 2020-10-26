$LOAD_PATH.unshift( "./lib" )
require 'mono'

puts
puts Mono.root


puts MonoFile.real_path( 'tmp/test/hello.txt' )


puts MonoFile.read_utf8( 'tmp/test/hello.txt' )
pp MonoFile.exist?( 'tmp/test/hello.txt' )
pp MonoFile.exist?( 'tmp/test/hola.txt' )


MonoFile.open( 'tmp/test/test.txt', 'w:utf-8' ) do |f|
  f.write( "test test test\n" )
  f.write( "#{Time.now}\n")
end

MonoGitProject.open( 'testgit/erste-schritte') do |proj|
   puts proj.status
   puts proj.changes?
end



Mono.open( 'testgit/erste-schritte') do |proj|
  puts proj.status
  puts proj.changes?
end

Mono.root = "/Sites/tmp/#{Time.now.to_i}"
puts Mono.root


MonoGitHub.clone( 'rubycoco/fotos')

MonoGitProject.open( 'rubycoco/fotos' ) do |proj|
  puts proj.status
  puts proj.changes?
end

Mono.clone( 'rubycoco/gutenberg', depth: 1 )
## Mono.clone( 'rubycoco/fizzubuzzer' )
