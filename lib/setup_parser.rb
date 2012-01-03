require 'spreadsheet'
require 'csv'

class SetupParser

  # This should parse the file and return a hash of sample objects
  def parse_xls(file)
    book = Spreadsheet.open(file)
    sheet = book.worksheets.first
    # sheet should implement enumerable
    result = []
    sheet.each 5 do |row|
      next if row[0].nil?
     
      result << parse_sample(row)
    end
    result
  end

  def parse_csv(file)
    lines = CSV::readlines(file)
    5.times { lines.shift } # remove the header limes TODO this is different for GLBRC
    lines.collect do |row|
     parse_sample(row)
    end
  end

  def parse_sample(row)
    plot      = "T#{row[0]}R#{row[1]}"
    chamber   = row[3].to_s
    vial      = row[4].to_s
    lid       = row[5].to_s
    height    = [row[6].to_f,row[7].to_f, row[8].to_f, row[9].to_f]
    soil_temp = row[10].to_f

    seconds   = row[15]
    seconds   = seconds.value if seconds.class.name == 'Spreadsheet::Formula'
    seconds   = seconds.to_f

    comments  = row[16]
    comments  = nil if comments == '-'

    {:plot => plot, :chamber => chamber, :vial => vial,
      :lid => lid, :height => height,
      :soil_temperature => soil_temp, 
      :seconds => seconds, :comments => comments }
  end
end
