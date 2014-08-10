#TODO: to be re-implemented in hardware
class Ranker
  TIME_COEFFICIENT = 120
  CONSTANT_OF_AWESOMENESS = 4
  MAX_FULLNESS = 2

  def self.score(at_capacity, fullness, time)
    (1 - at_capacity)*CONSTANT_OF_AWESOMENESS**((1-fullness.to_d/MAX_FULLNESS)*(1-time.to_d/TIME_COEFFICIENT))
  end
end
