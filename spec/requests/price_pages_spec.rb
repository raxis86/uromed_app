require 'spec_helper'

describe "Price pages" do

  subject { page }

  describe "index" do

    describe "index with no users" do
      before { visit prices_path }

      it { should have_title(full_title('Стоимость услуг'))}
    end

    #describe "index with no-admin users" do 
    #  let(:user) { FactoryGirl.create(:user) }
    #  before(:each) do
    #    sign_in user
    #    visit prices_path
    #  end

    #  it { should have_title('Стоимость услуг') }
      #it { should have_content('Все пользователи') }
    #end

  end

end