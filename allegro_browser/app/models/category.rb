class Category < Ohm::Model
	attribute :name
	reference :parent, :Category

	def to_hash
		super.merge(name: name, parent_id: parent_id)
	end

	def self.delete_all
		Category.all.each { |c| c.delete }
	end
end
