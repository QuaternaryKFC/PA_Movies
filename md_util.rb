#for easily parse each row of data
def strsto_i(strs)
  ints = []
  strs.each {|s| ints<<s.to_i}
  return ints
end

#overload * for array to do vector inner multiply
class Array
  def *(arr)
    res=0
    (0..self.length).each{|i| res+=self[i].to_i*arr[i].to_i}
    return res
  end
end
