# my_app.rb

require 'sinatra'
require 'net/http'
require 'net/https'

def validate(receipt, sandbox = false)
    
    # This core reads an file called receipt (see an example bellow)
    params_json = "{ \"receipt-data\": \"#{receipt}\" }"
    
    #puts params_json
    
    # Use net/http to post to apple sandbox server
    uri = URI("https://sandbox.itunes.apple.com") # Use "https://buy.itunes.apple.com" for production
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    http.start do |http|
        response = http.post('/verifyReceipt', params_json)
        # Puts the result! (see an example below - result.json)
        response.body
    end
    
end

class MyApp
    get '/validate' do
        "<html><body>\
        <h1>receipt validation tool</h1>\
        <form enctype=\"multipart/form-data\" action=\"/validate\" method=\"POST\">\
        Choose a file to upload: <input name=\"receipt\" type=\"file\" length=\"100\" /><br />\
        <input type=\"submit\" value=\"Upload File\" />\
        </form>\
        </body>\
        </html>"
    end
    
    post '/validate' do
        "Yummy!! " + validate(params['receipt'][:tempfile].read)
    end
end
