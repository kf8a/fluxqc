class LTERSetupParser
  def parse(row)
    treatment = "T#{row[0]}"
    replicate = "R#{row[1]}"
    sub_plot  = nil
    chamber   = row[3]
    vial      = row[4]
    lid       = row[5]
    height    = [row[6].to_f,row[7].to_f, row[8].to_f, row[9].to_f]
    soil_temp = row[10].to_f
    seconds   = row[15].to_f
    comments  = row[16]
    comments  = nil if comments == '-'
    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end
end
