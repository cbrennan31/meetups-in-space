require 'spec_helper'

feature "User signs in" do
  let(:user) do
    FactoryGirl.create(:user)
  end

  scenario "successful sign in" do
    visit '/'
    sign_in_as user

    expect(page).to have_content "You're now signed in as #{user.username}!"
  end

  scenario "successful sign out" do
    visit '/'
    sign_in_as user
    click_link "Sign Out"

    expect(page).to have_content "You have been signed out"
  end
end
