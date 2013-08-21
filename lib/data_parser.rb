# encoding: utf-8
require 'csv'

#TODO what happens if a data file is uploaded before a setup is created
#
# The data parser parses the data files that come from the GC.
# It uses the vial number to match up the data with the previously created 
# incubations and samples from the setup file.
class DataParser

  def self.parse(file_name)
    lines = self.read_file(file_name)

    # see if we have a chemstation file
    filetype = if lines[0][0] =~ /Analysis Date/
      :chemstation
    elsif lines[0][0] =~ /standard/
      :forth
    end

    #look for first row that starts with a number
    unless filetype == :forth
      first_row_of_data(lines).times do
        lines.shift
      end
    end


    # We are using a hash here because when data gets reprocessed
    # in Chemstation the reprocessed data gets
    # attached to the bottom of the results file.
    # This results in multiple copies of the data in the file.
    # We want to use the last version of the data for the vial that is
    # in the file
    vials = {}
    case filetype
    when :chemstation
      lines.each do |row|
        vials[row[1]] = chemstation_parse(row)
      end
    when :forth
      lines.each do |row|
        vials[row[1]] = forth_parse(row)
      end
    else
      lines.each do |row|
        vials[row[0]] = processed_parse(row)
      end
    end
    vials.values
  end

  def self.chemstation_parse(row)
    {:vial=>row[3], :ch4=>{:area => row[7].to_f},
      :co2=>{:area => row[11].to_f}, :n2o=>{:area => row[15].to_f}}
  end

  def self.processed_parse(row)
    {:vial=>row[0], :n2o=>{:ppm => row[1].to_f},
      :co2=>{:ppm => row[2].to_f}, :ch4=>{:ppm => row[3].to_f}}
  end

  def self.forth_parse(row)
    {vial: row[1], 
      n2o: {area: row[2].to_f, ppm: row[11].to_f},
      co2: {area: row[4].to_f, ppm: row[12].to_f}, 
      ch4: {area: row[6].to_f, ppm: row[13].to_f}}
  end

  def self.first_row_of_data(lines)
    result = 0
    lines.each do |row|
      if row[1] =~ /\d+/
        break
      end
      result += 1
    end
    result
  end

  def self.read_file(file_name)
    if file_name =~ /csv$/
      CSV::readlines(file_name)
    else
      CSV::readlines(file_name,
                     :encoding => "UTF-16LE:UTF-8",
                     :col_sep=>"\t")
    end
  end
end
