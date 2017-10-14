#!/usr/bin/env ruby

class Task
  attr_accessor :name, :deps, :action

  def initialize name, deps, &action
    @name = name
    @deps = deps
    @action = action
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

  # the root task is by default the default_task
  # this function is used if the task script have explicitly defined the default task
#   def default_task task
#     @default_task = task
#   end

  def complete_root_task
    @tasks.each do |task|
      @tasks[task[0]].each do |dep|
        if dep.instance_of? Array
          aux dep
        end
      end
      #task[1][1].call
    end
    @tasks.to_a[0][1][1].call
  end

  # call until find terminal (:none)
  # if hash[dep] is not :none
  # add dep to stack and then try hash[dep] whether is :none
  # if it is, then pop from stack and call it, until the stack is empty
  def aux dep
    # only use push and pop to manipulate stack
    stack = []

    dep.each do |d|
      stack << d
      # puts d
      temp = @tasks[d][0]
      while temp != :none do
        stack.push temp
        temp = @tasks[temp][0]
      end
      # puts "stack #{stack}"

      while stack != [] do
        @tasks[stack.pop][1].call
      end
    end
  end
end

$builder = SimRake.new

# register the task, its dependent tasks, and the
# action at the builder object
def task (hash, &action)
  arr = hash.to_a
  # hash = {:pancake=>[:flour, :milk, :butter]}
  # arr = [[:pancake, [:flour, :milk, :butter]]]
  # which :pancake = arr[0][0], and its value is arr[0][1]
  $builder.tasks[arr[0][0]] = [arr[0][1], action, arr[0][0]]
end

load ARGV[0]  #load the script file which is passed in to simrake

$builder.complete_root_task
