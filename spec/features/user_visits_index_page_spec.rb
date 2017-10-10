require 'spec_helper'

feature 'User visits index page' do
  scenario 'view list of available meetups' do
    FactoryGirl.create(:meetup)
    visit '/'

    expect(page).to have_content("New Meetup")
  end
end
