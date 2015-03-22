class Hash
  def decamelize!
    inject([]) { |memo, (k, v)|
      v.decamelize! if v.is_a? Hash
      k_underscored = k.underscore
      if k != k_underscored
        memo << [ k, k_underscored ]
      end
      memo
    }.each do |camel|
      self[ camel.last ] = delete( camel.first )
    end
    self
  end
  
  def camelize!
    inject([]) { |memo, (k, v)|
      v.camelize! if v.is_a? Hash
      k_camel = k.camelize(:lower)
      if k != k_camel
        memo << [ k, k_camel ]
      end
      memo
    }.each do |camel|
      self[ camel.last ] = delete( camel.first )
    end
    self
  end
end
