require "matrix"
require "./movie_data.rb"

class NNRunner
  def initialize base
    md = MovieData.new base
    u_id=1
    @input = md.urList[u_id].mrList.map{|mid, r| md.mvList[mid].genre}
    @real = md.urList[u_id].mrList.map{|mid, r|
      arr = Array.new(5, 0)
      arr[r-1] = 1
      arr
    }
    @nn = NeuralNet.new 10, 10000, @input, @real
  end

  def run
    @nn.train
  end

  def valid testf
    md = MovieData.new testf
    error = md.rows.map do |r|
      mv = md.mvList[r.m_id]
      res = @nn.cal(mv.genre).inject{|max, n| max||=n if max==nil||n>max}
      r.rate-res
    end
    exact = error.map{|e| true if e**2<1}.compact.length
    mean = error.sum/error.length
    stdev = Math.sqrt(error.sum{|e| (e-mean)**2}/(error.length-1))
    puts "total:"+error.length.to_s
    puts "exact: "+exact.to_s
    puts "mean: "+mean.to_s
    puts "stdev: "+stdev.to_s
  end
end


class NeuralNet
  #layer 0 is output, 1 is hidden, 2 is input
  #weights 0 is from hidden to output, 1 is from imput to hidden
  def initialize nhid, lr, input, real
    @input = Matrix.rows input
    @real = Matrix.rows real
    @nin = @input.column_count
    @nhid = nhid
    @nout = @real.column_count
    @learnrate = lr
    @wm = Array.new 2
    @wm[0] = Matrix.build(@nout, @nhid) {rand}
    @wm[1] = Matrix.build(@nhid, @nin) {rand}
  end

  #train the NN using input and real value given when initialize
  def train
    (0...@input.row_count).each do |i|
      @realout = @real.row(i)
      @out = Array.new 3
      @out[0] = Vector.zero @nout
      @out[1] = Vector.zero @nhid
      @out[2] = @input.row(i)
      forward
      backward
    end
    # @wm[0].each_with_index{|e, i, j|
    #   print e.to_s+" "
    #   puts "" if j==9
    # }
    # @wm[1].each_with_index{|e, i, j|
    #   print e.to_s+" "
    #   puts "" if j==18
    # }
    # puts ""
  end

  #calculate a output according to a trained NN
  def cal input_n
    @out[2] = Vector.elements input_n
    @out[1] = output 1
    @out[0] = output 0
    return @out[0].dup
  end

  #forward calculate output
  def forward
    @out[1] = output 1
    @out[0] = output 0
    # puts (@out[0]-@realout).inject{|sum, n| sum+=n**2}
  end

  #backward adjust weights
  def backward
    @wm[0].each_with_index{|e, j, k|
      puts gradient(0,j,k)
      e+=gradient(0,j,k)}
    @wm[1].each_with_index{|e, j, k|
      puts gradient(1,j,k)
      e+=gradient(1,j,k)}
  end

  #layer i, for jth output, and kth output from downstream
  def delta i, j
    out = @out[i][j]
    if i==0
      res = (out-@realout[j])*out*(1-out)
    else
      res = (0...@wm[i-1].column(j).size).map{|k| @wm[i-1][k,j]*delta(i-1,k)}.sum*out*(1-out)
    end
    return res
  end

  #calculate the output of layer i
  def output i
    res = @wm[i]*@out[i+1]
    res = res.map{|o| 1/(1+Math.exp(-o))}
    return res
  end

  #calculate the gradient of wm[i], from kth in layer i+1 to jth in layer i
  def gradient i, j, k
    return -(@learnrate*delta(i,j)*@out[i+1][k])
  end
end
