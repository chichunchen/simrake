# Simrake
simulate the behavior of rake

## Feature
- Task is same as rake
- Implemented the file/time dependence of file tasks that is present in standard rake

## Execute test scripts
`./simrake.rb tests/task/complex_rake.rb`, `./simrake.rb tests/file/file_test_1.rb`

### Compare to rake
`rake --rakefile tests/task/complex_rake.rb`

### Test Auto testing (What we used to do while writing makefile)
- Test the correctness of simrake using `./simrake.rb tests/task/compare.rb` automatically.
- Pipe the output of simrake and rake to two different txt file, and then diff two of the file.
- output if all correct
```
if no output of diff, then it'a all correct
end of compare
```
