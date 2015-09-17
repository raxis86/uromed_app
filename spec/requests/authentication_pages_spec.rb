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
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Пароль", 	with: user.password
        click_button "Вход"
      end

      it { should have_title(user.name) }
      #it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Выход',    href: signout_path) }
      it { should_not have_link('Вход', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Выход" }
        it { should have_link('Вход') }
      end

    end

  end

end
