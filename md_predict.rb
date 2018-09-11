require "./movie_data.rb"
require "./md_util.rb"

class Ratings
  def initialize filepath
    @md = MovieData.new filepath
  end

  def predict u_id, m_id
    para = regress u_id, m_id
    #linear regression may lead to overflow prediction
    return para[:alpha]+1*para[:beta]
  end

  def regress u_id, m_id
    ur = @md.urList[u_id]
    mv = @md.mvList[m_id]
    #hash have guaranteed iteration order (insertion order)
    vsim = mv.urList.map{|uid, r| ur.similar(@md.urList[uid])}
    vrate = mv.urList.map{|uid, r| r}
    avesim = vsim.sum/vsim.length
    averate = vrate.sum/vrate.length
    #WARN! cov and vx would be 0 if there is only one review
    cov = vsim.map{|s| s-avesim}*vrate.map{|r| r-averate}
    vx = vrate.map{|r| r-averate}*vrate.map{|r| r-averate}
    beta = cov/vx
    alpha = averate-avesim*beta
    return {:beta=>beta, :alpha=>alpha}
  end

  private :regress
end
