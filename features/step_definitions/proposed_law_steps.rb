Given(/^I visit the jurisdiction's page$/) do
  visit "/#/jurisdictions/#{@jurisdiction.id}"
end

When(/^I propose a law$/) do
  find(:xpath,'//a[contains(.,"Propose a Law")]').click
  fill_in "Title", with: "Authorizing formation of Office of Chief Innovation Officer"
  find(:xpath,'//button[contains(.,"Add Proposed Law")]').click
end

Then(/^the proposed law should be added$/) do
  expect( Capybara.current_session ).to have_text "Authorizing formation of Office of Chief Innovation Officer"
  expect( Capybara.current_session ).to have_text "Please wait while the proposed law is initialized."
  step "initialization has completed"
  expect( ProposedLaw.count ).to eq 1
end

Given(/^I proposed a law$/) do
  step "a jurisdiction exists"
  step "I log in"
  step "I visit the jurisdiction's page"
  step "I propose a law"
  expect( Capybara.current_session ).to have_text "Please wait while the proposed law is initialized."
  step "initialization has completed"
  @proposed_law = ProposedLaw.first
end

When(/^I remove the proposed law$/) do
  click_link @proposed_law.jurisdiction.name
  find(:xpath,'//a[contains(.,"Remove")]').click
end

Then(/^I should see the proposed law was removed$/) do
  expect( page ).to have_text "Proposed law was removed."
end

Then(/^the proposed law should not be recorded in the database$/) do
  expect( ProposedLaw.count ).to eq 0
end

When(/^I edit the proposed law settings$/) do
  click_link @proposed_law.jurisdiction.name
  find(:xpath,'//a[contains(.,"Settings")]').click
  fill_in "Title", with: "Authorizing formation of Office of Chief Obstructionist"
  find(:xpath,'//button[contains(.,"Update Proposed Law Settings")]').click
end

Then(/^the proposed law settings should be updated$/) do
  expect( page ).to have_text "Proposed law settings were updated."
  expect( page ).to have_text "Authorizing formation of Office of Chief Obstructionist"
  expect( ProposedLaw.first.title ).to eq "Authorizing formation of Office of Chief Obstructionist"
end

When(/^I add a code$/) do
  find( :xpath, '//button[contains(.,"Add Code")]' ).click
  fill_in "Title", with: "Tompkins County Code"
  step "I fill in the following levels for the code structure:", table(%{
    | level | label | number | title | text  | optional |
    | 1     | part  | arabic | yes   | no    | no       |
  })
  within(".modal-footer") do
    click_button "Add Code"
  end
  step "the modal has vanished"
end

Then(/^the code should be added$/) do
  within 'h3' do
    expect( page ).to have_text "Tompkins County Code"
  end
  click_link "/"
  within 'tbody' do
    expect( page ).to have_text "Tompkins County Code"
  end
end

Given /^I fill in the following levels for the code structure:$/ do |t|
  @proposed_law_levels ||= []
  t.hashes.each do |level|
    @proposed_law_levels << level
    parent_level = "Level #{level['level'].to_i - 1}"
    this_level = "Level #{level['level']}"
    number_key = {
      "lower roman" => "Lower case roman (i, ii, ...)",
      "upper roman" => "Upper case roman (I, II, ...)",
      "lower alpha" => "Lower case alphabetical (a, b, ...)",
      "upper alpha" => "Upper case alphabetical (A, B, ...)",
      "arabic" => "Arabic (1, 2, ...)"
    }
    unless has_selector?( :xpath, "//fieldset[contains(./legend,\"#{this_level}\")]" )
      within_fieldset parent_level do
        click_button "Add Level"
      end
    end
    within_fieldset this_level do
      fill_in "Label", with: level['label']
      select number_key[level['number']], from: "Number"
      title_button = level['title'] == 'yes' ? 'Allow Title' : 'Prohibit Title'
      find( :xpath, ".//label[contains(.,\"#{title_button}\")]" ).click
      text_button = level['text'] == 'yes' ? 'Allow Text' : 'Prohibit Text'
      find( :xpath, ".//label[contains(.,\"#{text_button}\")]" ).click
      optional_button = level['optional'] == 'yes' ? 'Is Optional' : 'Is Not Optional'
      find( :xpath, ".//label[contains(.,\"#{optional_button}\")]" ).click
    end
  end
end

Given(/^I added a structured code:$/) do |t|
  find( :xpath, '//button[contains(.,"Add Code")]' ).click
  fill_in "Title", with: "Tompkins County Code"
  step "I fill in the following levels for the code structure:", t
  within(".modal-footer") do
    click_button "Add Code"
  end
  step "the modal has vanished"
  within("h3") do
    expect( page ).to have_text "Tompkins County Code"
  end
end

Given(/^initialization has completed$/) do
  step "all jobs have run"
  start = Time.now
  until Capybara.current_session.current_url =~ /\/node\/$/ do
    raise 'Timed out waiting for initialization to complete' if Time.now - start > 10.seconds
    sleep 0.01
  end
end

When(/^I add an? (\w+) to the (\w+) in the code$/) do |child, parent|
  @proposed_law = ProposedLaw.first
  structure = @proposed_law.working_file('tompkins-county-code.json').node.attributes["structure"]
  labels = structure.map { |level| level['label'] }
  unless parent == 'root'
    unless labels.include? parent
      raise "Parent #{parent} not part of code structure"
    end
    grandparent = labels.index(parent) > 0 ? labels[labels.index(parent)-1] : 'root'
    step "I add a #{parent} to the #{grandparent} in the code"
  end
  find( :xpath, ".//button[contains(.,\"Add #{child.capitalize}\")]" ).click
  this_structure = structure[ labels.index(child) ]
  fill_in 'Title', with: "A new #{child}" if this_structure['title']
  fill_in 'Number', with: '1'
  within(".modal-footer") do
    click_button "Add #{child.capitalize}"
  end
  step "the modal has vanished"
end

Then(/^the (\w+) should be added to the (\w+) in the code$/) do |child, parent|
  within 'h3' do
    # TODO logic should access code structure
    expect( page ).to have_text "#{child.capitalize} 1"
  end
end

When(/^I edit the text of the section$/) do
  click_link "Text"
  expect( page ).to have_xpath( './/textarea', visible: false )
  find(:xpath,'.//textarea', visible: false).set("This is the start of a code.")
  expect( Capybara.current_session ).to have_text "Saving..."
end

When(/^saving has completed$/) do
  start = Time.zone.now
  while Capybara.current_session.has_text?("Saving...") do
    raise "Timeout waiting for saving to complete." if Time.zone.now - start > 10.seconds
    sleep 0.01
  end
end

Then(/^the section should should be changed$/) do
  step "saving has completed"
  expect( @proposed_law.working_file( proposed_law_text_file_tree ).content
    ).to include "This is the start of a code."
end

When /^I go to the (\w+) in the code$/ do |parent|
  if parent == 'root'
    click_link 'Tompkins County Code'
  else
    click_link "#{parent.capitalize} 1"
  end
end

When /^I change settings for the (\w+)$/ do |child|
  step "I go to change the settings for the #{child}"
  fill_in "Title", with: "An old #{child}"
  step "I save the changed settings for the #{child}"
end

When /^I save the changed settings for the (\w+)$/ do |child|
  within('.modal-footer') do
    click_button "Update #{child.capitalize}"
  end
  step "the modal has vanished"
end

When /^I go to change the settings for the (\w+)$/ do |child|
  within( :xpath, ".//tr[contains(./td,\"A new #{child}\")]" ) do
    find(:xpath,".//button[contains(.,\"Settings\")]").click
  end
end

Then /^the (\w+) settings should be changed in the code$/ do |child|
  within('table') do
    expect( page ).to have_text "An old #{child}"
  end
end

When /^I renumber the (\w+) in the code$/ do |child|
  within( :xpath, ".//tr[contains(./td,\"An old #{child}\")]" ) do
    find(:xpath,".//button[contains(.,\"Settings\")]").click
  end
  fill_in "Number", with: "2"
  step "I save the changed settings for the #{child}"
end

Then /^the (\w+) should be renumbered$/ do |child|
  expect( page ).to have_text "#{child.capitalize} 2. An old #{child}"
  expect( find( :xpath, ".//a[contains(.,\"An old #{child}\")]" )[:href]
    ).to match /#{child}\-2/
end

When /^I delete the (\w+) from the code$/ do |child|
  within( :xpath, ".//tr[contains(./td,\"An old #{child}\")]" ) do
    find( :xpath, ".//button[contains(.,\"Remove\")]" ).click
  end
end

Then /^the (\w+) should be absent from the code$/ do |child|
  expect( page ).to have_no_text "An old #{child}"
end

Given /^the modal has vanished$/ do
  start = Time.zone.now
  while Capybara.current_session.has_css? '.modal' do
    raise "Timeout waiting for modal to disappear" if Time.zone.now - start > 10.seconds
    sleep 0.01
  end
end

Given /^the (\w+) has no text$/ do |label|
  @proposed_law.working_file( proposed_law_text_file_tree ).destroy
  expect( @proposed_law.working_file( proposed_law_text_file_tree ).exists? ).to be false
  click_link "Chapter 1"
  click_link "Section 1. A new section"
end

When /^I add text to the (\w+)$/ do |label|
  click_link "Text"
  expect( page ).to have_text "No text content exists for this #{label}."
  click_button "Click here to add text."
end

Then /^text should be added to the (\w+)$/ do |label|
  step "saving has completed"
  expect( @proposed_law.working_file( proposed_law_text_file_tree ).exists? ).to be true
end

When /^I rename the code$/ do
  click_link @proposed_law.title
  within( :xpath, "//tr[contains(.,'Tompkins County Code')]" ) do
    find( :xpath, ".//button[contains(.,'Settings')]" ).click
  end
  sleep 2
  fill_in "Title", with: "Tioga County Code"
  click_button "Update Code Settings"
  step "the modal has vanished"
end

Then /^the code should be renamed$/ do
  within( :xpath, './/table' ) do
    expect( page ).to have_text "Tioga County Code"
    expect( page ).to have_no_text "Tompkins County Code"
  end
  expect( @proposed_law.working_file('tompkins-county-code.json').exists? ).to be false
  expect( @proposed_law.working_file('tioga-county-code.json').exists? ).to be true
end

When(/^I adopt the proposed law$/) do
  click_link "Authorizing formation of Office of Chief Innovation Officer"
  within(:css, 'h2') do
    find( :xpath, ".//a[contains(.,'Adopt')]" ).click
  end
  find( :xpath, ".//label[contains(.,'Local legislative body only')]" ).click
  click_button "Certify and Submit Adopted Law"
end

Then(/^I should see the proposed law is adopted$/) do
  expect( page ).to have_text "Adopted law was submitted."
end
