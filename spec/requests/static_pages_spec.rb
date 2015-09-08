require 'spec_helper'

describe "StaticPages" do
  
  	describe "Home page" do
    	it "should have the content 'Спасибо, что посетили наш сайт!'" do
      		visit '/static_pages/home'
      		expect(page).to have_content('Спасибо, что посетили наш сайт!')
    	end

    	it "should have the right title" do
  			visit '/static_pages/home'
  			expect(page).to have_title("Сайт лечебно-консультативного центра УРОМЕД | Главная")
		end
	end

	describe "about page" do
		it "should have the right title" do
  			visit '/static_pages/about'
  			expect(page).to have_title("Сайт лечебно-консультативного центра УРОМЕД | Деятельность")
		end
	end

	describe "contacts page" do
		it "should have the right title" do
  			visit '/static_pages/contacts'
  			expect(page).to have_title("Сайт лечебно-консультативного центра УРОМЕД | Контакты")
		end
	end

	describe "other page" do
		it "should have the right title" do
  			visit '/static_pages/other'
  			expect(page).to have_title("Сайт лечебно-консультативного центра УРОМЕД | Полезная информация")
		end
  	end
  	
end
