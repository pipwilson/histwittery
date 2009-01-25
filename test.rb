require 'rexml/document'
require "date"

include REXML

# finding out how many per day.

file = File.new("pip_timeline_page1.xml")
doc = Document.new(file)

status_updates = {}

# if date not in hash, add it, otherwise increment count
doc.elements.each('//created_at') do |ele|
    date = Date.parse(ele.text)
        if status_updates[date] == nil
                status_updates[date] = 1
                    else
                            status_updates[date] = status_updates[date]+1
                                end       
                                end
                                
                                keys = "'"+status_updates.keys.join("','")+"'"
                                values = status_updates.values.join(',')
                                
                                File.open('data.json').each_line do |l|
                                  puts eval(%Q{"#{l}"})
                                  end
                                  
                                  #puts "\"labels\": [#{keys}]"
                                  #puts values
                                  
                                  #puts time1 = Date.parse(XPath.each( doc, "//created_at" ).text)
                                  #puts time1 = Date.parse(XPath.last( doc, "//created_at" ).text)
                                  #puts time1.next()
                                  
                                  
