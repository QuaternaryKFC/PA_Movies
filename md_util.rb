#for easily parse each row of data
def strsto_i(strs)
  ints = []
  strs.each {|s| ints<<s.to_i}
  return ints
end
