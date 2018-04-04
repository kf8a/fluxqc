# frozen_string_literal: true

# parse chemstation data files
class ChemstationDataParser
  def parse(lines)
    # look for first row that starts with a number
    lines = DataFileDecapitator.shift_header_lines(lines)
    vials = {}
    lines.each do |row|
      vials[row[1]] = chemstation_parse(row)
    end
    vials.values
  end

  def chemstation_parse(row)
    results = {}
    results[:vial] = ChemstationUtils.parse_vial(row)
    results[:acquired_at] = ChemstationUtils.parse_time(row[0])

    columns = ChemstationUtils.locate_compound_columns(row)
    columns.each do |column|
      key = symbolize_key(row[column])

      value = row[column + 2]
      results[key] = { column: row[1].to_i % 2, area: value.to_f }
    end
    results
  end

  private

  def symbolize_key(name)
    # Rename 0 to o because sometimes n2o get's written as n20
    name.downcase.tr('0', 'o').to_sym
  end
end
