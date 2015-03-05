namespace :allegro_browser do

	task refresh_categories_tree: :environment do
		puts 'deleting categories stored in redis'
		Category.delete_all
		puts 'done'

		puts 'fetching categories from allegro'
		categories = Allegro.api.categories
		puts 'done'

		puts 'putting categories into redis'
		categories.map do |c|
			Category.create(id: c[:cat_id], name: c[:cat_name], parent_id: c[:cat_parent])
		end
		puts 'done'
	end
	
end
