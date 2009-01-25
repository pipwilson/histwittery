
# find out how many calls I have left

# http://twitter.com/account/rate_limit_status.xml

require 'net/http'
require 'rexml/document'

remaining_calls = 0

USERNAME = ""
PASSWORD = ""

def get_remaining_calls

  remaining_calls = 0

  limit_url = "http://twitter.com/account/rate_limit_status.xml"

  xml_data = Net::HTTP.get_response(URI.parse(limit_url)).body

  doc = REXML::Document.new(xml_data)

  doc.elements.each('//hourly-limit') do |ele|
     remaining_calls = ele.text
  end

  return remaining_calls
end

def get_user_updatecount(username)

    update_count = 0

    user_url = "http://twitter.com/users/show/"+username+".xml"

    xml_data = Net::HTTP.get_response(URI.parse(user_url)).body

    doc = REXML::Document.new(xml_data)

    doc.elements.each('//statuses_count') do |ele|
       update_count = ele.text
    end

    return update_count

end

def get_direct_messages(username, password)

    dm_url = "http://twitter.com/direct_messages.atom"

    http = Net::HTTP.new('twitter.com')
    http.start do |http|
        req = Net::HTTP::Get.new('/direct_messages.atom')

        # we make an HTTP basic auth by passing the
        # username and password
        req.basic_auth USERNAME, PASSWORD

        resp, messages = http.request(req)

        aFile = File.new("directmessages.xml", "w")
        aFile.write(messages)
        aFile.close

       #puts messages
    end

end

def get_timeline_page(pagenumber)

    timeline_url = "http://twitter.com/statuses/user_timeline.atom?count=200&page="+pagenumber.to_s

    http = Net::HTTP.new('twitter.com')
    http.start do |http|
        req = Net::HTTP::Get.new('/statuses/user_timeline.atom?count=200&page='+pagenumber.to_s)

        # we make an HTTP basic auth by passing the
        # username and password
        req.basic_auth USERNAME, PASSWORD

        resp, messages = http.request(req)

        return messages

    end

end

def save_to_file(messages, filename)
    aFile = File.new(filename, "w")
    aFile.write(messages)
    aFile.close
end

remaining_calls = get_remaining_calls

# first attempt counts pages of tweets, then gets them. This is bad in the long 
# run because page=1 is the most recent tweets rather than the first ones
number_of_pages = ((get_user_updatecount(USERNAME).to_f)/200).ceil()

for i in 0..number_of_pages
  if remaining_calls.to_i > 5
    save_to_file(get_timeline_page(i), USERNAME+"_timeline_page"+(i.to_s)+".atom")
  end    
end

#puts get_direct_messages(USERNAME, PASSWORD)

# get page 1 and save to file

#save_to_file(get_timeline_page(1), "timeline_page"+(1.to_s)+".atom")
