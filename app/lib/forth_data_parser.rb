# frozen_string_literal: true

# parse forth data files
# these were deprecated in 2003
class ForthDataParser
  def parse(lines)
    vials = {}
    lines.each do |row|
      next unless row[0] == 'sample'
      vials[row[1]] = forth_parse(row)
    end
    vials.values
  end

  private

  def forth_parse(row)
    { vial: row[1],
      n2o: { area: row[2].to_f, ppm: row[11].to_f },
      co2: { area: row[4].to_f, ppm: row[12].to_f },
      ch4: { area: row[6].to_f, ppm: row[13].to_f } }
  end
end
