helpers do
  def movie_rating(actor)
    result = search_results(actor)
    credits = Tmdb::People.credits(result.first['id'])
    movie_id = credits['cast'].map { |cast| cast['id'] }
    movie_rating = movie_id.take(15).map { |mov| Tmdb::Movie.detail(mov).vote_average }
    avg_score = movie_rating.inject(:+)/movie_rating.length

    avg_score
  end

  def search_results(person)
    search = Tmdb::Search.new
    search.resource('person')
    search.query(person)
    search.fetch
  end

  def cache_actor(actor_name)
    if Actor.exists?(:name_lowercase => actor_name.downcase) == false
      Actor.create name: actor_name, 
                   name_lowercase: actor_name.downcase, 
                   avg_rating: movie_rating(actor_name)
    end
  end

  def fight_exist (         )

  def cache_fight(first_actor, second_actor)

    # if Fight.exists?(first_acotr, second_actor)
    #   return fight(first, second)
    # elsif Fight.exists?(second_actor, first_acotr)
    #   return fight(second, first)
    # else
    #   create_fight first, second 
    # end

    if Fight.exists?(:first_actor => first_actor.name_lowercase, :second_actor => second_actor.name_lowercase)
      Fight.where(:first_actor => first_actor.name_lowercase, :second_actor => second_actor.name_lowercase).first.increment!(:access_count)
    elsif Fight.exists?(:first_actor => second_actor.name_lowercase, :second_actor => first_actor.name_lowercase)
      Fight.where(:first_actor => second_actor.name_lowercase, :second_actor => first_actor.name_lowercase).first.increment!(:access_count)
    else
      Fight.create first_actor: first_actor.name_lowercase, second_actor: second_actor.name_lowercase, access_count: 1
    end
  end

  def win(first_actor, second_actor)
    return first_actor.name if first_actor.avg_rating > second_actor.avg_rating
    return second_actor.name if second_actor.avg_rating > first_actor.avg_rating
  end

  def get_user_info
    http          = Net::HTTP.new "graph.facebook.com", 443
    request       = Net::HTTP::Get.new "/me?access_token=#{session['access_token']}"
    http.use_ssl  = true
    response      = http.request request
    json          = JSON.parse(response.body)

    cache_facebook_user(json)
  end

  def cache_facebook_user(json)
    if User.exists?(:facebook_id => json['id']) == false
      User.create facebook_id: json['id'], first_name: json['first_name'], last_name: json['last_name'], username: json['username'], link: json['link'], percentage_score: 0.0, total_answered: 0, total_correct: 0
    end
  end
end
