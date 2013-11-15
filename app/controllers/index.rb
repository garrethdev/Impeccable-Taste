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
      User.create facebook_id: @json['id'], first_name: @json['first_name'], last_name: @json['last_name'], username: @json['username'], link: @json['link'], percentage_score: 0.0, total_answered: 0, total_correct: 0
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
  session['access_token'] = nil
  redirect '/'
end

get '/callback' do
  session['access_token'] = session['oauth'].get_access_token(params[:code])
  redirect '/'
end

post '/actors' do
  # Cache an actor if it does not exist in the database.
  cache_actor(params[:firstactor]); cache_actor(params[:secondactor])

  @first_actor = Actor.find_by_name(params[:firstactor])
  @second_actor = Actor.find_by_name(params[:secondactor])

  # Create fight if it doesn't exist in the database.
  cache_fight(@first_actor, @second_actor)

  erb :index
  # @winner =  win(@first_actor.avg_rating, @second_actor.avg_rating, params[:firstactor], params[:secondactor]) + " is the winner"
  @winner =  win(@first_actor, @second_actor) + " is the winner"

end
