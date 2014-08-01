require 'rubygems'
require 'bundler/setup'

require 'artoo'

# usage:
#  - double-check the :port=> option below, haven't changed it because it ~works-on-my-machine~
#  - start this script using `ruby jenkins_indicator.rb`
#  - use curl to control the color, e.g.
#    `curl --data "" http://localhost:4321/robots/RGB_LED/devices/rgb_led/commands/red`
#  - arbitrary colors don't work yet because POST parameters in artoo are bugged somehow???

class RGBRobot < Artoo::Robot
  connection :arduino, :adaptor=>:firmata, :port=>get_arduino_dev
  device :rgb_led, { :driver => :rgb_led, :red_pin => 3, :green_pin => 5, :blue_pin => 6 }
  api :host => '127.0.0.1', :port => '3000'

  work do
    puts "Hello from '#{name}' attached to API running at #{api_host}:#{api_port}..."
    rgb_led.off

    every(1.seconds) do
      #
    end
  end
end

def get_arduino_dev
  glob = '/dev/ttyUSB*'
  devices = Dir.glob(glob)
  throw "can't find a device file under #{glob} -- is it plugged in?" unless devices.count > 0
  # XXX going to assume only one usb device
  devices.first
end

robot = RGBRobot.new(name: "RGB_LED")
RGBRobot.work!([robot])
sleep

