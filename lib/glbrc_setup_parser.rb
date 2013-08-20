class GLBRCSetupParser
  attr_reader :row

  def parse(row)
    @row = row

    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end

  def treatment
    "#{row[0]}#{row[3]}"
  end

  def replicate 
    "R#{row[1]}"
  end

  def sub_plot; end

  def chamber
    row[4]
  end

  def vial
    row[5]
  end

  def lid
    row[6]
  end

  def height
    [row[7].to_f,row[8].to_f, row[9].to_f, row[10].to_f]
  end

  def soil_temp
    row[11].to_f
  end

  def seconds
    row[16].to_f
  end

  def comments
    comment  = row[17]
    comment == '-' ? nil : comment
  end

end
