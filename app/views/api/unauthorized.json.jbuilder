json.error do
  json.type "Unauthorized"
  json.message(
    t( "#{exception.policy.class.to_s.underscore}.#{exception.query}",
      scope: "pundit", default: :default )
  )
end
