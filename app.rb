# app.rb
# no warranty, etc, you know.

require 'sinatra'
require 'net/http'
require 'net/https'

def validate(receipt, sandbox = false)
    
    # This core reads an file called receipt (see an example bellow)
    params_json = "{ \"receipt-data\": \"#{receipt}\" }"
    
    #puts params_json
    
    # Use net/http to post to apple sandbox server
    uri = URI("https://sandbox.itunes.apple.com")
     # Use "https://buy.itunes.apple.com" for production
    if sandbox == false
	uri = URI("https://buy.itunes.apple.com")
    end
    
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
        <input type=\"checkbox\" name=\"sandbox\" value=\"sandbox\" />Sandbox?<br />\
        <input type=\"submit\" value=\"Upload File\" />\
        </form>\
        </body>\
        </html>"
    end
    
    post '/validate' do
	if params.key?('receipt')
	    validate(params['receipt'][:tempfile].read, params.has_key?("sandbox"))
	else
	    "No file was uploaded. <a href=\"/validate\">Retry</a>"
	end
    end
end
