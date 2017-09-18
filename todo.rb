module Menu
    ACTION_ADD = "1"
    ACTION_SHOW = "2"
    ACTION_QUIT = "Q"
    def menu
        "Welcome to Task List! What do you want to do?
        1)Add
        2)Show
        Q)Quit"
    end

    def show
        puts menu
    end
end

module Promptable
    def prompt(message="What would you like to do?", symbol=":>")
        puts message
        print symbol
        gets.chomp
    end
end

class List
    attr_reader :all_tasks
    def initialize
        @all_tasks = []
    end

    def add(task)
        @all_tasks << task
        puts "added a new task: '#{task.description}'"
    end

    def show
        puts "=========Task List==========="
        @all_tasks.each {|t| puts t.description}
        puts "============================="        
    end
end

class Task
    attr_accessor :description
    def initialize(description)
        @description = description
    end
end

## execute ##

list = List.new
include Menu, Promptable 
Menu.show
selected = prompt.upcase
if selected == Menu::ACTION_QUIT.downcase then selected.upcase! end
case selected
when Menu::ACTION_ADD
    list.add(Task.new(prompt('Input your task!')))
    list.show    
when Menu::ACTION_SHOW
    list.show
when Menu::ACTION_QUIT
else
    puts "Sorry, I didn't understand."
end
puts "Outro - Thanks for using the menu system!"