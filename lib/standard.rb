class Standard

  attr_accessor :samples

  def initialize(sample_array=[])
    super()
    samples = sample_array
  end


  # Recomputes the standard curve
  def standardize

  end

  # Takes an area and returns the ppm based on the current standard curve
  def ppm(area)

  end
end
