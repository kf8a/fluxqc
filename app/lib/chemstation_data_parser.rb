# frozen_string_literal: true

# parse chemstation data files
class ChemstationDataParser
  def parse(lines)
    # look for first row that starts with a number
    lines = DataFileDecapitator.shift_header_lines(lines)
    vials = {}
    lines.each do |row|
      p "SINGLE LOOP"
      vials[row[1]] = chemstation_parse(row)
    end
    vials.values
  end

  def chemstation_parse(row)
    results = {}
    results[:vial] = ChemstationUtils.parse_vial(row)
    results[:acquired_at] = ChemstationUtils.parse_time(row[0])

    # columns = [4, 8, 12] # the location of the compound names
    #
    # # if the column 3 is not a vial but looks like a date
    # columns = [6, 10, 14] if looks_like_time?(row[3])
    #
    # # column 4 can be empty or col 3 is not a vial
    # columns = [5, 9, 13] unless row[4] # if column 4 is empty then they are shifted
    columns = ChemstationUtils.locate_compound_columns(row)
    columns.each do |column|
      # Rename 0 to o because sometimes n2o get's written as n20
      key = row[column].downcase.tr('0', 'o').to_sym

      value = row[column + 2]
      results[key] = { column: row[1].to_i % 2, area: value.to_f }
    end
    results
  end
end
