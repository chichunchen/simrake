task :default => 'config/database.yml'

file 'config/database.yml' => 'config/database.yml.example' do
  cp 'config/database.yml.example', 'config/database.yml'
  puts "cp"
end
