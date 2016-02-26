Given(/^I log in(?: as (?:(admin|staff|user|nobody)|(proposer) for the jurisdiction))?$/) do |global_role,jurisdiction_role|
  return if global_role == 'nobody'
  attributes = case global_role
  when 'admin'
    { admin: true }
  when 'staff'
    { staff: true }
  else
    {}
  end
  @current_user = create(:user, attributes)
  if jurisdiction_role
    attributes = { user: @current_user, jurisdiction: @jurisdiction }
    case jurisdiction_role
    when 'proposer'
      attributes.merge! propose: true
    when 'adopter'
      attributes.merge! adopt: true
    end
    create :jurisdiction_membership, attributes
  end
  visit '/'
  click_link "Sign In"
  click_button "Developer"
  fill_in "Name", with: 'A User'
  fill_in "Email", with: @current_user.email
  click_button "Sign In"
  expect( Capybara.current_session ).to have_no_text "Sign In"
  expect( Capybara.current_session ).to have_text "Sign Out"
  Capybara.current_session.visit '/'
end

When(/^I log out$/) do
  click_button "Sign Out"
  @current_user = nil
end

Then(/^I should be logged out$/) do
  expect( page ).to have_text "Sign In"
  expect( page ).to have_no_text "Sign Out"
end
