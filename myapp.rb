require 'rubygems'
require 'sinatra'
require 'rexml/document'
require 'date'

get '/' do
    'Hello world!'
end

get '/data.json' do

  setKeysAndValues
                                
  #'Hello world!'
  #@keys = 'keys go here'
  #@values = 'values go here'
  erb :data
end

def setKeysAndValues
  file = File.new("pip_timeline_page1.xml")
  doc = REXML::Document.new(file)

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
                                
  @keys = '"'+status_updates.keys.join('","')+'"'
  @values = status_updates.values.join(',')

end
