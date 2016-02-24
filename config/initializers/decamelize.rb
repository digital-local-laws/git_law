module Enumerable
  def camelize!
    # Call on each enumerable member
    each do |member|
      member.camelize! if member.class.include? Enumerable
    end
  end

  def decamelize!
    # Call on each enumerable member
    each do |member|
      member.decamelize! if member.class.include? Enumerable
    end
  end
end

class Hash
  def camelize!
    rekeys = []
    each_key do |k|
      k_camel = k.camelize(:lower)
      rekeys << [ k, k_camel ] if k != k_camel
      self[k].camelize! if self[k].class.include? Enumerable
    end
    rekey! rekeys
    self
  end

  def decamelize!
    rekeys = []
    each_key do |k|
      k_under = k.underscore
      rekeys << [ k, k_under ] if k != k_under
      self[k].decamelize! if self[k].class.include? Enumerable
    end
    rekey! rekeys
    self
  end

  def rekey!(rekeys)
    rekeys.each do |rekey|
      self[rekey.last] = delete( rekey.first )
    end
  end
end
