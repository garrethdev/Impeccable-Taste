require_relative '../helpers/movie_rating_api'
require "net/http"
require "net/https"
require "cgi"
require "json"


get '/' do
  if session['access_token']
    get_user_info
    erb :index
  else
    erb :login
  end

end

get '/login' do
  session['oauth'] = Koala::Facebook::OAuth.new(ENV['APP_ID'], ENV['APP_SECRET'], "#{request.base_url}/callback")
  redirect session['oauth'].url_for_oauth_code()
end

get '/logout' do
  session['oauth'] = nil
  session['access_token'] = nilrequire_relative '../helpers/movie_rating_api'
require "net/http"
require "net/https"
require "cgi"
require "json"


get '/' do
  if session['access_token']
    get_user_info
    erb :index
  else
    erb :login
  end

end

get '/login' do
  session['oauth'] = Koala::Facebook::OAuth.new(ENV['APP_ID'], ENV['APP_SECRET'], "#{request.base_url}/callback")
  redirect session['oauth'].url_for_oauth_code()
end

get '/logout' do
  session['oauth'] = nil
  session['access_token'] = nil
  redirect '/'
end

get '/callback' do
  session['access_token'] = session['oauth'].get_access_token(params[:code])
  redirect '/'
end

post '/actors' do

  # Cache an actor if it does not exist in the database.
  cache_actor(params[:firstactor])
  cache_actor(params[:secondactor])

  @first_actor = Actor.find_by_name_lowercase(params[:firstactor].downcase)
  @second_actor = Actor.find_by_name_lowercase(params[:secondactor].downcase)

  # Create fight if it doesn't exist in the database.
  cache_fight(@first_actor, @second_actor)

  erb :index
  @winner =  win(@first_actor, @second_actor) + " is the winner"
  @winner
end

  redirect '/'
end

get '/callback' do
  session['access_token'] = session['oauth'].get_access_token(params[:code])
  redirect '/'
end

post '/actors' do

  # Cache an actor if it does not exist in the database.
  cache_actor(params[:firstactor])
  cache_actor(params[:secondactor])

  @first_actor = Actor.find_by_name_lowercase(params[:firstactor].downcase)
  @second_actor = Actor.find_by_name_lowercase(params[:secondactor].downcase)

  # Create fight if it doesn't exist in the database.
  cache_fight(@first_actor, @second_actor)

  erb :index
  @winner =  win(@first_actor, @second_actor) + " is the winner"
  @winner
end
