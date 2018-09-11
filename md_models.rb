#data row
class MovieRecord
  attr_reader :u_id, :m_id, :rate, :time
  def initialize(record)
    @u_id, @m_id, @rate, @time = strsto_i(record.split)
  end
end

#user
class User
  attr_reader :u_id
  attr_accessor :mrList, :msim

  def initialize(u_id)
    #user id; map of movie reviewed and rating; similarity list (map user to similarity)
    @u_id = u_id
    @mrList = Hash.new
    @msim = Hash.new
  end

  #similarity=1-(sum|rating-ur.rating|/num of commonly reviewed movie)/5
  def similar(ur)
    if @u_id!=ur.u_id
      total=0
      ct=0
      @mrList.each do |m_id, rate|
        if(ur.mrList.key?(m_id))
          total+=(ur.mrList[m_id]-rate).abs/5.0
          ct+=1
        end
      end
      return 1-total/ct
    end
    return 0
  end

end

class Movie
  attr_reader :m_id
  attr_accessor :rn, :totalR
  def initialize(m_id)
    #movie id; number of reviews; sum of ratings
    @m_id = m_id
    @rn=0
    @totalR=0
  end
end
