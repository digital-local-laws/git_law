Given(/^I log in(?: as (admin|staff|user|nobody))?$/) do |global_role|
  return if global_role == 'nobody'
  attributes = case global_role
  when 'admin'
    { admin: true }
  when 'staff'
    { staff: true }
  else
    {}
  end
  user = create(:user, attributes)
  visit '/'
  click_link "Sign In"
  click_button "Developer"
  fill_in "Name", with: 'A User'
  fill_in "Email", with: user.email
  click_button "Sign In"
  expect( Capybara.current_session ).to have_no_text "Sign In"
  expect( Capybara.current_session ).to have_text "Sign Out"
  Capybara.current_session.visit '/'
end

When(/^I log out$/) do
  click_button "Sign Out"
end

Then(/^I should be logged out$/) do
  expect( page ).to have_text "Sign In"
  expect( page ).to have_no_text "Sign Out"
end
