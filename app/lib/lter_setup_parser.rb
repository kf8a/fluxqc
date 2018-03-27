class LTERSetupParser
  attr_reader :row

  def parse(row)
    @row = row

    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end

  def treatment
    if row[0].to_i.to_s == row[0]
      "T#{row[0].to_i}"
    else
      row[0]
    end
  end

  def replicate
    if row[1].is_a?(Float)
      "R#{row[1].to_i}"
    else
      "R#{row[1]}"
    end
  end

  def sub_plot; end

  def chamber
    row[3].to_i.to_s
  end

  def vial
    row[4].to_i.to_s
  end

  def lid
    row[5]
  end

  def height
    [row[6].to_f, row[7].to_f, row[8].to_f, row[9].to_f]
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
