class CIMMITSetupParser
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
    parts = /(\d{3})(.)/.match(row[0])
    "#{parts[2]}-#{parts[1]}-T#{row[2]}"
  end

  def lid
    row[5]
  end

  def height
    [row[6].to_f,row[7].to_f, row[8].to_f]
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