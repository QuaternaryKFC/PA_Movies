require "./md_models.rb"
require "./md_util.rb"

#you can also use a method_missing method to deal with this kind of exception
#main class for movie data processing
class MovieData
  def initialize(file)
    @datafile = File.open(file)
    #map ids to movies and users
    @mvList, @urList = Hash.new, Hash.new
    #keep same data in multiple forms may result in efficiency concern
    #learn to improve with set functions in the future
    @rows = []
    @datafile.each do |l|
      row = MovieRecord.new(l)
      #add review info to each movie or user
      mvListInit(row)
      urListInit(row)
      @rows<<row
    end
  end

  #use average rating as popularity
  def popularity(m_id)
    mv=@mvList[m_id]
    begin
      return mv.totalR/mv.rn
    rescue
      return nil
    end
  end

  #sort the list of movies by average rating
  def popularity_list
    begin
      #hash sort returns array!
      return @mvList.sort_by{|m_id, mv| mv.totalR/mv.rn}.to_h
    rescue
      return nil
    end
  end

  #calculate similarity based on the abs of rating difference of common rated movies
  def similarity(uid1, uid2)
    begin
      return @urList[uid1].similar(@urList[uid2])
    rescue
      return nil
    end
  end

  #maintain a sorted list for each user based on similarity with all other users
  def most_similar(uid)
    ur = @urList[uid]
    begin
      #use a cache
      if !ur.msim.empty?
        return ur.msim
      end
      #create the sorted similarity list for the user
      @urList.each do |u_id, u|
        if u_id!=uid
          ur.msim[u_id] = ur.similar(u)
        end
      end
      return ur.msim.sort_by{|uid, sim| sim}.to_h
    rescue
      return nil
    end
  end

  #add review info for every movie: sum of all rating, number of reviews
  def mvListInit(row)
    m_id = row.m_id
    if !@mvList.key?(m_id)
      mv = Movie.new(m_id)
      @mvList[m_id] = mv
    end
    mv=@mvList[m_id]
    mv.rn+=1
    mv.totalR+=row.rate
  end

  #add review info for every user: movies reviewed and corresponding rating
  def urListInit(row)
    u_id=row.u_id
    if !@urList.key?(u_id)
      ur = User.new(u_id)
      @urList[u_id] = ur
    end
    ur=@urList[u_id]
    ur.mrList[row.m_id] = row.rate
  end

  private :mvListInit, :urListInit

end
