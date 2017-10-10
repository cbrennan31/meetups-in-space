require 'spec_helper'

feature 'User visits show page' do
  scenario 'view details of a meetup' do
    meetup = FactoryGirl.create(:meetup)
    visit '/meetups/1'

    expect(page).to have_content(meetup.name)
  end

  scenario 'view list of people in a meetup' do
    meetup = FactoryGirl.create(:meetup)
    visit '/meetups/1'

    expect(page).to have_content(meetup.creator)
  end

  scenario 'user does not sign in' do
    user = FactoryGirl.create(:user)
    meetup = FactoryGirl.create(:meetup)

    visit '/meetups/1'
    sign_in_as user
    click_link "Sign Out"
    click_on('Join This Meetup!')

    expect(page).to have_content("Please sign in")
  end

  scenario 'user does sign in' do
    user = FactoryGirl.create(:user)
    meetup = FactoryGirl.create(:meetup)

    visit '/meetups/1'
    sign_in_as user
    click_on('Join This Meetup!')

    expect(page).to have_content(user.username)
    expect(page).to have_content("You\'re in! Nice!")
  end

  scenario 'user has already signed up' do
    user = FactoryGirl.create(:user)
    registration = FactoryGirl.create(:registration)
    meetup = FactoryGirl.create(:meetup)

    visit '/meetups/1'
    sign_in_as user
    click_on('Join This Meetup!')

    expect(page).to have_content(user.username)
    expect(page).to have_content("You\'re in! Nice!")

    click_on('Join This Meetup!')
    expect(page).to have_content("You\'ve already signed up for this meetup.")
  end
end
