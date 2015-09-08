module ApplicationHelper
	def full_title(page_title)
    	base_title = "Сайт лечебно-консультативного центра УРОМЕД"
    	if page_title.empty?
      		base_title
    	else
      		"#{base_title} | #{page_title}"
    	end
  	end
end
