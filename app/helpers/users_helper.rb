module UsersHelper

	#Возращает аватарку (граватар http://gravatar.com/) для user-а
	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		image_tag(gravatar_url, alt: "", class: "gravatar")
	end
end
