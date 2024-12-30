# Importing the required packages or modules
require 'date'

# Expense Class
class Expense

    def initialize()
        @expenseList = Array.new()
    end

    def addExpense(category, amount, date)
            expenseHash = Hash.new
            expenseHash[category] = {
                :Amount => amount,
                :Date => date,
            }
            @expenseList.push(expenseHash)
            puts "\nExpense Added Successfully...!"
        puts "\n"
    end

    def viewAllExpense
        puts "\nAll Expense"
        puts "\n"
        @expenseList.each do |item|
            puts item.keys[0].ljust(15, " ") + item[item.keys[0]][:Amount].to_s.ljust(15, " ") + item[item.keys[0]][:Date].to_s
        end
        puts "\n"
    end

    def display(date)
        puts "All Expenses in #{date}:"
        puts "\n"
        flag = true
        @expenseList.each_with_index do |item, index|
            if (item[item.keys[0]][:Date]==date)
                flag = false
                puts item.keys[0].ljust(15, " ") + item[item.keys[0]][:Amount].to_s.rjust(15, " ")
            end
        end
        if (flag)
            puts "You don't have any expense history in the particular date...!"
        end
    end

    def updateExpense(category, expense, date)
        flag = true
        @expenseList.each_with_index do |item, index|
            if (item.keys[0]==category && item[item.keys[0]][:Date] == date)
                @expenseList.delete_at(index)
                @expenseList.insert(index,{item.keys[0] => {:Amount => expense, :Date => date}})
                puts "\nRecored updated successfully...!"
                flag = false
            end
        end
        if flag
            puts "\nNo record found in the particular category or date"
        end
        puts "\n"
    end

    def deleteExpense(category, date)
        keyArr = @expenseList.map {|items| items.keys()[0]}
        if (keyArr.include?(category))
            flag = true
            @expenseList.each_with_index do |item, index|
                if (item.keys[0]==category && item[item.keys()[0]][:Date]==date)
                    flag = false
                    @expenseList.delete_at(index)
                    puts "\n#{category} deleted from the record successfully...!"
                    break
                end
            end
            if (flag)
                puts "\nCategory Not Found...!"
            end
        else
            puts "\nCategory not Found...!"
        end
        puts "\n"
    end

    def totalExpense()
        sum = 0
        keyArr = @expenseList.map{ |item| item.keys()}
        @expenseList.each_with_index do |items, index|
            sum += items[keyArr[index][0]][:Amount]
        end
        return sum
    end

end

# Creating a object for the Expense class
obj = Expense.new

puts "Welcome to Expense Tracker Console App"
isStop = false
until isStop==true do
    puts "\nChoose an option:"
    puts "1. Add a new Expense\n2. Remove an Expense\n3. Update Expense Price\n4. View All Expense\n5. View Expense by Date\n6. Calculate Total Expense\n7. Exit"
    puts "\nEnter your Choice:"
    choice = gets.chomp.to_i
    case choice
    when 1
        puts "\nEnter the Category:"
        category = gets.chomp
        puts "Enter the Amount:"
        amount = gets.chomp.to_f
        while amount<=0
            puts "\nAmount should be More than Zero:"
            puts "\n"
            puts "Enter the Amount:"
            amount = gets.chomp.to_f
        end
        puts "Enter the Date: (DD-MM-YYYY)"
        date = Date.parse(gets.chomp)
        puts "\n"
        puts "".rjust(40, "*")
        obj.addExpense(category, amount, date)
        puts "".rjust(40, "*")
    when 2
        puts"\nEnter the Category you need to delete:"
        category = gets.chomp
        puts "Enter the Date: (DD-MM-YYYY)"
        date = Date.parse(gets.chomp)
        puts "\n"
        puts "".rjust(40, "*")
        obj.deleteExpense(category, date)
        puts "".rjust(40, "*")
    when 3
        puts "\nEnter the Category to Update:"
        category = gets.chomp
        puts "Enter the Expense amount:"
        expense = gets.chomp.to_f
        puts "\nEnter the Date: (DD-MM-YYYY)"
        date = Date.parse(gets.chomp)
        puts "\n"
        puts "".rjust(40, "*")
        obj.updateExpense(category, expense, date)
        puts "".rjust(40, "*")
    when 4
        puts "\n"
        puts "".rjust(40, "*")
        obj.viewAllExpense
        puts "".rjust(40, "*")
    when 5
        puts "\nEnter the Date: (DD-MM-YYYY)"
        date = Date.parse(gets.chomp)
        puts "\n"
        puts "".rjust(40, "*")
        puts "\n"
        obj.display(date)
        puts "\n"
        puts "".rjust(40, "*")
    when 6
        puts "\n"
        puts "".rjust(40, "*")
        puts "\n"
        print "Total Expense: "
        puts obj.totalExpense()
        puts "\n"
        puts "".rjust(40, "*")
    when 7
        isStop = true
    else
        puts "\n"
        puts "".rjust(
            40, "*")
        puts "\nInvaild Input...Please choose the correct option"
        puts "\n"
        puts "".rjust(40, "*")
    end
end