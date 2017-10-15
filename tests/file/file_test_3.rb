task :default => 'foo.txt'

file 'foo.txt' => ['bar.txt', 'boo.txt'] do
  touch 'foo.txt'
  puts 'touch foo.txt'
end
