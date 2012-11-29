require 'spec_helper'

describe "Authentication" do 
	subject {page}


	describe "signin page" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in"}

			it { should have_selector('title', text: 'Sign in')}
			it { should have_selector('div.alert.alert-error', text: 'Invalid')}

		end
	
	
		describe "with valid information" do
			before do
				@user = User.create(name: "Example User", email: "user@example.com", 
            	password: "foobar", password_confirmation: "foobar")
			

				fill_in "Email", with: @user.email
				fill_in "Password", with: @user.password
				click_button "Sign in"
			end


			it { should have_selector('title', text: @user.name) }
			it { should have_link('Profile', href: user_path(@user)) }
			it { should have_link('Settings', href: edit_user_path(@user))}
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
			it { should have_link('Sign out')}
		end
		
		describe "after visiting another page" do
  			before { click_link "Home" }
  			it { should_not have_selector('div.alert.alert-error') }
		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do
			before do 
				@user2 = User.create(name: "NotLoggedInGuy", email: "notloggedinguy@example.com", password: "foobar", password_confirmation: "foobar")
			end

			describe "in the Users controller" do
				describe "visiting the edit page" do
					before { visit edit_user_path(@user2) }
					it { should have_selector('title', text: 'Sign in') }
				end
				describe "submitting to the update action" do 
					before { put user_path(@user2) } #Use PUT instead of visit 'edit' page because the only way to access user#update action is by submitting form...which Capybara can't do
					specify { response.should redirect_to(signin_path) } #Response is accessible because we issued a direct HTTP put request
				end
			end
		end

		describe "as wrong user" do
			
			before do 
				@testuser = User.create(name: "TesterGuy", email: "testerguy@example.com", password: "foobar", password_confirmation: "foobar")
				
				visit signin_path
      			fill_in "Email", with: @testuser.email
      			fill_in "Password", with: @testuser.password_confirmation
      			click_button "Sign in"
      			#Sign in when not using Capybara as well with:
      			cookies[:remember_token] = @testuser.remember_token
			end
			

			describe "visiting Users#edit page" do
				before do
					@wronguser = User.create(name: "WrongUserGuy", email: "wrong@example.com", password: "foobar", password_confirmation: "foobar" )
					visit edit_user_path(@wronguser) 
				end

				it { should_not have_selector('title', text: full_title('Edit user')) }

				describe "submitting a PUT request to the Users#update action" do
					before { put user_path(@wronguser) }
					specify { response.should redirect_to(root_path) }
				end
			end

		
		end
	end
end