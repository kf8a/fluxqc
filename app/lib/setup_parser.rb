require 'chronic'
require 'csv'
require 'roo'
require 'roo-xls'
require_relative 'glbrc_setup_parser'
require_relative 'fert_setup_parser'
require_relative 'lter_setup_parser'
require_relative 'format4_parser'
require_relative 'format3_parser'
require_relative 'format6_parser'

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
      raise 'only comma delimited and xls(x) files are supported'
    end
  end

  # sample dates get pull from date_row which needs to be set for the different
  # format types
  def self.parse_xls(file)
    xls = Roo::Spreadsheet.open(file)
    xls.default_sheet = xls.sheets.first
    format_test = xls.cell('A', 1)
    date_row = 3
    title = format_test
    if format_test.match?(/format=/)
      title = xls.cell('A', 2)
      date_row = 5
    end
    date_row = 4 if file.match?(/CIMMYT/)

    sample_date = Chronic.parse(xls.cell('A', date_row).gsub(/sample date:(\s+)?/, ''))
    sample_date = Chronic.parse(xls.cell('C', date_row)) if sample_date.nil?

    first_row = 6
    first_row += 1 if title.strip =~ /^GLBRC/
    first_row += 1 if date_row == 5

    parser = locate_parser(format_test)

    (first_row..xls.last_row).collect do |i|
      row = xls.row(i)
      data = parser.parse(row)
      treatment = data.first
      next if empty_treatment?(treatment)
      next if treatment == 'T' # for LTER samples

      new_record(data, sample_date, title)
    end.compact
  end

  def self.empty_treatment?(treatment)
    treatment.respond_to?(:empty?) && treatment.empty?
  end

  def self.parse_csv(file)
    lines = CSV.readlines(file)
    first_row = lines.shift
    format_test = first_row[0]
    title = first_row[0]
    2.times { lines.shift } # remove the header limes
    next_row = lines.shift
    sample_date = Chronic.parse(next_row[0].gsub(/sample date:(\s+)?/, ''))
    lines.shift
    lines.shift if format_test =~ /^GLBRC/
    lines.shift if format_test =~ /^format=/

    parser = locate_parser(format_test)

    lines.collect do |row|
      next unless row[0]

      data = parser.parse(row)
      new_record(data, sample_date, title)
    end.compact
  end

  def self.new_record(data, sample_date, title)
    treatment, replicate, sub_plot, chamber, vial, lid, height,
      soil_temp, seconds, comments = data
    { run_name: title, sample_date: sample_date,
      treatment: treatment, replicate: replicate,
      sub_plot: sub_plot,
      chamber: chamber, vial: vial,
      lid: lid, height: height,
      soil_temperature: soil_temp,
      seconds: seconds, comments: comments }
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
      Format4Parser.new
    when /^format=3/
      Format3Parser.new
    when /^format=5/
      Format5Parser.new
    when /^format=6/
      Format6Parser.new
    else
      LTERSetupParser.new
    end
  end
end
