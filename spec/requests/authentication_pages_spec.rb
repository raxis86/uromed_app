require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Вход') }
    it { should have_title('Вход') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Вход" }

      it { should have_title('Вход') }
      it { should have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before { click_link "Зарегистрируйтесь сейчас!" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end #"with invalid information"

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      #it { should have_link('Пользователи',       href: users_path) }
      it { should have_link('Профиль',     href: user_path(user)) }
      it { should have_link('Настройки',   href: edit_user_path(user)) }
      it { should have_link('Выход',    href: signout_path) }
      it { should_not have_link('Вход', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Выход" }
        it { should have_link('Вход') }
      end #"followed by signout"

    end #"with valid information"

  end #"signin"

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Пароль", with: user.password
          click_button "Вход"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Редактирование пользователя')
          end
        end #"after signing in"

      end #"when attempting to visit a protected page"

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Вход') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Вход') }
        end

      end #"in the Users controller"

    end #"for non-signed-in users"

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Редактирование пользователя')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end

    end #"as wrong user"

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end

    end #"as non-admin user"

    describe "for non-email_confirmed users" do
      let(:user) { FactoryGirl.create(:user_no_confirm) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Пароль", with: user.password
          click_button "Вход"
        end

        describe "after signing in" do
          it { should have_title('Вход') }
          it { should have_selector('div.alert.alert-notice') }
        end #"after signing in"

      end #"when attempting to visit a protected page"

      describe "when attemoting to confirm email" do
        before do
          user.update_attributes(confirm_token: "123")
        end

        describe "submitting a GET request to the users#email_confirm" do
          before { get email_confirm_user_path(user.confirm_token) }
          
          specify { expect(response).to redirect_to(signin_url) }

          #it { should have_selector('div.alert.alert-success') }
          #it { should have_title('Вход') }
        end #"submitting a GET request to the users#email_confirm"

      end #"when attemoting to confirm email"

    end #"for non-email_confirmed users"

  end #"authorization" 

end #"Authentication"
