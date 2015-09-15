require 'spec_helper'

describe "StaticPages" do

	let(:base_title) { "Сайт лечебно-консультативного центра УРОМЕД" }
  
  	describe "Home page" do
    	it "should have the content 'Спасибо, что посетили наш сайт!'" do
      		visit root_path
      		expect(page).to have_content('Спасибо, что посетили наш сайт!')
    	end

    	it "should have the right title" do
  			visit root_path
  			expect(page).to have_title("#{base_title} | Главная")
		end
	end

	describe "about page" do
		it "should have the right title" do
  			visit about_path
  			expect(page).to have_title("#{base_title} | Деятельность")
		end
	end

	describe "contacts page" do
		it "should have the right title" do
  			visit contacts_path
  			expect(page).to have_title("#{base_title} | Контакты")
		end
	end

	describe "other page" do
		it "should have the right title" do
  			visit other_path
  			expect(page).to have_title("#{base_title} | Полезная информация")
		end
  	end

end
