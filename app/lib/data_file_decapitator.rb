# frozen_string_literal: true

# Shift out un-needed header lines from a data array
class DataFileDecapitator
  def self.shift_header_lines(lines)
    first_row_of_data(lines).times do
      lines.shift
    end
    lines
  end

  def self.first_row_of_data(lines)
    result = 0
    lines.each do |row|
      break if row[1] =~ /\d+/
      result += 1
    end
    result
  end
end
