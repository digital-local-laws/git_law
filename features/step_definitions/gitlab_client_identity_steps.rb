When(/^I go to my client identities listing$/) do
  click_link "My Identities"
end

Then(/^I should see (no|\d+|a|the) gitlab client identit(?:y|ies) in the listing$/) do |number|
  if number == 'the'
    within '#gitlab-client-identities' do
      cols = all('td')
      expect( cols[0] ).to have_text @gitlab_client_identity.host
      expect( cols[1] ).to have_text @gitlab_client_identity.gitlab_user_name
    end
  end
  number = case number
  when 'no'
    0
  when 'a', 'the'
    1
  else
    number.to_i
  end
  if number > 0
    within "#gitlab-client-identities" do
      expect( page ).to have_css("tbody tr", count: number)
    end
  else
    expect( page ).to have_no_css '#gitlab-client-identities'
  end
end

When(/^I add a gitlab client identity$/) do
  find( :xpath, ".//button[contains(.,\"Add Gitlab Identity\")]" ).click
  fill_in 'Host', with: 'example.com'
  fill_in 'App Id', with: 'auser'
  fill_in 'App Secret', with: 'aa1b1b1sb1bwb1wb1beheeh3eb3eb23heb2'
  stub_request( :get, 'example.com' )
  click_button 'Register Identity'
end

Then(/^I should be redirected to the gitlab host for authorization$/) do
  expect( page ).to have_no_text 'Register Gitlab'
  uri = URI.parse( current_url )
  expect( uri.host ).to eql 'example.com'
  expect( uri.port ).to eql 443
  expect( uri.path ).to eql '/oauth/authorize'
  expect( uri.query ).to include 'client_id=auser'
  expect( uri.query ).to include 'redirect_uri='
  expect( uri.query ).to include 'response_type=code'
end

Given(/^I have a gitlab client identity$/) do
  @gitlab_client_identity = create :gitlab_client_identity, user: @current_user
end

Then(/^I may( not)? go to (my|another's)? client identities listing$/) do |negate,target|
  # TODO any UI expectations for user who cannot administer another user's client identities?
  if negate
    if target == 'my'
      expect( page ).to have_no_link 'My Identities'
    end
  else
    if target == 'my'
      expect( page ).to have_link 'My Identities'
    end
  end
end

Then(/^I should( not)? be on the home page$/) do |negate|
  uri = URI.parse( current_url )
  if negate
    expect( uri.path ).not_to eql '/'
  else
    expect( uri.path ).to eql '/'
  end
end

When(/^I remove a gitlab client identity$/) do
  within("#gitlab-client-identities tbody tr") do
    find(:xpath,'.//button[contains(.,"Remove")]').click
  end
end

Then(/^I should have no gitlab client identity$/) do
  expect( @current_user.gitlab_client_identities.count ).to eql 0
end
