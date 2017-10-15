task default: [:default_rake, :task_script] do
    puts "if no output of diff, then it'a all correct"
    puts "end of compare"
end

task :default_rake do
    system 'rake --rakefile default_rake.rb > correct.txt'
    system './simrake.rb default_rake.rb > output.txt'
    system 'diff correct.txt output.txt'
    system 'rm correct.txt output.txt'
end

task :task_script do
    system 'rake --rakefile task_script.rb > correct.txt'
    system './simrake.rb task_script.rb > output.txt'
    system 'diff correct.txt output.txt'
    system 'rm correct.txt output.txt'
end
