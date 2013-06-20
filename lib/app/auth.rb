class ExercismApp < Sinatra::Base

  get '/logout' do
    logout
    redirect '/'
  end

  if ENV['RACK_ENV'] == 'development'
    get '/backdoor' do
      session[:github_id] = params[:id]
      redirect '/'
    end
  end

  get '/login' do
    redirect "https://github.com/login/oauth/authorize?client_id=#{ENV.fetch('EXERCISM_GITHUB_CLIENT_ID')}"
  end

  # Callback from github. This will include a temp code from Github that
  # we use to authenticate other requests.
  # If we get a code, the user has said okay.
  get '/github/callback' do
    unless params[:code]
      halt 400, "Must provide parameter 'code'"
    end
    user = Authentication.perform(params[:code])
    login(user)
    redirect "/"
  end

end