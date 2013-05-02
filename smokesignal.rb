#!/usr/bin/ruby
require 'json'
require 'tinder'
require 'escape'

CONFIG_PATH = "#{File.dirname(__FILE__)}/config/campfire.json"
LOG_PATH = "#{File.dirname(__FILE__)}/logs"

config = JSON.parse(File.read(CONFIG_PATH))

def dispatch_message(summary, body)
  shell_raw = [
    'notify-send',
    '-u', "critical", '-a', "SmokeSignal",
    '-i', "#{config['icon']}",
    "#{summary}", "#{body}"
  ]

  system(Escape.shell_command(shell_raw))
end

def log_message(room_name, author, body)
  File.open("#{LOG_PATH}/#{room_name}.log", "a") { |f| f.write("[#{Time.now.iso8601}] #{author}: #{body}\n") }
end

campfire = Tinder::Campfire.new config['subdomain'], :token => config['token']
threads = []

config['rooms'].each do | room |
  room = campfire.find_room_by_name(room)
  threads << Thread.new(room) { | campfire_room |
    puts "Notify for #{campfire_room.name}"
    campfire_room.listen do |message|
      config['notifications'].each do |notification|
        
        if message[:body] =~ /#{Regexp.escape(notification)}/i
          dispatch_message "New Campfire Message", "[#{campfire_room.name}] #{message[:user][:name]}: #{message[:body]}"
          log_message campfire_room.name, message[:user][:name], message[:body]
        end

      end
    end
  }
end

threads.each { |aThread| aThread.join }
