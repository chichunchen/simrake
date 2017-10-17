#!/usr/bin/env ruby

#Expected output (minus #'s):

#this line should only appear once, despite being depended on twice
#twicedefined part 1, immediately followed by part 2
#twicedefined part 2, immediately preceded by part 1
#dep1
#dep2
#done!

task default: [:dep1, :dep2] do
    puts "done!"
end

task dep1: [:onlyonce, :twicedefined] do
    puts "dep1"
end

task dep2: :onlyonce do
    puts "dep2"
end

task :onlyonce do
    puts "this line should only appear once, despite being depended on twice"
end

task :twicedefined do
    puts "twicedefined part 1, immediately followed by part 2"
end

task :twicedefined do
    puts "twicedefined part 2, immediately preceded by part 1"
end

task :dead do
    raise "evaluating unneeded dependency!"
end
