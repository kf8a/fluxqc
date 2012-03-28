# encoding: utf-8
require 'csv'
class DataParser

  def self.parse(file_name)
    lines = CSV::readlines(file_name) # , :encoding => "UTF-16LE:UTF-8", :col_sep=>"\t")
    #look for first row that starts with a number

    first_row_of_data = 0
    lines.each do |row|
      if row[1] =~ /\d+/
        break
      end
      first_row_of_data = first_row_of_data + 1
    end
    first_row_of_data.times do
      lines.shift
    end


    # We are using a hash here because when data gets reprocessed in Chemstation the reprocessed data gets
    # attached to the bottom of the results file. This results in multiple copies of the data in the file.
    # We want to use the last version of the data for the vial that is in the file
    vials = {}
    lines.each do |row|
      p row
    #  vials[row[1]] = {:vial=>row[3], :ch4=>row[7].to_f, :co2=>row[11].to_f, :n2o=>row[15].to_f}
      vials[row[0]] = {:vial=>row[0], :n2o=>row[1].to_f, :co2=>row[2].to_f, :ch4=>row[3].to_f}
    end
    vials.values
  end
end
