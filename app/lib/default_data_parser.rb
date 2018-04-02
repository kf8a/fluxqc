# frozen_string_literal: true

# parse old style data files
class DefaultDataParser
  def parse(lines)
    lines = DataFileDecapitator.shift_header_lines(lines)
    vials = {}
    lines.each do |row|
      vials[row[0]] = processed_parse(row)
    end
    vials.values
  end

  def processed_parse(row)
    { vial: row[0],
      n2o: { ppm: row[1].to_f },
      co2: { ppm: row[2].to_f },
      ch4: { ppm: row[3].to_f } }
  end
end
