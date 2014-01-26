# -*- coding: utf-8 -*-
# http://blog.livedoor.jp/techblog/archives/65836960.html
require 'grn_mini'

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
end

