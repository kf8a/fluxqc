# frozen_string_literal: true

# parser for style 6 setup files
# they have an extra column with the strip data
class Format6Parser
  attr_reader :row

  def parse(row)
    @row = row

    [treatment, replicate, sub_plot, chamber, vial, lid, height, soil_temp, seconds, comments]
  end

  def treatment
    normalize_name(row[0])
  end

  def normalize_name(name)
    return name unless name.is_a?(Numeric)
    "T#{name.to_i}"
  end

  def replicate
    if row[1].is_a?(Numeric)
      "R#{row[1].to_i}"
    else
      "R#{row[1]}"
    end
  end

  def sub_plot
    case
    when row[2] then
      row[2]
    else
      row[3]
    end
  end

  def chamber
    row[5].to_i.to_s
  end

  def vial
    row[6].to_i.to_s
  end

  def lid
    row[7]
  end

  def height
    [row[8].to_f, row[9].to_f, row[10].to_f, row[11].to_f]
  end

  def soil_temp
    row[12].to_f
  end

  def seconds
    row[17].to_f
  end

  def comments
    comment  = row[18]
    comment == '-' ? nil : comment
  end
end
