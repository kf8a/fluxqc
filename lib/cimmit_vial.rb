class CimmitVial
  class << self
    def cimmit_vial?(vial)
      vial =~ /([a-z|A-Z]-?\d{3}-T\d)$/
    end

    def cimmit_vial_with_series
      /(S\d+)-(CIM)-([a-z|A-Z])-(\d{3}-T\d)$/
    end

    def cimmit_vial_with_dashes
      /([a-z|A-Z]-\d{3}-T\d)$/
    end

    def cimmit_vial_without_dashes
      /([a-z|A-Z])(\d{3}-T\d)$/
    end

    def process_cimmit_vial(vial)
      if vial =~ cimmit_vial_with_series
        vial = "#{$1}-#{$2}-#{$3}-#{$4}"
      elsif vial =~ cimmit_vial_with_dashes
        vial = $1
      else vial =~ cimmit_vial_without_dashes
        vial = "#{$1}-#{$2}"
      end
    end
  end
end
