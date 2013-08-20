class FertSetupParser
  def parse(row)
    treatment = "T#{row[0]}"
    replicate = "R#{treatment[3]}"
    treatment = treatment[0..2]
    sub_plot  = "R#{row[1]}"
    chamber   = row[3]
    vial      = row[3]
    lid       = row[4]
    height    = [row[5].to_f,row[6].to_f, row[7].to_f, row[8].to_f]
    soil_temp = row[9].to_f
    seconds   = row[14].to_f
    comments  = row[15]
    comments  = nil if comments == '-'
    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end
end
