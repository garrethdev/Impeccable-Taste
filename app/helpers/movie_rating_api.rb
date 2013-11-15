helpers do
  def movie_rating(actor)
    search = Tmdb::Search.new
    search.resource('person')
    search.query(actor)
    result = search.fetch

    credits = Tmdb::People.credits(result.first['id'])
    movie_id = credits['cast'].map { |cast| cast['id'] }
    movie_rating = movie_id.take(15).map { |mov| Tmdb::Movie.detail(mov).vote_average }
    avg_score = movie_rating.inject(:+)/movie_rating.length
    return avg_score
  end

  def win(actor_avg2, actor_avg1, first_actor, second_actor)
    if actor_avg2 > actor_avg1
      return first_actor
    else
      return second_actor
    end
  end

end
