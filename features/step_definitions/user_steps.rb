Then /^I may( not)? (create|update|destroy|authorize) users$/ do |negate, action|
  method = ( negate ? :not_to : :to )
  visit('/')
  click_link 'Administration'
  click_link 'Users'
  case action
  when 'authorize'
    all(:xpath,'.//a[contains(.,"Edit")]').first.click
    if negate
      expect( page ).to have_no_selector(:enabled_label,'Is Administrator')
      expect( page ).to have_no_selector(:enabled_label,'Is Staff')
    else
      expect( page ).to have_selector(:enabled_label,'Is Administrator')
      expect( page ).to have_selector(:enabled_label,'Is Staff')
    end
  when 'create'
    expect( page ).send method, have_xpath('//a[contains(.,"Add User")]')
  when 'update'
    expect( page ).send method, have_xpath('.//a[contains(.,"Edit")]')
  when 'destroy'
    expect( page ).send method, have_xpath('.//a[contains(.,"Remove")]')
  end
end

When(/^I go to the users listing$/) do
  find( :xpath, '//a[contains(.,"Administration")]').click
  within( :xpath, '//li/a[contains(.,"Administration")]' ) do
    find( :xpath, '//a[contains(.,"Users")]').click
  end
end

Then(/^I should( not)? see (myself|[A-Z][a-z]+ [A-Z][a-z]+) in the users listing$/) do |no, user|
  names = case user
  when 'myself'
    [ @current_user.first_name, @current_user.last_name ]
  else
    user.split ' '
  end
  within("#users") do
    if no
      expect( page ).to have_no_selector :user_row, names
    else
      expect( page ).to have_selector :user_row, names
    end
  end
end

Given(/^another user named ([A-Z][a-z]+ [A-Z][a-z]+) exists$/) do |user|
  create_from_user_pattern user
end

When /^I create another user named ([A-Z][a-z]+ [A-Z][a-z]+)$/ do |user|
  attributes = attributes_for(:user).
    merge( attributes_from_user_pattern( user ) )
  find( :xpath, './/a[contains(.,"Add User")]' ).click
  fill_in 'First Name', with: attributes[:first_name]
  fill_in 'Last Name', with: attributes[:last_name]
  fill_in 'Email', with: attributes[:email]
  fill_in 'Password', with: attributes[:password]
  fill_in 'Password Confirmation', with: attributes[:password_confirmation]
  click_button 'Add User'
end

When(/^I remove ([A-Z][a-z]+ [A-Z][a-z]+) from the users listing$/) do |user|
  user = from_user_pattern( user )
  within(:user_row, [ user.first_name, user.last_name ] ) do
    find( :xpath, './/a[contains(.,"Remove")]' ).click
  end
end

When(/^I jump to the users listing$/) do
  visit '/#/users'
end

When(/^I edit ([A-Z][a-z]+ [A-Z][a-z]+) in the users listing$/) do |name|
  within( :user_row, name ) do
    find( :xpath, './/a[ contains(.,"Edit") ]' ).click
  end
  fill_in 'First Name', with: "Alfred"
  fill_in 'Last Name', with: "Smith"
  fill_in 'Email', with: "asmith@example.com"
  find( :xpath, './/label[ contains(.,"Is Administrator") ]' ).click
  click_button 'Update User Settings'
end

Then(/^I should see the user was updated$/) do
  expect( page ).to have_text 'User updated'
end

Then(/^I should see the user was created$/) do
  expect( page ).to have_text 'User created'
end

Then(/^the user should be updated$/) do
  user = User.where( first_name: 'Alfred', last_name: 'Smith' ).first
  expect( user ).not_to be_nil
  expect( user.email ).to eql 'asmith@example.com'
  expect( user.admin ).to be true
end
