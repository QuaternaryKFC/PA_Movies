require "./movie_data.rb"
require "./mp_predict.rb"

class Validator
  def initialize basep, testp
    @base = Ratings.new basep
    @test = MovieData.new testp
    @error = []
  end

  def validate
    if @error.empty?
      @error = @test.rows.map{|r|
        uid = r.u_id
        mid = r.m_id
        rate = r.rate
        @base.predict(uid, mid)-rate
      }
    end
    exact = @error.map{|e| true if e**2<1}.compact.length
    mean = @error.sum/@error.length
    stdev = Math.sqrt(@error.sum{|e| (e-mean)**2}/(@error.length-1))
    puts "total:"+@error.length.to_s
    puts "exact: "+exact.to_s
    puts "mean: "+mean.to_s
    puts "stdev: "+stdev.to_s
  end
end
