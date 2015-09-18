require 'spec_helper'

describe "Price pages" do

  subject { page }

  before do
      @p = Price.create(name: "Консультация", cost: "", parentid: 0)
  end

  describe "visit index page" do

    #let(:p) { FactoryGirl.create(:price) }
    before { visit prices_path }

    it { should have_title(full_title('Стоимость услуг'))}
    it { should have_content('Стоимость услуг') }
    it { should have_content(@p.name) }

    describe "index with no users" do
      it { should_not have_content('добавить запись') }
      it { should_not have_link('удалить') }
      it { should_not have_link('изменить') }
    end

    describe "index with no-admin users" do 
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        sign_in user
        visit prices_path
      end

      it { should_not have_content('добавить запись') }
      it { should_not have_link('удалить') }
      it { should_not have_link('изменить') }
    end

    describe "index with admin users" do 
      let(:user) { FactoryGirl.create(:admin) }
      before do
        sign_in user
        visit prices_path
      end
      
      it { should have_link('добавить запись', href: new_price_path) }
      it { should have_link('удалить', href: price_path(@p.id)) }
      it { should have_link('изменить', href: edit_price_path(@p.id)) }
      it { should have_content("id = #{ @p.id }") }

      describe "click delete link" do

        it "should be able to delete another price" do
          expect do
            click_link('удалить', match: :first)
          end.to change(Price, :count).by(-1)
        end

      end #"click delete link"

    end #"index with admin users"

  end

  describe "visit new page" do

    describe "with no-signed user" do
      before { visit new_price_path }

      it { should have_title('Главная') }
    end #"with no-signed user"   

    describe "with signed in user" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit new_price_path
      end

      it { should have_title('Главная') }
    end #"with signed in user"

    describe "with admin" do
      let(:user) { FactoryGirl.create(:admin) }
      let(:submit) { "Сохранить" }
      before do
        sign_in user
        visit new_price_path
      end

      it { should have_title(full_title('Новая услуга')) }
      it { should have_content('Ввод новой услуги') }

      describe "create a new price with invalid information" do
        it "should not create a price" do
          expect { click_button submit }.not_to change(Price, :count)
        end

      end #"create a new price with invalid information"

      describe "create a new price with valid information" do
        before do
          fill_in "Наименование",      with: "Обследование"
          fill_in "Стоимость",        with: ""
          fill_in "Код родителя",     with: 0
        end

        it "should create a price" do
          expect { click_button submit }.to change(Price, :count).by(1)
        end

      end #"create a new price with valid information"

    end # "with admin" 
    
  end #"visit new page" 

  describe "visit edit page" do

    describe "with no-signed user" do
      before { visit edit_price_path(@p.id) }

      it { should have_title('Главная') }
    end #"with no-signed user"

    describe "with signed in user" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit edit_price_path(@p.id)
      end

      it { should have_title('Главная') }
    end #"with signed in user"

    describe "with admin" do
      let(:user) { FactoryGirl.create(:admin) }
      let(:submit) { "Сохранить" }
      before do
        sign_in user
        visit edit_price_path(@p.id)
      end

      it { should have_title(full_title('Редактироваие услуги')) }
      it { should have_content('Редактироваие услуги') }

      describe "save changes with invalid information" do
        before do 
          fill_in "Наименование",  with: " "
          click_button submit
        end

        it { should have_content('error') }
      end #"save changes with invalid information"

      describe "save changes with valid information" do
        let(:new_name)  { "Обследование" }
        let(:new_cost)  { "500р" }
        before do
          fill_in "Наименование",     with: new_name
          fill_in "Стоимость",        with: new_cost
          fill_in "Код родителя",     with: 0
          click_button submit
        end

        it { should have_title('Стоимость услуг') }
        it { should have_selector('div.alert.alert-success') }
        it { should have_content("Обследование") }
        specify { expect(@p.reload.name).to  eq new_name }
        specify { expect(@p.reload.cost).to eq new_cost }
      end #"save changes with valid information"

    end #"with admin"

  end #"visit edit page"


end #"Price pages" 