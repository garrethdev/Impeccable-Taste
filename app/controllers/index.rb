require_relative '../helpers/movie_rating_api'
# require_relative 'movie_rating_api'
get '/' do

  if session['access_token']
    'You are logged in! <a href="/logout">Logout</a>'
     erb :index
  else
    '<a href="/login">Login</a>'
  end

end

get '/login' do
  session['oauth'] = Koala::Facebook::OAuth.new(ENV['APP_ID'], ENV['APP_SECRET'], "#{request.base_url}/callback")
  redirect session['oauth'].url_for_oauth_code()
end

get '/logout' do
  session['oauth'] = nil
  p session['access_token']
  session['access_token'] = nil
  redirect '/'
end

get '/callback' do
  session['access_token'] = session['oauth'].get_access_token(params[:code])
  redirect '/'
end

post '/actors' do
  @first_actor = params[:firstactor]
  @second_actor = params[:secondactor]
  @actors = Actor.all
  @actors.each do |element|
    unless @first_actor == element.name
      @actor_avg1 = movie_rating(@first_actor)
    end
    unless @second_actor == element.name
      @actor_avg2 = movie_rating(@second_actor)
    end
  end
  erb :index
  @winner =  win(@actor_avg1, @actor_avg2, @first_actor, @second_actor) + " is the winner"
end
