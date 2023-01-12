# frozen_string_literal: true

# chemstation file utility functions
class ChemstationUtils
  def self.locate_compound_columns(row)
    compounds = {co2: ["CO2", "co2", "c02", "C02"],
                ch4: ["CH4", "ch4"],
                n2o: ["N2O" , "n2o", "N20", "n20"]
    }

    compounds.collect do | key, values|
      values.collect {|val| row.index(val)}.compact[0]
    end
  end

  def self.parse_vial(row)
    vial = find_vial(row)
    if CimmitVial.cimmit_vial?(vial)
      CimmitVial.process_cimmit_vial(vial)
    elsif vial.match?(/-/)
      normalize_vial_name(vial)
    else
      vial
    end
  end

  def self.normalize_vial_name(vial)
    my_vial = vial.split(/-/).last # .sub(/B/, '')

    /B?-?(?<name>.+)/ =~ my_vial
    name
  end

  def self.find_vial(row)
    if vial?(row[3])
      row[3]
    else
      row[4]
    end
  end

  def self.parse_time(cell)
    # format = "%m/%d/%Y %H:%M:%S"
    # DateTime.strptime(cell, format)
    # swap month and day for the americans
    if cell =~ /(\d+)\/(\d+)\/(.+)/
      cell = "#{$2}/#{$1}/#{$3}"
    end
    Time.parse(cell)
  end

  def self.looks_like_time?(vial)
    # check if the field looks like a time
    vial =~ /\d{2}:\d{2}:\d{2}/
  end

  def self.vial?(vial)
    # check if the field does not looks like a time
    vial !~ /\d{2}:\d{2}:\d{2}/
  end
end
