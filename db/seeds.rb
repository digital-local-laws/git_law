# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = User.new(
  first_name: 'An',
  last_name: 'Administrator',
  email: 'admin@example.com',
  admin: true,
  password: 'secretsquirrel',
  password_confirmation: 'secretsquirrel'
)
admin.skip_confirmation!
admin.save!

jurisdiction = Jurisdiction.create!(
  name: 'Ithaca',
  legislative_body: 'Ithaca Common Council',
  executive_review: true
)

jurisdiction.jurisdiction_memberships.create!(
  user: admin,
  propose: true,
  adopt: true
)
