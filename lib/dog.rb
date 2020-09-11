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
    
    attributes = {
    :id => row[0],
    :name => row[1],
    :breed => row[2]
    }
    
    self.new(attributes)
    
  end
  
  def self.find_by_id(id)
    sql = "SELECT *
           FROM dogs
           WHERE id = ?"
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  
  

end