#!/usr/bin/env ruby

require 'set'
require_relative './task.rb'

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
    done = Set.new

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
        if not @tasks[temp].action.nil? and not done.include? temp
          @tasks[temp].action.call
          done.add temp
        end
        if temp == parent_stack.last
          parent_stack.pop
        end
      end
    end
  end

  def complete_root_file
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

def file (obj, &action)
  include FileUtils

  if obj.instance_of? Hash
    arr = obj.to_a
    root = arr[0][0]

    if not File.exists? root
      t = Task.new root, [:none], &action
      FileUtils.touch root
    else
      root_change_time = File.ctime root
      dep_files = arr[0][1]

      if dep_files.instance_of? Array
        p = dep_files.reduce(false) do |acc, e|
          unless File.exists?(e) then FileUtils.touch(e) end
          true if File.ctime(e) > root_change_time
        end
        if p
          t = Task.new root, [:none], &action
          #puts "dep newer than root"
        else
          t = Task.new root, [:none]
          #puts "dep older than root"
        end
      else
        unless File.exists?(dep_files) then FileUtils.touch(dep_files) end
        dep_change_time = File.ctime dep_files
        if dep_change_time > root_change_time
          t = Task.new root, [:none], &action
          #puts "dep newer than root"
        else
          t = Task.new root, [:none]
          #puts "dep older than root"
        end
      end
    end
    $builder.tasks[root] = t
  else
    if File.exists? obj
      t = FileTask.new obj, [:none]
    else
      FileUtils.touch obj
      t = FileTask.new obj, [:none], &action
    end
    $builder.tasks[obj] = t
  end
end

load ARGV[0]  #load the script file which is passed in to simrake

# puts $builder.tasks

$builder.complete_root_task
