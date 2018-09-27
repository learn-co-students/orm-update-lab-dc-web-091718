require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQLite3
    CREATE TABLE students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQLite3

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQLite3
    DROP TABLE students
    SQLite3

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql =<<-SQLite3
      INSERT INTO students (name, grade) VALUES (?, ?)
      SQLite3
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    student = Student.new(row[1], row[2], row[0])
  end

  def update
    sql = <<-SQLite3
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQLite3
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.find_by_name(name)
    sql = <<-SQLite3
    SELECT * FROM students WHERE name = ?
    SQLite3
    row = DB[:conn].execute(sql, name).flatten
    student = Student.new_from_db(row)
  end

end
