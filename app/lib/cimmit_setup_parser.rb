# frozen_string_literal: true

# CIMIT: Parsing the setup file
class CIMMITSetupParser
  attr_reader :row, :series

  def initialize(series)
    @series = series
  end

  def parse(row)
    @row = row

    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end

  def treatment
    "#{row[0]}#{row[3]}"
  end

  def replicate
    if row[1].is_a?(Float)
      "R#{row[1].to_i}"
    else
      "R#{row[1]}"
    end
  end

  def sub_plot; end

  def chamber
    case row[4]
    when nil then nil
    when empty then nil
    else
      row[4].strip
    end
  end

  def vial
    parts = /(\d{3})(.)/.match(row[0])
    "S#{series}-CIM-#{parts[2]}-#{parts[1]}-T#{row[2].to_i}"
    # "S#{series}-#{parts[2]}-#{parts[1]}-T#{row[2]}"
  end

  def lid
    row[5]
  end

  def height
    [row[6].to_f, row[7].to_f, row[8].to_f]
  end

  def soil_temp
    row[10].to_f
  end

  def seconds
    row[15].to_f
  end

  def comments
    comment  = row[16]
    comment == '-' ? nil : comment
  end
end
