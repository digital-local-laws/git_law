class Integer
  ROMAN_NUMBERS = {
    1000 => "M",
     900 => "CM",
     500 => "D",
     400 => "CD",
     100 => "C",
      90 => "XC",
      50 => "L",
      40 => "XL",
      10 => "X",
        9 => "IX",
        5 => "V",
        4 => "IV",
        1 => "I",
        0 => "",
  }

  def to_roman
    return '' if self == 0
    ROMAN_NUMBERS.each do |value, letter|
      return ( letter * (self / value)) << (self % value).to_roman if value <= self
    end
    return (self % value).to_roman
  end

  def to_alpha
     return 'a' if zero?
     upper, lower = self.divmod 26
     unless upper.zero?
       column = (upper - 1).to_column
     else
       column = ''
     end
     column << (?a + lower).chr
   end
end
