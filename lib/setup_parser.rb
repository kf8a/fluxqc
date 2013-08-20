require 'chronic'
require 'csv'

# The SetupParser parses the run setup file and returns the
# results as a hash. It is called by the setup parser loader
# when a setup file is uplaoded.
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
    2.times { lines.shift } # remove the header limes
    row = lines.shift
    sample_date = Chronic.parse(row[0].gsub /sample date: /,'')
    lines.shift
    lines.shift if title.strip =~ /^GLBRC/
    result = lines.collect do |row|
      if title.strip =~ /^GLBRC.+\d$/
        treatment, replicate, chamber, vial, lid, height, soil_temp, seconds, comments = glbrc_row(row)
      elsif title.strip =~/Fert/
        treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comment = fert_row(row)
      else
        treatment, replicate, chamber, vial, lid, height, soil_temp, seconds, comments = lter_row(row)
      end

      {:run_name => title, :sample_date => sample_date,
        :treatment => treatment, :replicate => replicate,
        :sub_plot => sub_plot,
        :chamber => chamber, :vial => vial,
        :lid => lid, :height => height,
        :soil_temperature => soil_temp,
        :seconds => seconds, :comments => comments }
    end
  end

  def self.glbrc_row(row)
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
    [treatment, replicate, chamber, vial, lid, height, soil_temp, seconds, comments]
  end

  def self.fert_row(row)
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

  def self.lter_row(row)
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
    [treatment, replicate, chamber, vial, lid, height, soil_temp, seconds, comments]
  end
end
