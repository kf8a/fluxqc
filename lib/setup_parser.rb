require 'spreadsheet'
require 'chronic'
require 'csv'

class SetupParser

  # convenience method to call the parsers depending on file type
  def self.parse(file_path)
    if File.extname(file_path) == '.csv'
      parse_csv(file_path)
    elsif File.extname(file_path) == '.xls'
      parse_xls(file_path)
    end
  end

  # This should parse the file and return a hash of sample objects
  def self.parse_xls(file)
    book = Spreadsheet.open(file)
    sheet = book.worksheets.first
    title = sheet.row(0)[0]
    sample_date = Chronic.parse(sheet.row(3)[0].gsub /sample date: /,'')
    # sheet should implement enumerable
    result = []
    sheet.each 5 do |row|
      next if row[0].nil?
     
      result << parse_sample(row,sample_date,title)
    end
    result
  end

  def self.parse_csv(file)
    lines = CSV::readlines(file)
    row = lines.shift
    title = row[0]
    2.times { lines.shift } # remove the header limes TODO this is different for GLBRC
    row = lines.shift
    sample_date = Chronic.parse(row[0].gsub /sample date: /,'')
    lines.shift
    result = lines.collect do |row|
     parse_sample(row, sample_date,title)
    end
  end

  def self.parse_sample(row, sample_date=nil, title=nil)
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

    {:run_name => title, :sample_date => sample_date, 
      :treatment => treatment, :replicate => replicate,
      :chamber => chamber, :vial => vial,
      :lid => lid, :height => height,
      :soil_temperature => soil_temp, 
      :seconds => seconds, :comments => comments }
  end
end
