require 'spec_helper'

feature 'User visits new meetup page' do
  scenario 'User is not signed in' do
    visit '/'
    click_on("Create your own meetup! (Please sign in first.)")

    expect(page).to have_content 'Please sign in'
    expect(page).not_to have_content 'Name:'
  end

  scenario 'User signs in and creates a new meetup' do
    user = FactoryGirl.create(:user)

    visit '/'
    sign_in_as user
    click_on("Create your own meetup! (Please sign in first.)")

    fill_in 'name', with: 'Dope Meetup'
    fill_in 'description', with: "It\'s super"
    fill_in 'location', with: "Library"
    click_on("Create!")

    expect(page).to have_content "Your meetup has been created!"
    expect(page).to have_content "Description: It\'s super"
    expect(page).to have_content "Location: Library"
    expect(page).to have_content "Creator: #{user.username}"

    visit '/'
    expect(page).to have_content 'Dope Meetup'
  end

  scenario 'User creates a meetup with invalid information' do
    user = FactoryGirl.create(:user)
    meetup = FactoryGirl.create(:meetup)

    visit '/'
    sign_in_as user
    click_on("Create your own meetup! (Please sign in first.)")
    
    fill_in 'name', with: 'New Meetup'
    click_on('Create!')

    expect(page).to have_content "There is already a meetup called \'#{meetup.name}.\'"
    expect(page).to have_content "Please specify a location."
    expect(page).to have_content "Please include a description."
    expect(find_field('name').value).to eq 'New Meetup'
  end
end
