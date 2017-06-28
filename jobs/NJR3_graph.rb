## Populate graph and point with data from database
require 'mysql'

def getCurrentValuesFromDB(client, nodeName)
  rs = client.query("SELECT wind_velocity, temperature FROM " + nodeName )
  wind_velocity = 0
  temperature = 0
  rs.each do |r|
    wind_velocity = r[0]
    temperature = r[1]
  end
  return wind_velocity.to_i, temperature.to_i
end

numTempData = 5

wind_velocity = []
(1..numTempData).each do |i|
  wind_velocity << { x: i, y: 0}
end
wind_velocity_last_x = wind_velocity.last[:x]


temperature = []
(1..numTempData).each do |i|
  temperature << { x: i, y: 0}
end
temperature_last_x = temperature.last[:x]


SCHEDULER.every '5s', :first_in => 0 do |job|
  client = Mysql::connect('localhost', 'root', 'pass', 'yusuke')

  puts "hogehogehoge!!!"

  wind_velocity, temperature = getCurrentValuesFromDB(client, "windnode")

  wind_velocity.shift
  wind_velocity_last_x += 1
  wind_velocity << {x: wind_velocity_last_x, y: wind_velocity}
  send_event('wind_velocity', points: wind_velocity)

  temperature.shift
  temperature_last_x += 1
  temperature << {x: temperature_last_x, y: temperature}
  send_event('temperature', points: temperature)

  client.close()
end



