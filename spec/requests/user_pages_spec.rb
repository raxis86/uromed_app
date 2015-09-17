require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do

    describe "index with no-admin users" do 
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        sign_in user
        visit users_path
      end

      it { should have_title('Главная') }
      #it { should have_content('Все пользователи') }
    end

    let(:user) { FactoryGirl.create(:admin) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('Все пользователи') }
    it { should have_content('Все пользователи') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('удалить') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('удалить', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('удалить', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('удалить', href: user_path(admin)) }
      end
    end

  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    #it { should have_content(user.name) }
    #it { should have_title(user.name) }
    it { should have_title("Вход") }
  end

  describe "signup page" do
    before { visit signup_path }

    let(:submit) { "Зарегистрироваться" }

    it { should have_content('Регистрация') }
    it { should have_title(full_title('Регистрация')) }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Имя",         			with: "Example User"
        fill_in "Email",        		with: "user@example.com"
        fill_in "Пароль",     			with: "foobar"
        fill_in "Подтверждение пароля", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Выход') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Поздравляем') }
      end

    end

  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Редактирование профиля") }
      it { should have_title("Редактирование пользователя") }
      it { should have_link('сменить', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Сохранить изменения" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Имя",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Пароль",         with: user.password
        fill_in "Подтверждение пароля", with: user.password
        click_button "Сохранить изменения"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Выход', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

  end


end