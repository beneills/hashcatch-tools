require "#{File.dirname(__FILE__)}/amazon.rb"


# Schema -> Amazon mapping
$schema_mapping = {
  :amazon_small_image => 'SmallImage/URL',
  :amazon_medium_image => 'MediumImage/URL',
  :amazon_author => 'ItemAttributes/Author',
  :amazon_artist => 'ItemAttributes/Artist',
  :amazon_title => 'ItemAttributes/Title',
  :amazon_associate_url => 'ItemLinks/ItemLink/URL',
}


def perform_update(asin, rails_entry)
  res = Amazon::Ecs.item_lookup(asin, {"ResponseGroup" => "Small,Images"})
  item = res.items.first
  if item.nil?
    puts "Could not find Amazon Product with ASIN: #{asin}!"
    return
  end

  data = { :amazon_asin => asin }
  $schema_mapping.each do |column, amazon_path|
    data[column] = item.get(amazon_path)
  end

  puts "Updating: #{asin}"
  rails_entry.update(data)
  rails_entry.save
end

# Assuming the row already has a correct ASIN
def perform_update_by_asin(asin)
  rails_entry = TopEntry.find_by_amazon_asin(asin)
  if rails_entry.nil?
    puts "Could not find Rails entry with ASIN: #{asin}!"
    return
  end

  perform(asin, rails_entry)
end


#perform_update_by_asin("0141182865")


