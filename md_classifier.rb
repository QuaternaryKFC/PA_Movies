require "./md_models.rb"

class Classifier
  def initialize fp
    @rows = Hash.new
    file = File.new fp
    file.each do |l|
      row = MovieGenreRecord.new(l.split(/\|+/))
      @rows[row.m_id]=row
    end
  end

  def classify mv
    mv.genre = @rows[mv.m_id].genre
  end
end
