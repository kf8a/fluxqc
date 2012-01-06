# encoding: utf-8
require 'csv'
class DataParser

  def self.parse(file_name)
    lines = CSV::readlines(file_name, :encoding => "UTF-16LE:UTF-8", :col_sep=>"\t")
    lines.shift # remove title row

    # We are using a hash here because when data gets reprocessed in Chemstation the reprocessed data gets
    # attached to the bottom of the results file. This results in multiple copies of the data in the file.
    # We want to use the last version of the data for the vial that is in the file
    vials = {}
    lines.each do |row|
      vials[row[1]] = {:vial=>row[3], :ch4=>row[7].to_f, :co2=>row[11].to_f, :n2o=>row[15].to_f}
    end
    vials.values
  end
end
