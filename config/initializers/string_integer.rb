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

  Alpha26 = ("a".."z").to_a

  def to_alpha
    return "" if self < 1
    s, q = "", self
    loop do
      q, r = (q - 1).divmod(26)
      s.prepend(Alpha26[r])
      break if q.zero?
    end
    s
  end
end
