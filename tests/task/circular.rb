#!/usr/bin/env ruby

#This should fail; there is a circular dependency

task circ: :circ2 do
    puts "never seen"
end

task circ2: :circ do
    puts "still never seen"
end
