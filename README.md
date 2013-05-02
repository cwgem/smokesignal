## Introduction ##

SmokeSignal is a simple script to notify of certain messages in a campfire room. It is a hacked together script, but feel free to fork it to improve it to your needs. Features:

* Notify for multiple rooms
* Notify for multiple regex patterns
* Uses token authentication instead of user/password
* Notifications stay up until you notice them
* Logs to a `logs/` directory in the program folder just in case

## Requirements ##

This code has been run and tested Ruby 1.9.3. 

### External Deps ###

* [libnotify](https://developer.gnome.org/libnotify/) uses notify-send CLI for notifications
* [escape](http://rubygems.org/gems/escape) shell code escaping
* [tinder](https://github.com/collectiveidea/tinder) interface with the CampFire API

### Standard Libary Deps ###

* JSON for the config file

## Installation ##

First install libnotify:

* Ubuntu: `apt-get install libnotify`
* Fedora: `yum install libnotify`
* Gentoo: `emerge libnotify`
* Arch: `pacman -S libnotify`

First install the gems:

   gem install tinder escape

## More Information ##

More information can be found on the [project website on GitHub](http://github.com/cwgem/smokesignal). 

## Usage ##

First SmokeFire needs to be configured:

    "subdomain": "mysubdomain",

This is the subdomain for your campfire instance.
    
    "token": "campfire token",

This is the API authentication token, which can be found in https://mydomain.campfirenow.com/member/edit.

    "icon": "/usr/share/pixmaps/xscreensaver.xpm",

A path of the xpm icon to use for the notification.

    "rooms": ["List", "of", "rooms"],

A list of rooms to check for notifications.

    "notifications": ["List", "of", "patterns", "to", "check", "for"]

A list of patterns to check for. 

Once setup, you can run the program with:

    ruby snakefire.rb

And it will notify you when a campfire message contains one of the configured patterns. Due be aware that the notifications are set as critical for my case, so I don't miss them. 

## License ##

This project is licensed under the MIT license.

Copyright (c) 2013 Foobar Inc.
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Support ##

This is a simple script to fit a need so don't really expect any sort of support for it. However feel free to fork it to meet your needs. If you find a huge show stopping bug then feel free to issue a pull request. 
