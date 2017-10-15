# Simrake
simulate the behavior of rake

## Feature
- Task is same as rake
- Implemented the file/time dependence of file tasks that is present in standard rake

## Execute test scripts
`./simrake.rb tests/task/complex_rake.rb`
`./simrake.rb tests/file/file_test_1.rb`
`./simrake.rb tests/file/real_world.rb`
- for all the tests scripts, you can find in tests dir
```
tests
├── file
│   ├── file_test_1.rb
│   ├── file_test_2.rb
│   ├── file_test_3.rb
│   └── real_world.rb
└── task
    ├── compare.rb
    ├── complex_rake.rb
    ├── default_rake.rb
    └── task_script.rb
```

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
