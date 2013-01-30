# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'coffeescript', :input => 'lib/coffee', :output => 'public/javascript'

guard 'haml', :input => 'public', :output => 'public' do
	watch(%r{^public/.+\.html\.haml})
end
