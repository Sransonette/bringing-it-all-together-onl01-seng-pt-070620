require 'pry'

class Dog

  attr_accessor :id, :name, :breed

  

  def initialize(id: nil, name:, breed:)
    @name = name
    @breed = breed
    @id = id
    
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY, 
        name TEXT,
        breed TEXT
        )
    SQL
      DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs
    SQL

    DB[:conn].execute(sql)  
  end
  
  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end
  
  def self.create(name)
    dogs = Dog.new(name)
    dogs.save
    dogs
    
  end
  
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    
    dogs = self.new(id[0], name[1], breed[2])
    dogs
  end
  
  
  
  
  

end