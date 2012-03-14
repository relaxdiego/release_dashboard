require 'sinatra'
require 'json'

module ReleaseDashboard

  class Application < Sinatra::Base
    enable :sessions

    # Runs before every route
    before do
      unless session[:host]
        rd_config = YAML.load_file(File.open(File.expand_path('../config.yml',  __FILE__), 'r'))
        session[:host] = rd_config['host']
      end

      if missing_vars.length > 0 && !['/', '/login', '/logout'].include?(request.path_info)
        redirect to('/')
      end
    end

    # Routes
    get '/' do
      erb :login_form
    end

    post '/login' do
      session_var_keys.each do |key|
        session[key] = params[key]
      end
      redirect to('/dashboard'), 303
    end

    get '/logout' do
      session_var_keys.each do |key|
        session[key] = nil
      end
      redirect to('/'), 303
    end

    get '/releases/:start_at_index' do
      content_type :json
      curl "search?jql=project=MCR&startAt=#{params[:start_at_index]}"
    end

    get '/show_release/:issue_key' do
      redirect to("https://#{session[:host]}/browse/#{params[:issue_key]}")
    end

    get '/dashboard' do
      erb :dashboard
    end

    # Helper methods
    def curl(path)
      `curl -k -u #{session[:username]}:#{session[:password]} -X GET -H "Content-Type: application/json" "https://#{session[:host]}/rest/api/2/#{path}"`
    end

    def session_var_keys
      [:host, :username, :password]
    end

    def jira_host
      "http://#{session[:host]}"
    end

    def missing_vars
      missing = []
      session_var_keys.each do |key|
        missing << key unless session[key]
      end
      missing
    end

    def current_version
      vpath = File.expand_path('../version.yml',  __FILE__)
      vfile = File.open(vpath, 'r')
      ver = YAML.load_file(vfile)

      s = "v#{ver['major']}.#{ver['minor']}.#{ver['patch']}"
      s << "-(#{ver['pre-release']})".gsub('.', ' ') unless ver['pre-release'] == 'final'
      s
    end
  end #class Application < Sinatra::Base

end #module ReleaseDashboard