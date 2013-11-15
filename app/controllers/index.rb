require_relative '../helpers/movie_rating_api'
require "net/http"
require "net/https"
require "cgi"
require "json"
# require_relative 'movie_rating_api'
get '/' do

  if session['access_token']
    # The following lines get basic user info including ID.
    http = Net::HTTP.new "graph.facebook.com", 443
    request = Net::HTTP::Get.new "/me?access_token=#{session['access_token']}"
    http.use_ssl = true
    response = http.request request
    @json = JSON.parse(response.body)

    # If the facebook user id doesn't exist in the database, then add that user
    if User.exists?(:facebook_id => @json['id']) == false
      User.create facebook_id: @json['id'], first_name: @json['first_name'], last_name: @json['last_name'], username: @json['username'], link: @json['link'], oauth_token: session['access_token'], oauth_secret: "some secret" 
    end

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
  @first_actor_name = params[:firstactor]
  @second_actor_name = params[:secondactor]
  @actors = Actor.all

  # Cache an actor if it does not exist in the database.
  cache_actor(@first_actor_name); cache_actor(@second_actor_name)

  @first_actor = Actor.find_by_name(@first_actor_name)
  @second_actor = Actor.find_by_name(@second_actor_name)

  @actor_avg1 = @first_actor.avg_rating
  @actor_avg2 = @second_actor.avg_rating

  erb :index
  @winner =  win(@actor_avg1, @actor_avg2, @first_actor_name, @second_actor_name) + " is the winner"
end
