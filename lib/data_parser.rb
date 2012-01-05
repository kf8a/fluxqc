# encoding: utf-8
require 'csv'
class DataParser

  def self.parse(file_name)
    lines = CSV::readlines(file_name, :encoding => "UTF-16LE:UTF-8", :col_sep=>"\t")
    lines.shift # remove title row
    lines.collect do |row|
      {:vial=>row[3], :ch4=>row[7].to_f, :co2=>row[11].to_f, :n2o=>row[15].to_f}
    end
  end
end
