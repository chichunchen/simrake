#!/usr/bin/env ruby

class Task
  attr_accessor :name, :deps, :action

  def initialize name, deps, &action
    @name = name
    if deps.instance_of? Array
      @deps = deps
    else
      @deps = [deps]
    end
    @action = action
  end

  def has_deps?
    if deps != [:none]
      true
    else
      false
    end
  end

  def to_s
    "name: #{@name}\ndeps:#{@deps}\naction: #{@action}"
  end
end

class SimRake
  attr_accessor :tasks, :default_task

  # store all tasks and dependencies
  def initialize
    @tasks = {}
    @default_task
  end

  # If :default exists then it is the root task
  # If task :default is not defined in the script,
  # then the first task defined is the root task.
  def default_task task
    if @default_task.nil? or task == :default
      @default_task = task
    end
  end

  # push deps reversly into stack
  # return the stack
  def push_deps_reversely deps, stack
    rev = deps.reverse
    rev.inject(stack) { |memo, obj| memo << obj }
  end

  # complete the root task using its dependencies (should only complete root task!)
  # use 2 stacks to trace the states
  # firstly, push default_task to parse_stack
  # secondly, pop from parse_stack and if it has dependencies,
  # then push itself and all its dependencies
  # to parse_stack, in addition, push itself to parent_stack
  # if the parse_stack is empty, then our task has completed
  def complete_root_task
    parse_stack = []
    parent_stack = []

    # push default_task
    parse_stack << @tasks[@default_task].name

    while not parse_stack.empty? do
      temp = parse_stack.pop
      if @tasks[temp].has_deps? and temp != parent_stack.last
        parse_stack << @tasks[temp].name
        push_deps_reversely @tasks[temp].deps, parse_stack
        parent_stack.push temp

        # debug info
        # puts "parse_stack #{parse_stack}"
        # puts "parent_stack #{parent_stack}"
      else
        # invoke proc only if there is one
        if not @tasks[temp].action.nil?
          @tasks[temp].action.call
        end
        if temp == parent_stack.last
          parent_stack.pop
        end
      end
    end
  end

end

$builder = SimRake.new

# register the task, its dependent tasks, and the
# action at the builder object
def task (hash, &action)
  if hash.instance_of? Hash
    arr = hash.to_a
    # hash = {:pancake=>[:flour, :milk, :butter]}
    # arr = [[:pancake, [:flour, :milk, :butter]]]
    # which :pancake = arr[0][0], and its value is arr[0][1]
    t = Task.new arr[0][0], arr[0][1], &action
    $builder.tasks[arr[0][0]] = t
    $builder.default_task arr[0][0]
  else
    t = Task.new hash, [:none], &action
    $builder.tasks[hash] = t
    $builder.default_task hash
  end
end

load ARGV[0]  #load the script file which is passed in to simrake

$builder.complete_root_task
