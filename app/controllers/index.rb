require_relative '../helpers/movie_rating_api'
# require_relative 'movie_rating_api'
get '/' do
  @actors = Actor.all
  erb :index
end

post '/actors' do
  @first_actor = params[:firstactor]
  @second_actor = params[:secondactor]
  @actors = Actor.all

  @actors.each do |element|
    unless @first_actor == element.name
      p movie_rating(@first_actor)
    end
    unless @second_actor == element.name
      p movie_rating(@second_actor)
    end
  end
end
