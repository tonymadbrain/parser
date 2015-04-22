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

# Some variables
prices = {}
html_mail = "<table>"
filename = "./public/index.html"
html_file = "<html><head><meta charset='utf-8'><title>Парсер цен на MacBook</title><meta name='viewport' content='width=device-width, initial-scale=1.0'><meta name='description' content=''><meta name='author' content=''><link href='css/bootstrap.min.css' rel='stylesheet'><script type='text/javascript' src='js/jquery.min.js'></script><script type='text/javascript' src='js/bootstrap.min.js'></script></head><body><div class='navbar navbar-default navbar-static-top'><div class='container container-fluid'><div class='navbar-header'><a type='button' class='navbar-toggle' data-toggle='collapse' data-target='.navbar-collapse'></a><span class='sr-only'>Навигация</span><span class='icon-bar'></span><span class='icon-bar'></span><span class='icon-bar'></span><a class='navbar-brand' href='#'>Парсер цен на MacBook</a></div></div></div><div class='container'><div class='row'><div class='col-md-3'><div class='well'><p>Последний запуск парсера: #{time}</p></div></div><div class='col-md-9'><table class='table table-condensed'><thead><tr><th>Цена</th><th>Ссылка</th></tr></thead><tbody>"

#return unless File.exists?("shops.txt") 
File.readlines("./config/shops.txt").each do |s|
  begin
	s = s.chomp.split("|")
	uri  = URI.parse(URI.encode(s[4].strip))
	res  = Net::HTTP.get_response(uri)
	page = Nokogiri::HTML.parse(res.body)
	prices[s[4]] = page.at("//#{s[1]}[@#{s[2]} = '#{s[3]}']").text.gsub(/\s+/, "").delete("^0-9").to_i
  rescue
    prices[s[4]] = 000
  end
end

# Sorting
sd_prices = prices.sort_by { |k, v| v }

# Preparing html for mail
sd_prices.each do |url, price|
  html_mail += "<tr><td>#{price}</td><td>#{url}</td></tr>"
  baseurl = URI.join(url, "/").to_s
  html_file += "<tr><td>#{price}</td><td><a href='#{url}' target='_blank'>#{baseurl}</a></td></tr>"
end
html_mail += "</table>"
html_file += "</tbody></table></div></div></div></body></html>"

# Prepare html for file
File.delete(filename) if File.exists?(filename)
File.open(filename, "w") do |f|
  f.puts html_file
end

begin
  options = YAML.load_file('./config/mail.yml')
rescue
  puts "Error when trying read config file for mail. Check that config/mail.yml exists."
end

begin
  Mail.defaults do
    delivery_method :smtp, options
  end

  #Sending
  Mail.deliver do
    from     "admin@doam.ru"
    to       "mail@doam.ru"
    subject  "Парсер цен на Macbook ".force_encoding("UTF-8")
    html_part do
      content_type "text/html; charset=UTF-8"
      body     "#{html_mail}"
    end
  end
rescue
  puts "Error with mail send"
end