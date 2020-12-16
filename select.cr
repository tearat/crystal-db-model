require "db"
require "mysql"


class Book 
  # To specify all columns and types manually, it isn't good idea I think
  # Maybe I can use schema hash object
  @@attrs = ["name", "speed", "attack"]
  @@types = {String, Int32, Int32}

  def self.types
    @@types
  end

  def self.parse (result)
    rows = {} of String => String | Int32 # I have to get real types from the table, not harcoded kit
    (0...result.size).each do |i|
      attr = @@attrs[i]
      value = result[i]
      row = { attr => value }
      rows[attr] = value
    end
    rows
  end

end

db = DB.open "mysql://root:root@localhost/pokemon_dev"

begin
  items = [] of Hash(String, String|Int32)
  db.query "select name, speed, attack from pokemons limit 5" do |rs|
    rs.each do
      item = Book.parse(rs.read(*Book.types)) # Nah
      items << item
    end
  end
  p items
ensure
  db.close
end