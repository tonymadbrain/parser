require 'yaml'
require 'mysql'

# db connection
host     = "localhost"
user     = "parser_user"
password = "parser"
database = "parser"

#return unless File.exists?("shops.txt") 
File.readlines("../config/shops.txt").each do |s|
  s = s.chomp.split("|")
  mysql = Mysql.new(host, user, password, database)
  select = mysql.query("SELECT name FROM #{database}.items WHERE name='#{s[0]}';")
  select_num_rows = select.num_rows
  if select_num_rows == 1
    puts "Exists"
  elsif select_num_rows < 1
    mysql.query("INSERT INTO #{database}.items (`name`, `url`, `div`, `itemprop`, `itemprop_value`) VALUES('#{s[0]}', '#{s[4]}', '#{s[1]}', '#{s[2]}', '#{s[3]}');")
  elsif select_num_rows > 1
    puts "Exists and more than 1"
  end
  mysql.close if mysql
end

