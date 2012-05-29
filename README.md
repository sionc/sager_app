sager
=====

Rails site for Project Sager

**Please only commit changes to the develop branch, we will merge into master when the code is ready**

Seeded account:

email => 'tim@contoso.com'
passord => 'password'
mac\_address => '00:0C:29:60:65:18'
local_id => 1

Sample curl POST against the sensor\_readings api (watthours are in integers!):

curl -i -H "Accept: application/json" -X POST -d 'sensor_reading[watthours]=90&sensor_reading[local_id]=1&sensor_reading[mac_address]=00:0C:29:60:65:18' http://localhost:3000/sensor_readings
