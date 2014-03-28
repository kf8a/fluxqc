# encoding: utf-8
require 'csv'

#TODO what happens if a data file is uploaded before a setup is created
#
# The data parser parses the data files that come from the GC.
# It uses the vial number to match up the data with the previously created 
# incubations and samples from the setup file.
class DataParser

  def parse(file_name)
    lines = self.read_file(file_name)

    # see if we have a chemstation file
    filetype = filetype(lines)

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

  def parse_vial(row)
    vial = row[3] # the vial number is in columns 3 normally
    if vial =~ /([a-z|A-Z]-?\d{3}-T\d)$/
      if vial =~ /([a-z|A-Z]-\d{3}-T\d)$/
        vial = $1
      else
        vial =~ /([a-z|A-Z])(\d{3}-T\d)$/
        vial = "#{$1}-#{$2}"
      end
    elsif vial =~ /-/
      vial.split(/-/).last
    else
      vial
    end
  end

  def chemstation_parse(row)
    results = {}

    results[:vial] = parse_vial(row)
    results[:acquired_at] = Time.strptime(row[2], "%e-%b-%y, %H:%M:%S")

    columns = [4,8,12] # the location of the compound names
    columns = [5,9,13] unless row[4] # if column 4 is empty then they are shifted
    columns.each do |column|
      key = row[column].downcase.to_sym
      value = row[column + 2]
      results[key] = {column: row[1].to_i % 2, area: value.to_f}
    end
    results
  end

  def processed_parse(row)
    {vial: row[0], 
      n2o: {ppm: row[1].to_f},
      co2: {ppm: row[2].to_f}, 
      ch4: {ppm: row[3].to_f}}
  end

  def forth_parse(row)
    {vial: row[1], 
      n2o: {area: row[2].to_f, ppm: row[11].to_f},
      co2: {area: row[4].to_f, ppm: row[12].to_f}, 
      ch4: {area: row[6].to_f, ppm: row[13].to_f}}
  end

  def first_row_of_data(lines)
    result = 0
    lines.each do |row|
      if row[1] =~ /\d+/
        break
      end
      result += 1
    end
    result
  end

  def read_file(file_name)
    bom = File.read(file_name, 2).unpack("C*")
    if bom == [255,254]
      CSV::readlines(file_name,
                     :encoding => "UTF-16LE:UTF-8",
                     :col_sep=>"\t")
    else
      CSV::readlines(file_name)
    end
  end

  def filetype(lines)
    if lines[0][0] =~ /Analysis Date/
      :chemstation
    elsif lines[2][0] =~ /standard/
      :forth
    end
  end
end
