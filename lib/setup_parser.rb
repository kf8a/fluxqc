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
    5.times { lines.shift }
    result = []
    lines.each do |row|
     next if row[0].nil?

     result << parse_sample(row)
    end
    result
  end

  def parse_sample(row)
    seconds = row[15]
    if seconds.class.name == 'Spreadsheet::Formula'
      seconds = seconds.value
    end

    comments = row[16]
    comments = nil if comments == '-'

    {:treatment => row[0].to_s,
      :replicate => row[1].to_s,
      :chamber => row[3].to_s,
      :vial => row[4].to_s, 
      :lid => row[5], 
      :height => [row[6].to_f,row[7].to_f, row[8].to_f, row[9].to_f],
      :soil_temperature => row[10].to_f,
      :seconds => seconds.to_f,
      :comments => comments }
  end
end
