require 'net/http'
require 'uri'
require 'json'

#########################################
# Set variables
#########################################

api_token=""
yourOktaDomain=""

#########################################
# Read file and save emails as an array
#########################################

ef = File.new("email_list.txt")
email_li =  Array.new()
email_li = ef.readlines

#########################################
# Create request URI
#########################################

email_li.each do |e|

    #Fetch user id
    uri = URI.parse('https://' + yourOktaDomain + '.okta.com/api/v1/users?q='+ e + '&limit=1')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true # say 'I will use ssl'

    req = Net::HTTP::Get.new(uri.request_uri)

    req.add_field('Accept','application/json' )
    req.add_field('Content-Type','application/json' )
    req.add_field('Authorization', "SSWS #{api_token}")

    res = http.request(req)

    ary = JSON.parse(res.body)
    hash = ary[0]
    uid = hash.fetch("id")
    p uid

    #Deactivate user
    deact_uri = URI.parse('https://' + yourOktaDomain + '.okta.com/api/v1/users/' + uid + '/lifecycle/deactivate')    

    deact_http = Net::HTTP.new(deact_uri.host, deact_uri.port)
    deact_http.use_ssl = true # say 'I will use ssl'
    
    deact_req = Net::HTTP::Post.new(deact_uri.request_uri)
    
    deact_req.add_field('Accept','application/json' )
    deact_req.add_field('Content-Type','application/json' )
    deact_req.add_field('Authorization', "SSWS #{api_token}")

    deact_res = deact_http.request(deact_req) # deactivate user
    p deact_res.body

    #Delete user
    del_uri = URI.parse('https://' + yourOktaDomain + '.okta.com/api/v1/users/' + uid)    

    del_http = Net::HTTP.new(del_uri.host, del_uri.port)
    del_http.use_ssl = true # say 'I will use ssl'
    
    del_req = Net::HTTP::Delete.new(del_uri.request_uri)
    
    del_req.add_field('Accept','application/json' )
    del_req.add_field('Content-Type','application/json' )
    del_req.add_field('Authorization', "SSWS #{api_token}")

    del_res = del_http.request(del_req) # deactivate user
    p del_res.body

end

# please prepare a text file named "email_list.txt" and 
# list email address of users who will be deleted as below.
# -----------
# usera@example.com
# userb@example.com
# userc@example.com