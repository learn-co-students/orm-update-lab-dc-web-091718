require_relative "../config/environment.rb"

class Student

	attr_accessor :name, :grade,:id

	def initialize(name,grade)
		@name, @grade = name,grade
		@id = nil
	end	

	def save
		if !!!self.id
			sql = <<-SQL
				INSERT INTO students(id,name,grade) VALUES (?,?,?)
			SQL
			DB[:conn].execute(sql,self.id,self.name,self.grade)
			@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
		else
			update
		end
	end

	def update 
	    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
	    DB[:conn].execute(sql, self.name, self.grade, self.id)
	end

	def self.find_by_name(name)
 		sql = "SELECT * FROM students WHERE name = ?"
   		student = Student.new_from_db(DB[:conn].execute(sql, name)[0])
   		student
	end

	def self.new_from_db(row)
    # create a new Student object given a row from the database
	    stud = Student.new(row[1],row[2])
	    stud.id = row[0]
	    stud

	end

	def self.create(name,grade)
		student = Student.new(name,grade)
		student.save
		student

	end

	def self.create_table
		sql = "CREATE TABLE IF NOT EXISTS students (
			id INTEGER PRIMARY KEY,
			name TEXT,
			grade INTEGER
		);"
		DB[:conn].execute(sql)
	end

	def self.drop_table
		sql = "DROP TABLE IF EXISTS students;"
		DB[:conn].execute(sql)
	end
 

end
