require 'highline/import'

require "#{File.dirname(__FILE__)}/amazon.rb"
require "#{File.dirname(__FILE__)}/amazon_update.rb"


$choices = 5

def handle_choice(items, rails_entry)
  item_displays = Hash[items.map do |item|
                         key = item.get('ItemAttributes/Title')
                         [key, item]
                       end]
  
  i = choose do |menu|
    menu.prompt = "TODO? "
    menu.choices(*item_displays.keys)
    menu.choice("none")
  end

  if i == "none"
    puts "Skipping"
  else
    choice = item_displays.fetch(i)
    perform_update(choice.get('ASIN'), rails_entry)
  end
end

def perform(rails_entry)
  keyword = rails_entry.text
  
  search_index = case rails_entry.category
                 when 'book'
                   'Books'
                 when 'album'
                   'Music'
                 when 'film'
                   'Video'
                 else
                   'Blended'
                 end

  puts "Searching: #{keyword} in #{search_index}"
  res = Amazon::Ecs.item_search(keyword, {:response_group => 'Medium', :sort => 'salesrank', :search_index => search_index}) # TODO

  handle_choice(res.items.take($choices), rails_entry)
end



TopEntry.where(amazon_asin: nil).each do |e|
  perform(e)
end

