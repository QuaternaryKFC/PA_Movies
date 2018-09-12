require "./mp_predict.rb"
require "./mp_validate.rb"

# uid, mid = ARGV
# uid=uid.to_i
# mid=mid.to_i
# mp = Ratings.new("./ml-100k/u.data")
# puts (mp.predict uid, mid)

vali = Validator.new("./ml-100k/u3.base", "./ml-100k/u3.test")
vali.validate
