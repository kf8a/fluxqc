require 'chronic'
require 'csv'
require_relative 'glbrc_setup_parser'
require_relative 'fert_setup_parser'
require_relative 'lter_setup_parser'

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
    sample_date = Chronic.parse(row[0].gsub /sample date:(\s+)?/,'')
    lines.shift
    lines.shift if title.strip =~ /^GLBRC/
    result = lines.collect do |row|
      break if row[0].empty?

      parser = case title.strip
               when /^GLBRC.*\d$/
                 GLBRCSetupParser.new
               when /Fert/
                 FertSetupParser.new
               when /^CIMMYT/
                 series = title.split(/ +/).last
                 CIMMITSetupParser.new(series)
               else
                 LTERSetupParser.new
               end

      treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments = parser.parse(row)

      {:run_name => title, :sample_date => sample_date,
        :treatment => treatment, :replicate => replicate,
        :sub_plot => sub_plot,
        :chamber => chamber, :vial => vial,
        :lid => lid, :height => height,
        :soil_temperature => soil_temp,
        :seconds => seconds, :comments => comments }
    end
  end

end
