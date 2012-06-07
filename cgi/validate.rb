#!/usr/bin/ruby

require 'net/http'
require 'net/https'
require 'cgi'

def validate(receipt, sandbox = false)

# This core reads an file called receipt (see an example bellow)
params_json = "{ \"receipt-data\": \"#{receipt}\" }"

puts params_json

# Use net/http to post to apple sandbox server
uri = URI("https://sandbox.itunes.apple.com") # Use "https://buy.itunes.apple.com" for production
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

http.start do |http|
  response = http.post('/verifyReceipt', params_json)
  # Puts the result! (see an example below - result.json)
  puts response.body
end

end


get '/validate' do
  "hello world"
  
  cgi = CGI.new
  puts cgi.header
  puts cgi.params.keys

  if cgi.params.has_key?('receipt')
    receipt = cgi.params['receipt'].first
    validate receipt.read
  end

end