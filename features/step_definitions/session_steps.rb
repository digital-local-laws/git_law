Given(/^I log in$/) do
  user = create(:user)
  visit '/'
  click_link "Sign In"
  click_button "Developer"
  fill_in "Email", with: user.email
  click_button "Sign In"
end

Then(/^I should be logged in$/) do
  login_email = "citizen@example.com"
  expect( page ).to have_no_text "Sign In"
  expect( page ).to have_text "Sign Out"
end

When(/^I log out$/) do
  click_button "Sign Out"
end

Then(/^I should be logged out$/) do
  expect( page ).to have_text "Sign In"
  expect( page ).to have_no_text "Sign Out"
end

