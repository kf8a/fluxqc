class FertSetupParser
  attr_reader :row

  def parse(row)
    @row = row
    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end
  
  def treatment_and_rep
    "T#{row[0]}"
  end
  
  def replicate
    "R#{treatment_and_rep[3]}"
  end

  def treatment
    treatment_and_rep[0..2]
  end

  def sub_plot
    "F#{row[1]}"
  end

  def chamber; end

  def vial
    row[3]
  end

  def lid
    row[4]
  end

  def height
    [row[5].to_f,row[6].to_f, row[7].to_f, row[8].to_f]
  end

  def soil_temp
    row[9].to_f
  end

  def seconds
    row[14].to_f
  end

  def comments
    comment  = row[15]
    comment == '-' ? nil : comment
  end
end
