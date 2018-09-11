require "./movie_data.rb"

md = MovieData.new("./ml-100k/u.data")
pop = md.popularity_list
mn = pop.length
puts "least pop\n"
puts pop.keys[0..9]
print "\n"
puts "most pop\n"
puts pop.keys[mn-10...mn]
print "\n"

sim = md.most_similar 1
un = sim.length
puts "least sim to 1\n"
puts sim.keys[0..9]
print "\n"
puts "most sim to 1\n"
puts sim.keys[un-10...un]
print "\n"
