Given(/^I log in(?: as (?:(admin|staff|user|nobody)|(owner|lapsed owner) of the proposed law|(proposer|adopter) for the jurisdiction))?$/) do |global_role,proposed_law_role,jurisdiction_role|
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
  if proposed_law_role
    jurisdiction_role = case proposed_law_role
    when 'owner'
      'proposer'
    end
  end
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
  if proposed_law_role
    @proposed_law.user = @current_user
    @proposed_law.save!
  end
  visit '/'
  click_link "Sign In"
  click_button "Developer"
  fill_in "First name", with: @current_user.first_name
  fill_in "Last name", with: @current_user.last_name
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
