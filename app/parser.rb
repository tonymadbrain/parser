require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'httparty'
require 'net/http'
require 'date'
require 'time'
require 'yaml'
require 'mail'
require 'mysql'

# db connection
host     = "localhost"
user     = "parser_user"
password = "parser"
database = "parser"

# Time
date_and_time = "%Y-%b-%d %H:%M:%S"
time          = Time.now.strftime(date_and_time)

# Some variables
prices = {}

# Load items from db
mysql = Mysql.new(host, user, password, database)
items = mysql.query("SELECT * FROM #{database}.items;")
items_num_rows = items.num_rows
items.each_hash do |item|
  begin
    uri  = URI.parse(URI.encode(item['url'].strip))
    res  = Net::HTTP.get_response(uri)
    page = Nokogiri::HTML.parse(res.body)
    puts item
    prices[item['url']] = page.at("//#{item['div']}[@#{item['itemprop']} = '#{item['itemprop_value']}']").text.gsub(/\s+/, "").delete("^0-9").to_i
    puts "Parsing OK"
  rescue
    prices[item['url']] = 0
    puts "Some parsing error"
  end
end
mysql.close if mysql

# Save data into db
prices.each do |url, price|
  baseurl = URI.join(url, "/").to_s
  # price url baseurl
  mysql = Mysql.new(host, user, password, database)
  select = mysql.query("SELECT name FROM #{database}.cheks WHERE name='#{baseurl}';")
  select_num_rows = select.num_rows
  # select.fetch_row.join("\s")
  if select_num_rows == 1
    mysql.query("UPDATE #{database}.cheks SET `price` = '#{price}', `url` =  '#{url}' WHERE name='#{baseurl}';")
    puts "UPDATE"
  else
    mysql.query("INSERT INTO #{database}.cheks (name, price, url, created_at) VALUES('#{baseurl}', '#{price}', '#{url}', '#{time}');")
    puts "INSERT"
  end
  mysql.close if mysql
end