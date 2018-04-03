# frozen_string_literal: true

require 'csv'
require_relative 'forth_data_parser'
require_relative 'chemstation_data_parser'
require_relative 'cimmit_vial'

# TODO: what happens if a data file is uploaded before a setup is created
#
# The data parser parses the data files that come from the GC.
# It uses the vial number to match up the data with the previously created
# incubations and samples from the setup file.
class DataParser
  def parse(file_name)
    lines = read_file(file_name)

    # We are using a hash here because when data gets reprocessed
    # in Chemstation the reprocessed data gets
    # attached to the bottom of the results file.
    # This results in multiple copies of the data in the file.
    # We want to use the last version of the data for the vial that is
    # in the file
    case filetype(lines)
    when :chemstation
      ChemstationDataParser.new.parse(lines)
    when :double_loop_chemstation
      DoubleLoopChemstationDataParser.new.parse(lines)
    when :forth
      ForthDataParser.new.parse(lines)
    else
      DefaultDataParser.new.parse(lines)
    end
  end

  private

  def read_file(file_name)
    bom = File.read(file_name, 2).unpack('C*')
    if bom == [255, 254]
      CSV.readlines(file_name,
                    encoding: 'UTF-16LE:UTF-8',
                    col_sep: "\t")
    else
      CSV.readlines(file_name)
    end
  end

  def filetype(lines)
    if lines[0][0].nil?
      :old
    elsif lines[0][0].match?(/Analysis Date/)
      if double_loop?(lines)
        :double_loop_chemstation
      else
        :chemstation
      end
    elsif lines[2][0].match?(/standard/)
      :forth
    else
      :old
    end
  end

  def double_loop?(lines)
    lines.each do |row|
      vial = ChemstationUtils.find_vial(row)
      p vial
      return true if vial =~ /^B-/ || vial =~ /B\d+/
    end
    false
  end
end
