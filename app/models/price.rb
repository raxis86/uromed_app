class Price < ActiveRecord::Base
	validates :parentid, presence: true
	validates :name, presence: true
end
