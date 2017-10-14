task pancake: [:flour,:milk,:butter] do
  puts "sizzle."
end

task :butter do
  puts "Cut 3 tablespoons of butter,"
end

task flour: :butter do
  puts "knead butter into flour,"
end

task :milk do
  puts "add milk,"
end
