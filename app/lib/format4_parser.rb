class Format4Parser
  attr_reader :row

  def parse(row)
    @row = row

    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end

  def treatment
    if row[0].is_a?(Numeric)
      "T#{name.to_i}"
    else
      "#{row[0]}-#{row[2]}"
    end
  end

  def replicate
    if row[1].is_a?(Numeric)
      "R#{row[1].to_i}"
    else
      "R#{row[1]}"
    end
  end

  def sub_plot; end

  def chamber
    row[4].to_i.to_s
  end

  def vial
    row[5].to_i.to_s
  end

  def lid
    row[6]
  end

  def height
    [row[7].to_f, row[8].to_f, row[9].to_f, row[10].to_f]
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
