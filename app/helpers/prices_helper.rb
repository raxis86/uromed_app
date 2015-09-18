module PricesHelper

	def tree pr, pid
		$x = {}
		$deep = 0
		$i = 0

		def btree price, parentid
			$deep += 1
			price.each do |p|
				if p.parentid == parentid
					$x[$i] = { hilevel: $deep, name: p.name, cost: p.cost, id: p.id }	
					$i += 1
					btree price, p.id
				end
			end
			$deep -= 1
		end
		
		btree pr, pid
		return $x
	end

end
