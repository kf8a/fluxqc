require 'chronic'
require 'csv'

class SetupParser

  # convenience method to call the parsers depending on file type
  def self.parse(file_path)
    if File.extname(file_path) == '.csv'
      parse_csv(file_path)
    else
      raise 'only comma delimited files are supported'
    end
  end

  def self.parse_csv(file)
    lines = CSV::readlines(file)
    row = lines.shift
    title = row[0]
    2.times { lines.shift } # remove the header limes TODO this is different for GLBRC
    row = lines.shift
    sample_date = Chronic.parse(row[0].gsub /sample date: /,'')
    lines.shift
    lines.shift if title =~ /GLBRC/
    result = lines.collect do |row|
      if title =~ /GLBRC/
        treatment = "#{row[0]}#{row[3]}"
        replicate = "R#{row[1]}"
        chamber   = row[4]
        vial      = row[5]
        lid       = row[6]
        height    = [row[7].to_f,row[8].to_f, row[9].to_f, row[10].to_f]
        soil_temp = row[11].to_f
        seconds   = row[16].to_f
        comments  = row[17]
        comments  = nil if comments == '-'
      else
        treatment = "T#{row[0]}"
        replicate = "R#{row[1]}"
        chamber   = row[3]
        vial      = row[4]
        lid       = row[5]
        height    = [row[6].to_f,row[7].to_f, row[8].to_f, row[9].to_f]
        soil_temp = row[10].to_f
        seconds   = row[15].to_f
        comments  = row[16]
        comments  = nil if comments == '-'
      end

      {:run_name => title, :sample_date => sample_date, 
        :treatment => treatment, :replicate => replicate,
        :chamber => chamber, :vial => vial,
        :lid => lid, :height => height,
        :soil_temperature => soil_temp, 
        :seconds => seconds, :comments => comments }
    end
  end

end
