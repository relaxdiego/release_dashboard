require 'sinatra'
require 'json'

module ReleaseDashboard

  class Application < Sinatra::Base
    enable :sessions

    get '/start/:host/:username/:password' do
      session[:host]     = params[:host]
      session[:username] = params[:username]
      session[:password] = params[:password]
      if session[:host] && session[:username] && session[:password]
        "OK"
      else
        "You missed a spot"
      end
    end

    get '/issue/:issue_id' do
      if session[:host] && session[:username] && session[:password]
        content_type :json
        `curl -k -u #{session[:username]}:#{session[:password]} -X GET -H "Content-Type: application/json" https://#{session[:host]}/rest/api/2/issue/#{params[:issue_id]}`
      else
        missing = []
        [:host, :username, :password].each do |key|
          missing << key unless session[key]
        end
        "#{missing} missing."
      end
    end

    get '/' do
      "Hello World!"
    end
  end

end