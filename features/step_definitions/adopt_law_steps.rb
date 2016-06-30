When(/^I go to adopt the proposed law$/) do
  visit "/#/proposed-laws/#{@proposed_law.id}"
  within(:css, 'h2') do
    find( :xpath, ".//a[contains(.,'Adopt Law')]" ).click
  end
  fill_in 'Finally Adopted On', with: Time.zone.today.to_s(:db)
end

When /^I certify the proposed law is (not subject|approved|rejected|allowed) (?:to|by) executive review$/ do |action|
  if action != 'not subject'
    text = case action
    when 'approved'
      action
    when 'rejected'
      'repassed after disapproval'
    else
      'not approved and no longer subject to approval'
    end
    find( :xpath, ".//label[starts-with(.,'#{text}')]" ).click
    fill_in 'Executive Action Date', with: Time.zone.today.to_s(:db)
  else
    expect( page ).to have_no_text 'Executive Action Date'
  end
end

When /^I certify the law is subject to (no|mandatory|permissive|petition) referendum/ do |referendum|
  if referendum == 'no'
    find( :xpath, ".//label[starts-with(.,'Not subject to referendum')]" ).click
    expect( page ).to have_no_text 'Referendum Type'
  else
    find( :xpath, ".//label[starts-with(.,'Subject to referendum')]" ).click
    type = case referendum
    when 'mandatory', 'permissive'
      referendum
    else
      'permissive'
    end
    find( :xpath, ".//label[starts-with(.,'#{type}')]" ).click
    if referendum == 'petition'
      find( :xpath, ".//label[starts-with(.,'Petition received')]" ).click
    end
    if referendum == 'permissive'
      find( :xpath, ".//label[starts-with(.,'No petition received')]" ).click
    end
    if referendum != 'permissive'
      find( :xpath, ".//label[starts-with(.,'general')]" ).click
    end
    fill_in 'Referendum Date', with: Time.zone.today.to_s(:db)
  end
end

When(/^I adopt the proposed law$/) do
  click_button "Certify and Submit Adopted Law"
end

Then(/^I should see the proposed law is adopted$/) do
  expect( page ).to have_text "Adopted law was submitted."
  expect( page ).to have_text "#{Time.zone.today.year}-1. #{@proposed_law.title}"
end
