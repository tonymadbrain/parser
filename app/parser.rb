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


# Time
date_and_time = "%Y-%b-%d %H:%M:%S"
time          = Time.now.strftime(date_and_time)

# #return unless File.exists?("shops.txt") 
# File.readlines("./config/shops.txt").each do |s|
#   begin
# 	s = s.chomp.split("|")
# 	uri  = URI.parse(URI.encode(s[4].strip))
# 	res  = Net::HTTP.get_response(uri)
# 	page = Nokogiri::HTML.parse(res.body)
# 	prices[s[4]] = page.at("//#{s[1]}[@#{s[2]} = '#{s[3]}']").text.gsub(/\s+/, "").delete("^0-9").to_i
#   rescue
#     prices[s[4]] = 000
#   end
# end

urls = { 
        blog:     "http://doam.ru",
        wifi48:   "http://www.wifi48.net",
        redmine:  "http://redmine.doam.ru",
        gitlab:   "http://git.doam.ru/users/sign_in"
      }

urls.each do |name, url|
  #puts "#{name} - #{url}"
  uri  = URI.parse(URI.encode(url.strip))
  res  = Net::HTTP.get_response(uri)
  page = Nokogiri::HTML.parse(res.body)
  puts page
end

# begin
#   options = YAML.load_file('./config/mail.yml')
# rescue
#   puts "Error when trying read config file for mail. Check that config/mail.yml exists."
# end

# begin
#   Mail.defaults do
#     delivery_method :smtp, options
#   end

#   #Sending
#   Mail.deliver do
#     from     "admin@doam.ru"
#     to       "mail@doam.ru"
#     subject  "Парсер цен на Macbook ".force_encoding("UTF-8")
#     html_part do
#       content_type "text/html; charset=UTF-8"
#       body     "#{html_mail}"
#     end
#   end
# rescue
#   puts "Error with mail send"
# end