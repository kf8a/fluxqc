# frozen_string_literal: true

require_relative 'chemstation_utils'

# parse chemstation data files
class DoubleLoopChemstationDataParser
  def parse(lines)
    # look for first row that starts with a number
    lines = DataFileDecapitator.shift_header_lines(lines)
    vials = {}
    lines.each do |row|
      data = parse_row(row)

      vials[row[1]] = merge(vials[row[1]], data)
    end
    vials.values
  end

  def merge(vial, data)
    if vial
      vial.merge(data)
    else
      data
    end
  end

  def parse_row(row)
    if first_loop?(row)
      # copy ch4
      row_a_parse(row)
    else
      # copy co2 and n2o
      row_b_parse(row)
    end
  end

  def first_loop?(row)
    vial = ChemstationUtils.find_vial(row)
    !b_sample?(vial)
  end

  def b_sample?(vial)
    vial =~ /^B/
  end

  def init_result(row)
    results = {}
    results[:vial] = ChemstationUtils.parse_vial(row)
    results[:acquired_at] = ChemstationUtils.parse_time(row[0])
    results
  end

  def row_a_parse(row)
    results = init_result(row)
    columns = ChemstationUtils.locate_compound_columns(row)
    columns.each do |column|
      # Rename 0 to o because sometimes n2o get's written as n20
      key = row[column].downcase.tr('0', 'o').to_sym
      next unless key == :ch4

      value = row[column + 2]
      results[key] = { column: 0, area: value.to_f }
    end
    results
  end

  def row_b_parse(row)
    results = init_result(row)
    columns = ChemstationUtils.locate_compound_columns(row)
    columns.each do |column|
      # Rename 0 to o because sometimes n2o get's written as n20
      key = row[column].downcase.tr('0', 'o').to_sym
      next if key == :ch4

      value = row[column + 2]
      gc_column = if key == :co2
                    0
                  else
                    row[1].to_i % 2
                  end
      results[key] = { column: gc_column, area: value.to_f }
    end
    results
  end
end
