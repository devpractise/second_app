require 'spec_helper'

describe "User pages" do

  subject { page }
  before do
    @user = User.create(name: "Example User", email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar")
  end
  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end
  describe "profile page" do
  	let(:user) { @user }
  	before { visit user_path(user) }

  	it { should have_selector('h1',    text: user.name) }
  	it { should have_selector('title', text: user.name) }
  end

  describe "edit" do
    let(:user) { @user }
    before do
      visit signin_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password_confirmation
      click_button "Sign in"
      #Sign in when not using Capybara as well with:
      cookies[:remember_token] = user.remember_token
      visit edit_user_path(user)
    end

    describe "page" do 
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
  end
end