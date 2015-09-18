class PricesController < ApplicationController
	before_action :signed_in_admin, only: [:new, :create, :edit, :update]

	def index
		@prices = Price.all
	end

	def new
		@price = Price.new
	end

	def create
		@price = Price.new(price_params)
		if @price.save
			redirect_to prices_path
		else
			render 'new'
		end
	end

	def edit
		@price = Price.find(params[:id])
	end

	def update
		@price = Price.find(params[:id])
		if @price.update_attributes(price_params)
			flash[:success] = "Услуга с id = #{params[:id]} успешно изменена"
			redirect_to prices_path
		else
			render 'edit'
		end
	end

	def destroy
		prdel = Price.find(params[:id]).id
    	Price.find(params[:id]).destroy
    	flash[:success] = "Услуга id = #{prdel} удалена!"
    	redirect_to prices_url
	end

	private
	    def price_params
      		params.require(:price).permit(:name, :cost, :parentid)
    	end


		#before filtres
		def signed_in_admin
			if signed_in?
      			redirect_to(root_url) unless current_user.admin?
      		else
      			redirect_to(root_url)
      		end
    	end
end
