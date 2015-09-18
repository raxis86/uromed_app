class Price < ActiveRecord::Base
	validates :parentid, presence: true
end
