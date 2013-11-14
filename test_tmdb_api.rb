require 'themoviedb'
require 'json'

require 'yaml'

secrets = YAML.load_file('secret.yaml')

Tmdb::Api.key(secrets["API_KEY"])

# Example:

search = Tmdb::Search.new
search.resource('person')
search.query('samuel jackson')
result = search.fetch

credits = Tmdb::People.credits(result.first['id'])

movie_id = credits['cast'].map { |cast| cast['id'] }

movie_rating = movie_id.take(15).map { |mov| Tmdb::Movie.detail(mov).vote_average }

movie_rating.inject(:+)/movie_rating.length

# Gem link (more documentation): https://github.com/ahmetabdi/themoviedb
