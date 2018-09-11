require "./mp_predict.rb"

uid, mid = ARGV
uid=uid.to_i
mid=mid.to_i
mp = Ratings.new("./ml-100k/u.data")
puts (mp.predict uid, mid)
