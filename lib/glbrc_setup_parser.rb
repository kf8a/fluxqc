class GLBRCSetupParser
  def parse(row)
    treatment = "#{row[0]}#{row[3]}"
    replicate = "R#{row[1]}"
    sub_plot  = nil
    chamber   = row[4]
    vial      = row[5]
    lid       = row[6]
    height    = [row[7].to_f,row[8].to_f, row[9].to_f, row[10].to_f]
    soil_temp = row[11].to_f
    seconds   = row[16].to_f
    comments  = row[17]
    comments  = nil if comments == '-'
    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end
end
