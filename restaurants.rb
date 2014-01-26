# -*- coding: utf-8 -*-

# [Usage]
# 1. Download from http://blog.livedoor.jp/techblog/archives/65836960.html
# 2. Extract ldgourmet.tar.gz
# 3. $ ruby restaurants.rb /path/to/ldgourmet/

require 'grn_mini'
require 'csv'

is_create = GrnMini::create_or_open("restaurants.db")
restaurants = GrnMini::Array.new("Restaurants")

if is_create
  restaurants.setup_columns(name:                   "レストラン",
                            property:               "",
                            alphabet:               "RESTAURANT",
                            name_kana:              "れすとらん",
                            zip:                    "111-1111",
                            address:                "東京都東京区1111",
                            # north_latitude:         xxx,
                            # east_longitude:         xxx,
                            description:            "詳細",
                            # open_morning:           false,
                            # open_lunch:             false,
                            # open_late:              false,
                            photo_count:            0,
                            special_count:          0,
                            menu_count:             0,
                            fan_count:              0,
                            access_count:           0,
                            created_on:             Time.new,
                            modified_on:            Time.new,
                            # closed:                 false,
                            )

  CSV.foreach(File.join(ARGV[0], 'restaurants.csv'), headers: true) do |row|
    restaurants << {
      name:                   row[1],
      property:               row[2],
      alphabet:               row[3],
      name_kana:              row[4],
      zip:                    row[21],
      address:                row[22],
      # north_latitude:         xxx,
      # east_longitude:         xxx,
      description:            row[25],
      # open_morning:           false,
      # open_lunch:             false,
      # open_late:              false,
      # photo_count:            0,
      # special_count:          0,
      # menu_count:             0,
      # fan_count:              0,
      # access_count:           0,
      # created_on:             Time.new,
      # modified_on:            Time.new,
      # closed:                 false,
    }
  end
end

p restaurants[1].attributes

restaurants.select("address:@新宿 name:@ラーメン name:@九州").each do |record|
  p record.attributes
end

