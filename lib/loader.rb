require 'csv'

class Loader
  def parse(line)
    data = CSV.parse(line, :col_sep=>"\t")

    data.collect do |line|
      {:name => line[3], :ch4=>line[5].to_f, :co2=>line[9].to_f, :n2o=>line[13].to_f} 
    end
  end
end
