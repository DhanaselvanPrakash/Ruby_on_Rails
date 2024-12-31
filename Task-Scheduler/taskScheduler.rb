require "date"

class TaskScheduler
    attr_reader :task 

    def initialize(title, desc, deadline, priority)
        taskStruct = Struct.new(:title, :desc, :deadline, :priority)
        @task = taskStruct.new(title, desc, Date.parse(deadline), priority)
        @task_arr = Array.new
    end

    def readFile
        begin
            arr = []
            file = File.open("Task.csv", "r")
            file.each do |line|
                arr.push(line)
            end
            file.close
            return arr
        rescue => err
            return err.message
        end
    end

    def addTask
        begin
            file = File.new("Task.csv", "a")
        rescue => err
            return err
        else
            file.syswrite("#{@task.title},#{@task.desc},#{@task.deadline},#{@task.priority}\n")
            file.close
            @task_arr = readFile
            return "#{@task.title} is successfully added...!"
        end
    end

    def updateTask(title, desc, deadline, priority)
        begin
            temp = File.new("temp.csv", "a")
            flag = false
            @task_arr.each do | line |
                if (line.split(",")[0]==title)
                    temp.write("#{title}, #{desc}, #{Date.parse(deadline)}, #{priority}")
                    flag = true
                else
                    temp.write(line)
                end
            end
            replace
            return flag ? "Task Updated Successfully" : flag
            file.close
        rescue => err
            # return "No such file or directory Found"
            return err
        end
    end

    def deleteTask(task_name)
        begin
            temp = File.new("temp.csv", "a")
            flag = false
            @task_arr.each do | line |
                if (line.split(",")[0]!=task_name)
                    temp.write(line)
                else
                    flag = true
                end
            end 
            replace
            return flag ? "Task Deleted successfully" : flag
            temp.close
        rescue => err
            return err.message
        end
    end

    def replace
        File.delete("Task.csv")
        File.rename("temp.csv", "Task.csv")
    end

    def displayTask
        begin
            over_due = Proc.new { |file_arr|
                arr = []
                file_arr.each do |line|
                    if Date.parse(line.split(",")[-2])<Date.today
                        arr.push(line.split(",")[0])
                    end
                end
                return arr
            }
            return over_due.call(@task_arr).length==0 ? "No Overdue task found" : over_due.call(@task_arr)
            file.close
        rescue => err
            return err.message
        end
    end

    def displayByPriority(pro)
        begin
            resultArr = @task_arr.select {|line| line.split(",")[-1]==pro+"\n"}.map {|line| line.split(",")[0]}
            return resultArr.length!=0 ? resultArr : "No task is assigned with this priority"   
        rescue => err
            return err.message
        end
    end

    def scheduleTask
        begin
            file = readFile
            task_list = file.map {|line| line.split(",")[0]}
            proc = Proc.new { |index|
                puts "#{task_list[index]} is Completed"
            }
            Thread.new do
                index = 0
                loop do 
                    sleep(5)
                    proc.call(index)
                    index += 1
                end
            end
            times = 6*(task_list.length)
            sleep(times)
            return true
        rescue => err
            return err.message
        end
    end
end

# Rspec script to test the TaskScheduler Class
describe TaskScheduler do

    let(:task_obj) {
            task_obj = TaskScheduler.new("Learn Ruby", "Learn the Ruby on rails within 2 weeks", "10-01-2025", "High")
    }

    after("#addTask") {
        File.exist?("Task.csv") ? File.delete("Task.csv") : nil
    }

    describe "addTask" do
        context "when task is added successfully" do
            it "Should return the success message with the book name" do
                expect(task_obj.addTask).to eq("#{task_obj.task.title} is successfully added...!")
            end
        end
    end

    describe "updateTask" do
        context "When file updated successfully" do
            it "Should return the success message" do
                task_obj.addTask
                expect(task_obj.updateTask("Learn Ruby", "Learn Ruby on rails", "12-02-2024", "low")).to eq("Task Updated Successfully")
            end
        end
        context "When file doesn't contain the task" do
            it "Should return false" do
                task_obj.addTask
                expect(task_obj.updateTask("Learn Ruby", "Learn Ruby on rails", "12-02-2024", "low")).not_to be false
            end
        end
    end

    describe "deleteTask" do
        context "When file deleted successfully" do
            it "Should return the success message" do
                task_obj.addTask
                expect(task_obj.deleteTask("Learn Ruby")).to eq("Task Deleted successfully")
            end
        end
        context "When file doesn't contain the task" do
            it "Should return false" do
                task_obj.addTask
                expect(task_obj.deleteTask("Learn Ruby")).not_to be false
            end
        end
    end

    describe "#readFile" do 
        context "When file or directory not found" do
            it "should return the error message" do
                expect { task.readFile }.to raise_error(StandardError)
            end
        end
    end

    describe "#displayTask" do
        context "When file already exist and overdue task found" do
            it "should return arr of the task title" do
                overdue_task = TaskScheduler.new("Should complete Day-3 topics", "Learn the ruby topics like (file, Struct, Procs, Lambda)", "28-12-2024", "Low")
                overdue_task.addTask
                expect(overdue_task.displayTask).to eq([overdue_task.task.title])
            end
        end
        context "When file already exist and no overdue task found" do
            it "should return no overdue message" do
                task_obj.addTask
                expect(task_obj.displayTask).not_to eq([task_obj.task.title])
            end
        end
        context "when filter by the priority" do
            it "Should return the array of task title" do
                task2 = TaskScheduler.new("Ruby on Rails", "Learn the Ruby on rails within 2 weeks", "10-01-2025", "Low")
                task_obj.addTask
                task2.addTask
                expect(task_obj.displayByPriority("High")).to eq([task_obj.task.title])
            end
        end
    end 

    describe "#Schedule Task" do
        context "When tasks are completed successfully" do
            it "Should return true" do
                task_obj.addTask
                expect(task_obj.scheduleTask).to be true
            end
        end
    end
    
end