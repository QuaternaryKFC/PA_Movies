require "./mp_validate.rb"
# require "./mp_neuralnet.rb"

(1..5).each do |i|
  vali = Validator.new("./ml-100k/u#{i}.base", "./ml-100k/u#{i}.test")
  vali.validate
end

# Neral Network doesn't work
# nnrun = NNRunner.new "./ml-100k/u.nnb"
# nnrun.run
# nnrun.valid "./ml-100k/u.nnt"
