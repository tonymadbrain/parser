require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'httparty'
require 'net/http'
require 'mysql'

# db connection
host     = "localhost"
user     = "parser_user"
password = "parser"
database = "parser"

# Some variables
prices = {}

# Load items from db
mysql = Mysql.new(host, user, password, database)
items = mysql.query("SELECT * FROM #{database}.items;")
items_num_rows = items.num_rows
items.each_hash do |item|
  uri  = URI.parse(URI.encode(item['url'].strip))
  res  = Net::HTTP.get_response(uri)
  page = Nokogiri::HTML.parse(res.body)
  puts item
  puts "//#{item['div']}[@#{item['itemprop']} = '#{item['itemprop_value']}']"
  prices[item['url']] = page.at("//#{item['div']}[@#{item['itemprop']} = '#{item['itemprop_value']}']").text.gsub(/\s+/, "").delete("^0-9").to_i
end
mysql.close if mysql