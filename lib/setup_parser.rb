require 'spreadsheet'

class SetupParser

  # This should parse the file and create the appropriate models
  def parse_xls(file)
    book = Spreadsheet.open(file)
    sheet = book.worksheets.first
    # sheet should implement enumerable
    result = []
    sheet.each 5 do |row|
      next if row[0].nil?
     
      seconds = row[15]
      if seconds.class.name == 'Spreadsheet::Formula'
        seconds = seconds.value
      end
        
      sample = {:treatment => row[0], 
                :replicate => row[1], 
                :chamber => row[3],
                :vial => row[4], 
                :lid => row[5], 
                :height => (row[6] + row[7] + row[8] + row[9])/4,
                :soil_temperature => row[10],
                :seconds => seconds
               }
      result << sample
    end
    result
  end
end
