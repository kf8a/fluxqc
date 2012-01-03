require 'spreadsheet'
require 'chronic'
require 'csv'

class SetupParser

  # This should parse the file and return a hash of sample objects
  def parse_xls(file)
    book = Spreadsheet.open(file)
    sheet = book.worksheets.first
    sample_date = Chronic.parse(sheet.row(3)[0].gsub /sample date: /,'').to_date.to_s
    # sheet should implement enumerable
    result = []
    sheet.each 5 do |row|
      next if row[0].nil?
     
      result << parse_sample(row,sample_date)
    end
    result
  end

  def parse_csv(file)
    lines = CSV::readlines(file)
    3.times { lines.shift } # remove the header limes TODO this is different for GLBRC
    row = lines.shift
    sample_date = Chronic.parse(row[0].gsub /sample date: /,'').to_date.to_s
    lines.shift
    result = lines.collect do |row|
     parse_sample(row, sample_date)
    end
  end

  def parse_sample(row, sample_date)
    treatment = "T#{row[0]}"
    replicate = "R#{row[1]}"
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

    {:sample_date => sample_date, 
      :treatment => treatment, :replicate => replicate,
      :chamber => chamber, :vial => vial,
      :lid => lid, :height => height,
      :soil_temperature => soil_temp, 
      :seconds => seconds, :comments => comments }
  end
end
