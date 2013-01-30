# Gemfile
require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra/json"
require "mongoid"

Bundler.require

Mongoid.load!("config/mongoid.yml", :development)

Dir['./lib/**/*.rb'].each do |file|
  require file
end

use Rack::Static, :urls => ["/javascript", "/images", "/css", "/partials"], :root => "public", :index => "index.html"
use Rack::Session::Cookie, :secret => 'secret_token'

set :run, false
set :raise_errors, true

map "/users" do
	run MyApp::UsersCtlr
end

map "/requests" do
	run MyApp::RequestsCtrl
end

map "/documents" do
	run MyApp::DocumentsCtrl
end

map "/entities" do
	run MyApp::EntitiesCtrl
end

map "/locks" do
	run MyApp::LocksCtrl
end

map "/test" do
	run MyApp::TestCtrl
end