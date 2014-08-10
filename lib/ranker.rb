#TODO: to be re-implemented in hardware
# http://www.wolframalpha.com/input/?i=4%5E%281-x%2F2%29*%281+-+y%2F120%29+with+x+from+0+to+2+and+y+from+0+to+60
class Ranker
  TIME_COEFFICIENT = 120
  CONSTANT_OF_AWESOMENESS = 4
  MAX_FULLNESS = 2

  def self.score(at_capacity, fullness, time)
    (1 - at_capacity)*CONSTANT_OF_AWESOMENESS**((1-fullness.to_d/MAX_FULLNESS)*(1-time.to_d/TIME_COEFFICIENT))
  end
end
