# -*- coding: utf-8 -*-

# [Usage]
# 1. Download from http://blog.livedoor.jp/techblog/archives/65836960.html
# 2. Extract ldgourmet.tar.gz
# 3. $ ruby restaurants.rb /path/to/ldgourmet/

require 'grn_mini'
require 'csv'

GrnMini::create_or_open("restaurants.db")
restaurants = GrnMini::Hash.new("Restaurants")
ratings     = GrnMini::Hash.new("Ratings")

if restaurants.size == 0 && ratings.size == 0
  restaurants.setup_columns(name:                   "レストラン",
                            property:               "",
                            alphabet:               "RESTAURANT",
                            name_kana:              "れすとらん",
                            zip:                    "111-1111",
                            address:                "東京都東京区1111",
                            # north_latitude:         xxx,
                            # east_longitude:         xxx,
                            description:            "詳細",
                            open_morning:           false,
                            open_lunch:             false,
                            open_late:              false,
                            photo_count:            0,
                            special_count:          0,
                            menu_count:             0,
                            fan_count:              0,
                            access_count:           0,
                            created_on:             Time.new,
                            modified_on:            Time.new,
                            closed:                 false,
                            )

  ratings.setup_columns(restaurant_id:    restaurants,
                        total:            0,
                        food:             0,
                        service:          0,
                        atmosphere:       0,
                        cost_performance: 0,
                        title:            "タイトル",
                        body:             "コメント",
                        created_on:       Time.now,
                        )

  CSV.foreach(File.join(ARGV[0], 'restaurants.csv'), headers: true) do |row|
    restaurants[row[0]] = {
      name:                   row[1],
      property:               row[2],
      alphabet:               row[3],
      name_kana:              row[4],
      zip:                    row[21],
      address:                row[22],
      # north_latitude:         xxx,
      # east_longitude:         xxx,
      description:            row["description"],
      open_morning:           row["open_morning"],
      open_lunch:             row["open_lunch"],
      open_late:              row["open_late"],
      photo_count:            row["photo_count"],
      special_count:          row["special_count"],
      menu_count:             row["menu_count"],
      fan_count:              row["fan_count"],
      access_count:           row["access_count"],
      created_on:             row["created_on"],
      modified_on:            row["modified_on"],
      closed:                 row["closed"],
    }
  end

  CSV.foreach(File.join(ARGV[0], 'ratings.csv'), headers: true) do |row|
    ratings[row[0]] = {
      restaurant_id:    row[1],
      total:            row[3],
      food:             row[4],
      service:          row[5],
      atmosphere:       row[6],
      cost_performance: row[7],
      title:            row[8],
      body:             row[9],
      created_on:       row[11],
    }
  end
  
end

# ratings.each do |a|
#   p a.attributes
# end

p restaurants['310595'].attributes
p restaurants['10237'].attributes

# p ratings['66111'].attributes

# p restaurants[1].attributes
# p restaurants[4].attributes
# p restaurants[2583].attributes
# p restaurants[2583-1].attributes
# p restaurants[156445].attributes
# p restaurants[156445-1].attributes

restaurants.select("address:@新宿 name:@ラーメン name:@九州").each do |record|
  p record.attributes
end

# ratings.select("body:@びっくり body:@ラーメン body:@味噌 body:@醤油").each do |record|
#   p [record.title, record.restaurant_id.name]
# end

# ratings.select("restaurant_id.name:@大将").each do |record|
#   p record.restaurant_id.name
# end

restaurants.sort([{key: "fan_count", order: :desc}, {key: "access_count", order: :desc}]).take(10).each do |r|
  p [r.name, r.access_count, r.fan_count]
end
