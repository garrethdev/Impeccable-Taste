helpers do
  def movie_rating(actor)
    search = Tmdb::Search.new
    search.resource('person')
    search.query(actor)
    result = search.fetch

    credits = Tmdb::People.credits(result.first['id'])
    movie_id = credits['cast'].map { |cast| cast['id'] }
    movie_rating = movie_id.take(15).map { |mov| Tmdb::Movie.detail(mov).vote_average }

    movie_rating.inject(:+)/movie_rating.length
  end
end
