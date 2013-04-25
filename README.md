git-get
=======
A tiny web service to receive post commit hooks from github and do a pull

requires
=======
Ruby 
Git 
Gems:
 1. git
 2. json
 3. rack 
 4. rack-protection
 5. sinatra
 6. thin
 7. tilt 

running
=======
Change the configuration to match your environment, it's a hash where the key is the repository name, and the value is the local filesystem directory. The user that the web service is running as must have permissions to the local directory and to the git repository (hint: deploy keys). 

if :masteronly is set (default when RAKE\_ENVIRONMENT=production) then only master will be pulled, otherwise any branch will be pulled. 

Example: nohup ruby git-get > /dev/null 2>&1 & 

To run automatically and keep running, I use inittab. For a development environment add the following to inittab (update to your paths): 
g17:234:respawn:/usr/bin/ruby /home/rmaynard/git-get/git-get.rb > /var/log/git-get.log 2>&1

For a production/master only environment use the shell script in this repo (git-get.sh), update to your paths, then add to inittab:
g17:234:respawn:/home/rmaynard/git-get/git-get.sh

If the service dies it will be restarted, when the box is booted, it will be started. It won't fix if the service becomes stuck or wedged, it's not monitoring, but if the service is critical to you, monitor the git endpoint. 
