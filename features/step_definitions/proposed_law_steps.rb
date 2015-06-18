Given(/^I visit the jurisdiction's page$/) do
  visit "/jurisdictions/#{@jurisdiction.id}"
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
  within("h3") do
    expect( page ).to have_text "Tompkins County Code"
  end
end

Given(/^initialization has completed$/) do
  step "all jobs have run"
  start = Time.now
  until Capybara.current_session.current_url =~ /\/nodes\/$/ do
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
end

Then(/^the (\w+) should be added to the (\w+) in the code$/) do |child, parent|
  within 'h3' do
    # TODO logic should access code structure
    expect( page ).to have_text "#{child.capitalize} 1"
  end
end

When(/^I edit the text of the section$/) do
  find( :xpath, ".//textarea" ).set("This is the start of a code.")
  expect( page ).to have_text "Saving..."
end

When(/^saving has completed$/) do
  start = Time.zone.now
  while Capybara.current_session.has_text?("Saving...") do
    raise "Timeout waiting for saving to complete." if Time.zone.now - start > 10.seconds
    sleep 0.01
  end
end

Then(/^the section should should be changed$/) do
  path = "tompkins-county-code/"
  path += @proposed_law_levels.map { |level|
    "#{level['label']}-1"
  }.join("/") + ".asc"
  step "saving has completed"
  expect( @proposed_law.working_file(path).content ).to include "This is the start of a code."
end

When /^I go to the (\w+) in the code and change settings for the (\w+)$/ do |parent, child|
  if parent == 'root'
    click_link 'Tompkins County Code'
  else
    click_link "#{parent.capitalize} 1"
  end
  within( :xpath, ".//tr[contains(./td,\"A new #{child}\")]" ) do
    find(:xpath,".//button[contains(.,\"Settings\")]").click
  end
  fill_in "Title", with: "An old #{child}"
  click_button "Update #{child.capitalize}"
end

Then /^the (\w+) settings should be changed in the code$/ do |child|
  within('table') do
    expect( page ).to have_text "An old #{child}"
  end
end
