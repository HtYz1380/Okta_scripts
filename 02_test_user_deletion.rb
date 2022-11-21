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

uri = URI.parse('https://' + yourOktaDomain + '.okta.com/api/v1/users?q=user&limit=200')

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
# Fetch user id and delete the user 
#########################################

ary.each do |hs|
    uid = hs.fetch("id")

    del_uri = URI.parse('https://' + yourOktaDomain + '.okta.com/api/v1/users/' + uid)    

    del_http = Net::HTTP.new(del_uri.host, del_uri.port)
    del_http.use_ssl = true # say 'I will use ssl'
    
    del_req = Net::HTTP::Delete.new(del_uri.request_uri)
    
    del_req.add_field('Accept','application/json' )
    del_req.add_field('Content-Type','application/json' )
    del_req.add_field('Authorization', "SSWS #{api_token}")

    del_res = del_http.request(del_req) # deactivate user
    del_res = del_http.request(del_req) # delete user
    
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
