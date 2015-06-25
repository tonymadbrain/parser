# Preparing html for mail
# sd_prices.each do |url, price|
#   html_mail += "<tr><td>#{price}</td><td>#{url}</td></tr>"
#   baseurl = URI.join(url, "/").to_s
#   html_file += "<tr><td>#{price}</td><td><a href='#{url}' target='_blank'>#{baseurl}</a></td></tr>"
# end
# html_mail += "</table>"
# html_file += "</tbody></table></div></div></div></body></html>"

# # Prepare html for file
# File.delete(filename) if File.exists?(filename)
# File.open(filename, "w") do |f|
#   f.puts html_file
# end

# begin
#   options = YAML.load_file('../config/mail.yml')
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