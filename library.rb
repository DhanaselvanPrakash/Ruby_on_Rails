arr = Array.new()

def searchBook(arr, title)
    resultArr = arr.select {|book| book[0]==title}
    if resultArr.length()==0 then
        puts "Book not Found"
    else
        for i in resultArr
            puts "Book Title: #{i[0]}\nAuthor's Name: #{i[1]}\nBook Genre: #{i[2]}"
        end
    end
end

def getBookByGenre(arr, genre)
    resultArr = arr.select { |book| book[2]==genre }.map {|items| items[0]}
    return resultArr
end

def getCountByAuthor(arr)
    hash = {}
    authorsArr = arr.map { |book| book[1]}
    for i in arr
        if (hash.has_key?(i[1]))
            hash[i[1]] += 1
        else
            hash[i[1]] = 1
        end
    end
    return hash
end

def displayBooks(arr)
    sortedArr = arr.map {|book| book[0] }.sort {|a,b| a[0]<=>b[0]}
    for i in (0..sortedArr.length()-1)
        if (i==sortedArr.length()-1)
            print sortedArr[i]
        else
            print sortedArr[i]+","
        end
    end
    puts
end

flag = true

until flag==false
    puts "\nPlease select your choice"
    puts "1. Add Book\n2. Search a book\n3. Filter by Genre\n4. Count book by Author\n5. Display all book titles\n6.Quit"
    choice = gets.to_i
    case choice
    when 1
        bookArr = Array.new(3)
        puts "Enter the book title:"
        bookArr[0] = gets.chomp
        puts "Enter the Author\'s name:"
        bookArr[1] = gets.chomp
        puts "Enter the Book Genre:"
        bookArr[2] = gets.chomp
        arr.push(bookArr)
    when 2
        puts "Enter the book title:"
        bookTitle = gets.chomp
        puts "".rjust(30, "*")
        searchBook(arr, bookTitle)
        puts "".rjust(30, "*")
    when 3
        puts "Enter the Book Genre:"
        genre = gets.chomp
        genreResult = getBookByGenre(arr, genre)
        puts "".rjust(30, "*")
        puts "Books under #{genre} genre:"
        puts
        puts genreResult
        puts "".rjust(30, "*")
    when 4
        count = getCountByAuthor(arr)
        puts "".rjust(30, "*")
        puts "#{count}"
        puts "".rjust(30, "*")
    when 5
        puts "".rjust(30, "*")
        displayBooks(arr)
        puts "".rjust(30, "*")
    when 6
        flag = false
    else
        puts "Invalid Choice...Please choose the correct one"
    end
end