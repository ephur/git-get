#!/bin/sh 

RACK_ENV=production
/usr/bin/env ruby /home/rmaynard/git-get/git-get.rb 1>/var/log/git-get.log 2>&1 

