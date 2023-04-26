# Sorting Distances

# When attempting to sort an array of various lengths, we are surprised to see that an ArgumentError is raised.
# Make the necessary changes to our code so that the various lengths can be 
# properly sorted and line 62 produces the expected output.

class Length
  include Comparable
  
  attr_reader :value, :unit

  def initialize(value, unit)
    @value = value
    @unit = unit
  end

  def as_kilometers
    convert_to(:km, { km: 1, mi: 0.6213711, nmi: 0.539957 })
  end

  def as_miles
    convert_to(:mi, { km: 1.609344, mi: 1, nmi: 0.8689762419 })
  end

  def as_nautical_miles
    convert_to(:nmi, { km: 1.8519993, mi: 1.15078, nmi: 1 })
  end

  def <=>(other)
    if unit == :km
      value <=> other.as_kilometers.value
    elsif unit == :mi
      value <=> other.as_miles.value
    elsif unit == :nmi
      value <=> other.as_nautical_miles.value
    end
  end

  def to_s
    "#{value} #{unit}"
  end

  private

  def convert_to(target_unit, conversion_factors)
    Length.new((value / conversion_factors[unit]).round(4), target_unit)
  end
end

# Example

puts [Length.new(1, :mi), Length.new(1, :nmi), Length.new(1, :km)].sort
# => comparison of Length with Length failed (ArgumentError)
# expected output:
# 1 km
# 1 mi
# 1 nmi


# > The issue here is that we have not implemented a <=> method yet; this is what `Array#sort` relies on
# Proposed method definition added above.