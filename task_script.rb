task pancake: [:flour,:milk,:butter] do
  puts "sizzle."
end

task butter: :none do
  puts "Cut 3 tablespoons of butter,"
end

task flour: :butter do
  puts "knead butter into flour,"
end

task milk: :none do
  puts "add milk,"
end
