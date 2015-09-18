require 'spec_helper'

describe "Price pages" do

  subject { page }

  describe "index" do

    let(:price) { FactoryGirl.create(:price) }
    before { visit prices_path }

    it { should have_title(full_title('Стоимость услуг'))}
    it { should have_content('Стоимость услуг') }

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
      before(:each) do
        sign_in user
        visit prices_path
      end
      
      it { should have_content('добавить запись', href: new_price_path) }
      it { should have_link('удалить', href: price_path(Price.first)) }
      it { should have_link('изменить', href: price_path(Price.first)) }
    end

  end

end