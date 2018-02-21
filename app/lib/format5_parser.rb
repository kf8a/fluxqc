class Format5Parser
  attr_reader :row

  def parse(row)
    @row = row

    p [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end

  def treatment
    "#{row[0][0..1]}-#{row[1]}"
  end

  def replicate
    "R#{row[0][-1]}"
  end

  def sub_plot
    "#{row[1]}"
  end

  def chamber
    "#{row[3].to_i}"
  end

  def vial
    "#{row[4].to_i}"
  end

  def lid
    row[5]
  end

  def height
    [row[6].to_f,row[7].to_f, row[8].to_f, row[9].to_f]
  end

  def soil_temp
    row[10].to_f
  end

  def seconds
    row[15].to_f
  end

  def comments
    comment  = row[16]
    comment == '-' ? nil : comment
  end

end
