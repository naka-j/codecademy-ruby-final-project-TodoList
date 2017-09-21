module Menu
    # Constants
    ACTION_ADD = '1'
    ACTION_SHOW = '2'
    ACTION_UPDATE = '3'
    ACTION_DELETE = '4'
    ACTION_TO_FILE = '5'
    ACTION_FROM_FILE = '6'
    ACTION_QUIT = 'Q'
    
    def menu
        'Welcome to Task List! What do you want to do?
        1)Add
        2)Show
        3)Update
        4)Delete
        5)Write to a file
        6)Read from a file
        Q)Quit'
    end

    def show
        puts menu
    end
end

module Promptable
    def prompt(message='What would you like to do?', symbol=':>')
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
        puts "added a new task: '#{task.to_s}'"
    end

    def show
        puts '=========Task List==========='
        @all_tasks.map.with_index {|t, i| puts "#{i.next})#{t.to_s}"}
        puts '============================='        
    end

    def write_to_file(filename)
        IO.write(filename, @all_tasks.map(&:to_s).join("\n"))
    end

    def read_from_file(filename)
        IO.readlines(filename).each do |l|
            add(Task.new(l.chomp))
        end
    end

    def delete(task_number)
        @all_tasks.delete_at(task_number.to_i - 1) if is_number?(task_number)
    end

    def update(task_number, task)
        @all_tasks[task_number.to_i - 1] = task if is_number?(task_number)
    end

    private
    def is_number?(num)
        num =~ /^[0-9]+$/
    end
end

class Task
    attr_accessor :description
    def initialize(description)
        @description = description
    end

    def to_s
        description
    end
end

## execute ##

list = List.new
include Menu, Promptable 
until [Menu::ACTION_QUIT].include?(selected = prompt(show).upcase)
    if selected == Menu::ACTION_QUIT.downcase then selected.upcase! end
    case selected
    when Menu::ACTION_ADD
        list.add(Task.new(prompt('Input your task!')))
        list.show    
    when Menu::ACTION_SHOW
        list.show
    when Menu::ACTION_UPDATE
        list.show
        list.update(prompt('Select a task number to update!'), Task.new(prompt('Input your task!')))
    when Menu::ACTION_DELETE
        list.show
        list.delete(prompt("Select a task number to delete!"))
    when Menu::ACTION_TO_FILE
        list.write_to_file(prompt('What is your file name?'))
    when Menu::ACTION_FROM_FILE
        begin
            list.read_from_file(prompt('What is your file name?'))
        rescue Errno::ENOENT
            puts "Your file is not found."
        end
    else
        puts "Sorry, I didn't understand."
    end
end
puts 'Outro - Thanks for using the menu system!'