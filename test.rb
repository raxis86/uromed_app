tree = {}
tree[1] = { parentid: 0, name: "razd1" }
tree[2] = { parentid: 0, name: "razd2" }
tree[3] = { parentid: 0, name: "razd3" }
tree[4] = { parentid: 1, name: "razd1.1" }
tree[5] = { parentid: 1, name: "razd1.2" }
tree[6] = { parentid: 4, name: "razd1.1.1" }
tree[7] = { parentid: 2, name: "razd2.1" }
tree[8] = { parentid: 2, name: "razd2.2" }
tree[9] = { parentid: 3, name: "razd3.1" }

#tree = {}
#tree[1] = { parentid: 0, name: "razd1" }
#tree[2] = { parentid: 0, name: "razd2" }
#tree[4] = { parentid: 1, name: "razd1.1" }
#tree[6] = { parentid: 4, name: "razd1.1.1" }
#tree[7] = { parentid: 2, name: "razd2.1" }

def btree tree, parentid
	print "\n<ul>\n"	
	tree.each do |key,value|
		if value[:parentid] == parentid
			print "<li>#{value[:name]} #{value[:parentid]}"		
			if tree.find { |k,v| v[:parentid]==key } 
				btree tree, key
			end
			print "</li>\n"
		end
	end
	print "</ul>\n"
end

btree tree,0

