import requests
import json
 
 
user_id = "<Softlayer User ID>"
key = "<Softlayer API Key>"
 
url = "https://api.softlayer.com/rest/v3/SoftLayer_Account/getVirtualGuests.json?objectMask=id;fullyQualifiedDomainName;primaryIpAddress;hostname"
response = requests.get(url, {}, auth=(user_id, key))
json_object = json.loads(response.text)
 
url = "https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/%s.json?objectMask=operatingSystem.passwords" % (json_object[-1]['id'])
response = requests.get(url, {}, auth=(user_id, key))
json_object = json.loads(response.text)
 
password = json_object['operatingSystem']['passwords'][0]['password']
 
f = open("c:/ansible/pw.txt", "w")
f.write(password)
f.close()
