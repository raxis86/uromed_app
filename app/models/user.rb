class User < ActiveRecord::Base
	#before_save { self.email = email.downcase } или можно так:
	before_save { email.downcase! }
	before_create :create_remember_token, :create_confirm_token
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
			  uniqueness: { case_sensitive: false }
	has_secure_password
  	validates :password, length: { minimum: 6 }

  	def User.new_token
  		SecureRandom.urlsafe_base64
  	end

  	def User.encrypt(token)
  		Digest::SHA1.hexdigest(token.to_s)
  	end

    def email_activate
      self.email_confirmed = true
      self.confirm_token = nil
      save!(:validate => false)
    end

  	private

  		def create_remember_token
  			self.remember_token = User.encrypt(User.new_token)
  		end

      def create_confirm_token
        if self.confirm_token.blank?
          self.confirm_token = User.encrypt(User.new_token)
        end
      end
end
