require 'sinatra'
require 'json'

module ReleaseDashboard

  class Application < Sinatra::Base
    enable :sessions

    # Runs before every route
    before do
      if missing_vars.length > 0 && !['/', '/login', '/logout'].include?(request.path_info)
        redirect to('/')
      end
    end

    # Routes
    get '/' do
      @login_error = session[:e] == 1
      session[:e] = nil
      erb :login_form
    end

    post '/login' do
      session_var_keys.each do |key|
        session[key] = params[key]
      end

      if authorized?
        redirect to('/dashboard'), 303
      else
        session[:e] = 1
        redirect to('/'), 303
      end
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
      redirect to("https://#{jira_host}/browse/#{params[:issue_key]}")
    end

    get '/dashboard' do
      erb :dashboard
    end

    # Helper methods
    def curl(path)
      `curl -k -u #{username}:#{password} -X GET -H "Content-Type: application/json" "https://#{jira_host}/rest/api/2/#{path}"`
    end

    def session_var_keys
      [:username, :password]
    end

    def jira_host
      unless @jira_host
        rd_config = YAML.load_file(File.open(File.expand_path('../config.yml',  __FILE__), 'r'))
        @jira_host = rd_config['host']
      end
      @jira_host
    end

    def username
      session[:username]
    end

    def password
      session[:password]
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
      s << "-#{ver['pre-release']}" unless ver['pre-release'] == 'final'
      s
    end

    def authorized?
      if username.nil? || username.empty? || password.nil? || password.empty?
         return false
      end

      result = `curl -D- -k -u #{username}:#{password} -X GET -H "Content-Type: application/json" "https://#{jira_host}/rest/api/2/project/MCR"`
      result.include? "HTTP/1.1 200 OK"
    end

  end #class Application < Sinatra::Base

end #module ReleaseDashboard