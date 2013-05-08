#!/usr/bin/ruby
require 'json'
require 'tinder'
require 'escape'
require 'etc'

CONFIG_PATH = "#{File.dirname(__FILE__)}/config/campfire.json"
config = JSON.parse(File.read(CONFIG_PATH))

# TODO: Get this shoved into a class
ICON_PATH=config['icon']
LOG_PATH = "#{File.dirname(__FILE__)}/logs"

def log_message(room_name, author, body)
  File.open("#{LOG_PATH}/#{room_name}.log", "a") { |f| f.write("[#{Time.now.iso8601}] #{author}: #{body}\n") }
end

def dispatch_message(summary, body)
  
  shell_raw = [
    'notify-send',
    '-u', "critical", '-a', "SmokeSignal",
    '-i', "#{ICON_PATH}",
    "#{summary}", "#{body}"
  ]

  system(Escape.shell_command(shell_raw))
end

# TODO: Put this into a seperate file along with other gem structure
module SmokeSignal

  
  class CampfireClient
    def initialize(config)
      @config = config
      @campfire = Tinder::Campfire.new @config['subdomain'], :token => @config['token']
      @rooms = []
    end

    def listen_on_rooms()
      @config['rooms'].each do | room_name | 
        room_search_result = @campfire.find_room_by_name(room_name)
        # TODO: figure out better method of dealing with this
        setup_listener_thread(room_search_result) unless room_search_result == nil
      end
      
      @rooms.each { | room | room.thread.join }
    end

    def setup_listener_thread(room)
      room_listener = RoomListener.new(room, @config['notifications'])
      room_listener.thread = Thread.new(room_listener) { | campfire_room | campfire_room.listen }
      @rooms << room_listener
    end

  end

  class RoomListener
    attr_accessor :thread

    def initialize(room, notifications)
      @room = room
      @thread = nil
      @notifications = notifications
    end

    def listen()
      puts "Listening on #{@room.name}"
      @room.listen do | message |
        @notifications.each do | notification |
          if message[:body] =~ /(\W|\s|^)#{Regexp.escape(notification)}(\W|\p|\s)/i
            dispatch_message "New Campfire Message", "[#{@room.name}] #{message[:user][:name]}: #{message[:body]}"
            log_message @room.name, message[:user][:name], message[:body]
          end
        end
      end
    end

  end

end

# TODO: Figure out the specific exception to handle against
#       for partial HTTP request errors
loop do
  begin
    client = SmokeSignal::CampfireClient.new config
    client.listen_on_rooms
  rescue
  end
end
