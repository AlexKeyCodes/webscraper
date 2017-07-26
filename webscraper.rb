require 'mechanize'
require 'date'
require 'json'
require 'csv'



array = CSV.read("input.csv")

array.flatten!
array.each do |a|
  a.gsub!(" ", "-")
end



agent = Mechanize.new do |name|
  name.user_agent_alias = "Linux Firefox"
end

restaurant_info_array = []
holder_array = []

array.each do |restaurant|
  restaurant_url = "https://www.url2scrape.com/" + restaurant

  begin
    page = agent.get(restaurant_url)
  rescue Mechanize::ResponseCodeError => e
    page = agent.get("https://www.backup.url")
  end

  website = page.search("a.btn-lg")[0]
  phone = page.search("span.text-muted").text
  facebook = page.search("a.social-link")[0]
  twitter = page.search("a.social-link")[1]

  website ||= "FALSE"
  phone ||= "FALSE"
  facebook ||= "FALSE"
  twitter ||= "FALSE"

  holder_array = [website['href'], phone, facebook['href'], twitter['href']]
  restaurant_info_array << holder_array
end


CSV.open('restaurant-week-info.csv', 'w') do |csv|
  restaurant_info_array.each do |row|
    csv << row
  end
end
