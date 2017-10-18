require 'fileutils'

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
    if deps != []
      true
    else
      false
    end
  end

  def to_s
    "name: #{@name}\ndeps:#{@deps}\naction: #{@action}"
  end
end

class FileTask < Task
  def has_deps?
    if File.exists? @name
    else
    end
  end
end
