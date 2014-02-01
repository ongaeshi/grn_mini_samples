# -*- coding: utf-8 -*-

# [Usage]
# 1. Download from http://blog.livedoor.jp/techblog/archives/65836960.html
# 2. Extract ldgourmet.tar.gz
# 3. $ ruby restaurants.rb /path/to/ldgourmet/ (Create database)
# 4. $ ruby restaurants.rb 'ラーメン とんこつ' (Search from database)

require 'grn_mini'
require 'csv'

GrnMini::create_or_open("restaurants.db")
restaurants = GrnMini::Hash.new("Restaurants")
ratings     = GrnMini::Hash.new("Ratings")

if restaurants.size == 0
  if ARGV.empty?
    puts "restaurants.rb [input_dir]"
    exit
  end

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

  puts "Input restaurants.."

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
      description:            row[25],
      open_morning:           row[27],
      open_lunch:             row[28],
      open_late:              row[29],
      photo_count:            row[30],
      special_count:          row[31],
      menu_count:             row[32],
      fan_count:              row[33],
      access_count:           row[34],
      created_on:             row[35],
      modified_on:            row[36],
      closed:                 row[37],
    }
  end
  
  puts "Input ratings.."

  CSV.foreach(File.join(ARGV[0], 'ratings.csv'), headers: true) do |row|
    begin
      created_on = Time.parse(row[11])
    rescue ArgumentError
      created_on = Time.at(0)
    end

    ratings[row[0]] = {
      restaurant_id:    row[1],
      total:            row[3],
      food:             row[4],
      service:          row[5],
      atmosphere:       row[6],
      cost_performance: row[7],
      title:            row[8],
      body:             row[9],
      created_on:       created_on,
    }
  end
  
  puts "Input complete : #{restaurants.size} restaurants, #{ratings.size} ratings."

else
  # Search
  unless ARGV.empty?
    unless ARGV[0] == "-r"
      # Search name, address
      query = ARGV.map { |arg|
        "(" +
        "name:@#{arg}" +
        " OR name_kana:@#{arg}" +
        " OR address:@#{arg}" + 
        ")"
      }.join(" ")

      results = restaurants.select(query)
      
      results = results.sort([{key: "fan_count", order: :desc}, {key: "access_count", order: :desc}])

      results.take(20).each do |record|
        puts "#{record.name} - #{record.address}"
      end
    else
      # Search review
      ARGV.shift
      
      query = ARGV.map { |arg|
        "(" +
        "title:@#{arg}" +
        " OR body:@#{arg}" + 
        ")"
      }.join(" ")

      # p query

      results = ratings.select(query)
      snippet = GrnMini::Util::text_snippet_from_selection_results(results)

      results = results.sort([{key: "restaurant_id.fan_count", order: :desc}, {key: "restaurant_id.access_count", order: :desc}])

      results.take(20).each do |record|
        puts "--- #{record.restaurant_id.name} - #{record.restaurant_id.address} ---"
        snippet.execute(record.body).each do |segment|
          puts segment.gsub("\n", "")
        end
      end
    end
  end
end

