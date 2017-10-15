task :default => 'foo.txt'

file 'foo.txt' do
  touch 'foo.txt'
  puts 'touch foo.txt'
end
