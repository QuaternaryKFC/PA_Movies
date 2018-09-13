require "./movie_data.rb"
require "./md_util.rb"

class Ratings
  def initialize filepath
    @md = MovieData.new filepath
  end

  def predict u_id, m_id
    #linear regression may lead to overflow prediction
    #para = regress ur, mv
    #return para[:alpha]+1*para[:beta]

    #use 4 to test if logitreg give better prediction
    #return 4
    ur = @md.urList[u_id]
    mv = @md.mvList[m_id]
    #if the movie is not reviewed in base, give a migic 4
    if mv==nil
      return 4
    end
    #if only one user reviewed the movie
    #predict based on the similarity rather than regression
    if mv.urList.length==1
      uid = mv.urList.keys()[0]
      u = @md.urList[uid]
      sim = ur.similar u
      logitr = sim/(1-sim)
    else
      #logistic regression using similarity as x and rating as y
      #the similarity to the user self is 1
      para = logitreg ur,mv
      logitr = para[:alpha]+1*para[:beta]
    end
    res = 4.002/(1+1/Math.exp(logitr))+0.999
    if res>5
      res=5.0
    end
    if res<1
      res=1.0
    end
    return res
  end

  def regress ur, mv
    #hash have guaranteed iteration order (insertion order)
    vsim = mv.urList.map{|uid, r| ur.similar(@md.urList[uid])}
    vrate = mv.urList.map{|uid, r| r}
    avesim = vsim.sum/vsim.length
    averate = vrate.sum/vrate.length
    #WARN! cov and vx would be 0 if there is only one review
    #WARN! 0 cov (all users give same rating) lead to invariable rating prediction
    cov = vsim.map{|s| s-avesim}*vrate.map{|r| r-averate}
    vx = vsim.map{|s| s-avesim}*vsim.map{|s| s-avesim}
    beta = cov/vx
    alpha = averate-avesim*beta
    return {:beta=>beta, :alpha=>alpha}
  end

  def logitreg ur, mv
    #hash have guaranteed iteration order (insertion order)
    vsim = mv.urList.map{|uid, r| ur.similar(@md.urList[uid])}
    vrate = mv.urList.map{|uid, r| r}
    #make rate between 0.001 to 4.001, and use 4.002 to avoid 0 denominator
    vrate = vrate.map{|r| Math.log((r-0.999)/(4.002-(r-0.999)))}
    avesim = vsim.sum/vsim.length
    averate = vrate.sum/vrate.length
    #WARN! cov and vx would be 0 if there is only one review
    #WARN! 0 cov (all users give same rating) lead to invariable rating prediction
    cov = vsim.map{|s| s-avesim}*vrate.map{|r| r-averate}
    vx = vsim.map{|s| s-avesim}*vsim.map{|s| s-avesim}
    beta = cov/vx
    alpha = averate-avesim*beta
    return {:beta=>beta, :alpha=>alpha}
  end
  private :regress, :logitreg
end
