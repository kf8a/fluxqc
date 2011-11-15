require 'csv'
class DataParser

  attr_accessor :data

  def parse_line(data)
    parsed_data = CSV.parse_line(data, :col_sep=>" ")
    {:vial=>parsed_data[7].to_i, :ch4=>{:value=>parsed_data[10].to_f}, :co2=>{:value => parsed_data[14].to_f}, :n2o=>{:value => parsed_data[18].to_f}}
  end

  def parse
    true
  end
end
