module StepPatterns
  def attributes_from_user_pattern( user )
    name = user.split(' ')
    { first_name: name.first, last_name: name.last }
  end

  def from_user_pattern( user )
    case user
    when 'myself'
      @current_user
    else
      name = attributes_from_user_pattern( user )
      User.where( first_name: name[:first_name], last_name: name[:last_name] ).first
    end
  end

  def create_from_user_pattern( user )
    name = attributes_from_user_pattern( user )
    create( :user, first_name: name[:first_name], last_name: name[:last_name] )
  end
end

World( StepPatterns )
