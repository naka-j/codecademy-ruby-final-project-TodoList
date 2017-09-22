module Menu
    # Constants
    ACTION_ADD = '1'
    ACTION_SHOW = '2'
    ACTION_UPDATE = '3'
    ACTION_DELETE = '4'
    ACTION_TO_FILE = '5'
    ACTION_FROM_FILE = '6'
    ACTION_TOGGLE_STATUS = '7'
    ACTION_QUIT = 'Q'
    
    def menu
        'Welcome to Task List! What do you want to do?
        1)Add
        2)Show
        3)Update
        4)Delete
        5)Write to a file
        6)Read from a file
        7)Toggle status
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
        @all_tasks.map.with_index {|t, i| puts "#{i.next})#{t.to_machine}"}
        puts '============================='        
    end

    def write_to_file(filename)
        IO.write(filename, @all_tasks.map(&:to_machine).join("\n"))
    end

    def read_from_file(filename)
        IO.readlines(filename).each do |l|
            # separate by a colon to get the status and the description of task
            status, *description = l.split(':')
            add(Task.new(description.join(':').strip, status.include?('X')))
        end
    end

    def delete(task_number)
        @all_tasks.delete_at(task_number.to_i - 1) if is_number?(task_number) # allow only number
    end

    def update(task_number, task)
        @all_tasks[task_number.to_i - 1] = task if is_number?(task_number) # allow only number
    end

    def toggle(task_number)
        @all_tasks[task_number.to_i - 1].toggle_status if is_number?(task_number) # allow only number
        puts @all_tasks[task_number.to_i - 1].inspect
    end

    private
    def is_number?(num)
        num =~ /^[0-9]+$/
    end
end

class Task
    attr_accessor :description, :status
    def initialize(description, status=false)
        @description = description
        @status = status
    end

    def to_s
        description
    end

    def completed?
        status
    end

    def to_machine
        "#{represent_status}:#{description}"
    end

    def toggle_status
        @status = !completed?
    end

    private
    def represent_status
        completed? ? '[X]' : '[ ]'
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
    when Menu::ACTION_TOGGLE_STATUS
        list.show
        list.toggle(prompt('Which task did you complete or incomplete?'))
    else
        puts "Sorry, I didn't understand."
    end
end
puts 'Outro - Thanks for using the menu system!'