require 'chronic'
require 'csv'
require 'roo'
require_relative 'glbrc_setup_parser'
require_relative 'fert_setup_parser'
require_relative 'lter_setup_parser'
require_relative 'glbrc_format4_setup_parser'
require_relative 'format3_parser'

# The SetupParser parses the run setup file and returns the
# results as a hash. It is called by the setup parser loader
# when a setup file is uplaoded.
class SetupParser

  # convenience method to call the parsers depending on file type
  def self.parse(file_path)
    case File.extname(file_path)
    when '.csv'
      parse_csv(file_path)
    when '.xls'
      parse_xls(file_path)
    when '.xlsx'
      parse_xls(file_path)
    else 
      raise 'only comma delimited files are supported'
    end
  end

  def self.parse_xls(file)
    xls = Roo::Spreadsheet.open(file)
    xls.default_sheet = xls.sheets.first
    format_test = xls.cell('A',1)
    date_row = 3
    title = format_test
    if format_test =~ /format=/
      title = xls.cell('A',2)
      date_row = 4
    end

    sample_date = Chronic.parse(xls.cell('A',date_row).gsub /sample date:(\s+)?/,'')
    first_row = 6
    first_row += 1 if title.strip =~ /^GLBRC/
    first_row += 1 if date_row == 4

    parser = locate_parser(format_test)

    (first_row..xls.last_row).collect do |i|
      row = xls.row(i)
      treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments = parser.parse(row)

      {:run_name => title, :sample_date => sample_date,
        :treatment => treatment, :replicate => replicate,
        :sub_plot => sub_plot,
        :chamber => chamber, :vial => vial,
        :lid => lid, :height => height,
        :soil_temperature => soil_temp,
        :seconds => seconds, :comments => comments }
    end.compact
  end

  def self.parse_csv(file)
    lines = CSV::readlines(file)
    row = lines.shift
    format_test = row[0]
    title = row[0]
    2.times { lines.shift } # remove the header limes
    row = lines.shift
    sample_date = Chronic.parse(row[0].gsub /sample date:(\s+)?/,'')
    lines.shift
    lines.shift if format_test =~ /^GLBRC/
    lines.shift if format_test =~/^format=/

    parser = locate_parser(format_test)

    lines.collect do |row|
      next unless row[0]

      treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments = parser.parse(row)

      {:run_name => title, :sample_date => sample_date,
        :treatment => treatment, :replicate => replicate,
        :sub_plot => sub_plot,
        :chamber => chamber, :vial => vial,
        :lid => lid, :height => height,
        :soil_temperature => soil_temp,
        :seconds => seconds, :comments => comments }
    end.compact
  end

  def self.locate_parser(title)
    case title.strip
    when /^GLBRC.*\d$/
      GLBRCSetupParser.new
    when /Fert/
      FertSetupParser.new
    when /^CIMMYT/
      series = title.split(/ +/).last
      CIMMITSetupParser.new(series)
    when /^format=4/
      GLBRCFormat4SetupParser.new
    when /^format=3/
      Format3Parser.new
    else
      LTERSetupParser.new
    end
  end
end
