require 'sinatra'
require 'json'

module ReleaseDashboard

  class Application < Sinatra::Base
    enable :sessions

    #=========================
    # Runs before every route
    #=========================
    before do
      if not_logged_in? && requested_path_is_protected?
        redirect to('/')
      end
    end

    #========
    # Routes
    #========
    get '/' do
      erb :login_form
    end

    post '/login' do
      session_var_keys.each do |key|
        session[key] = params[key]
      end

      # Don't add this to session_var_keys. Otherwise, user
      # won't be able to login if this param is not set.
      session[:dev] = params[:dev]

      if authorized?
        redirect to('/dashboard'), 303
      else
        erb :login_failed
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

      if session[:dev]
        File.open(File.expand_path('../mocks/data.json',  __FILE__), 'r').gets
      else
        curl "search?jql=project=MCR&startAt=#{params[:start_at_index]}"
      end
    end

    get '/show_issue/:issue_key' do
      redirect to("https://#{jira_host}/browse/#{params[:issue_key]}")
    end

    get '/dashboard' do
      erb :dashboard
    end

    #================
    # Helper methods
    #================
    def curl(path)
      `curl -k -u '#{username}:#{password}' -X GET -H "Content-Type: application/json" "https://#{jira_host}/rest/api/2/#{path}"`
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
      session[:username] ||= nil
    end

    def password
      session[:password] ||= nil
    end

    def missing_vars
      missing = []
      session_var_keys.each do |key|
        missing << key unless session[key]
      end
      missing
    end

    def last_jira_result
      @result ||= "Unknown error. The server at #{jira_host} did not return anything."
    end

    def current_version
      vpath = File.expand_path('../version.yml',  __FILE__)
      vfile = File.open(vpath, 'r')
      ver = YAML.load_file(vfile)

      s = "v#{ver['major']}.#{ver['minor']}.#{ver['patch']}"
      s << "-#{ver['pre-release']}" unless ver['pre-release'] == 'final'
      s
    end

    def logged_in?
      username && password
    end

    def not_logged_in?
      !logged_in?
    end

    def requested_path_is_protected?
      !['/', '/login', '/logout'].include?(request.path_info) && !request.path_info.match(/show_issue/)
    end

    def authorized?
      if username.nil? || username.strip.empty? || password.nil? || password.strip.empty?
        @result = "Username and password should not be empty."
        return false
      end

      @result = `curl -D- -k -u '#{username}:#{password}' -X GET -H "Content-Type: application/json" "https://#{jira_host}/rest/api/2/project/MCR"`
      @result.include? "HTTP/1.1 200 OK"
    end

  end #class Application < Sinatra::Base

end #module ReleaseDashboard