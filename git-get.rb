require 'rubygems'
require 'sinatra'
require 'json'
require 'git'

configure do
  set :repos, {"puppet-manifests" => "/etc/puppet/manifests", "puppet-modules" => "/etc/puppet/modules" }
  set :masteronly, false
end

configure :production do
  set :masteronly, true
end

get '/' do
  '<html><body><font size=72>It is not right to issue a get request to me. It hurts my feelings.
   Send a POST card instead.<br>Seriously though... this is a post recieve hook service<br>
   So uh go to github and configure this junk...</font></body></html>'
end

post '/' do
  git_data = JSON.parse(params[:payload])
  repository = git_data['repository']['name']
  branch = git_data['ref'].split(/\//)[2]
  hash = git_data['after']
  "#{repository} and #{hash} and #{branch}"
  pull(repository,branch,hash)
end

get '/ping' do 
  "pong"
end

helpers do
  def pull(repository,rbranch,hash)
    repos = settings.repos
    return "invalid repo" unless repos.has_key?(repository)
    return "I only deploy master" if settings.masteronly && rbranch != "master"
    puts rbranch
    g = Git.open(repos[repository])
    g.fetch(g.remote())
    g.checkout(rbranch)
    g.lib.send(:command, 'pull')
    return "done"
  end
end
