require 'net/http'
require 'uri'
require 'json'

#########################################
# Set variables
#########################################

api_token=""
yourOktaDomain=""

#########################################
# Create request URI
#########################################

uri = URI.parse('https://' + yourOktaDomain + '.okta.com/api/v1/users?limit=200')

#########################################
# Create HTTP instance from uri host and uri network port
#########################################

http = Net::HTTP.new(uri.host, uri.port)

http.use_ssl = true # say 'I will use ssl'

#########################################
# Create request instance from HTTP
#########################################

req = Net::HTTP::Get.new(uri.request_uri)

# add nessesary headers...

req.add_field('Accept','application/json' )
req.add_field('Content-Type','application/json' )
req.add_field('Authorization', "SSWS #{api_token}")

#########################################
# Get a rest API response and save it as a variable named "res"
#########################################

res = http.request(req)

# below line is just for print response code and message saying "OK"
# puts res.code, res.msg

#########################################
# Insert a responce body to variable
#########################################

ary = JSON.parse(res.body)

#########################################
# Parse the responce body and fetch values from each factor of array.
# note that each factor of array is a Hush instance.
#########################################

ary.each do |hs|
    puts hs.fetch("id")
end

# if you would like to snip a piece of users, 
# please uncomment below line and see what propaties a user has
# puts ary[0]

#########################################
# other lines for inspection and test...
#########################################

# puts ary.class
# puts ary[1].class
# puts ary[1].fetch("id")
# puts ary[1].fetch("status")
