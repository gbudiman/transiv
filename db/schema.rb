# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_18_204653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "transit_agencies", force: :cascade do |t|
    t.string "gtfs_id", null: false
    t.string "handle", null: false
    t.index ["gtfs_id"], name: "index_transit_agencies_on_gtfs_id", unique: true
  end

  create_table "transit_routes", force: :cascade do |t|
    t.string "gtfs_id", null: false
    t.bigint "transit_agency_id"
    t.string "shorthand"
    t.string "handle", null: false
    t.integer "route_type", null: false
    t.string "bg_color"
    t.string "fg_color"
    t.index ["gtfs_id"], name: "index_transit_routes_on_gtfs_id"
    t.index ["transit_agency_id", "gtfs_id"], name: "index_transit_routes_on_transit_agency_id_and_gtfs_id", unique: true
    t.index ["transit_agency_id"], name: "index_transit_routes_on_transit_agency_id"
  end

  create_table "transit_services", force: :cascade do |t|
    t.string "gtfs_id", null: false
    t.boolean "is_mon", null: false
    t.boolean "is_tue", null: false
    t.boolean "is_wed", null: false
    t.boolean "is_thu", null: false
    t.boolean "is_fri", null: false
    t.boolean "is_sat", null: false
    t.boolean "is_sun", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
  end

  create_table "transit_shapes", force: :cascade do |t|
    t.string "gtfs_id", null: false
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.integer "sequence_id", null: false
    t.index ["gtfs_id", "sequence_id"], name: "index_transit_shapes_on_gtfs_id_and_sequence_id", unique: true
    t.index ["lonlat"], name: "index_transit_shapes_on_lonlat", using: :gist
  end

  create_table "transit_stop_times", force: :cascade do |t|
    t.bigint "transit_stop_id"
    t.bigint "transit_trip_id"
    t.integer "arrival", null: false
    t.integer "departure", null: false
    t.integer "sequence", null: false
    t.string "handle", null: false
    t.index ["transit_stop_id"], name: "index_transit_stop_times_on_transit_stop_id"
    t.index ["transit_trip_id"], name: "index_transit_stop_times_on_transit_trip_id"
  end

  create_table "transit_stops", force: :cascade do |t|
    t.string "gtfs_id", null: false
    t.string "handle", null: false
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.bigint "parent_station_id"
    t.integer "stop_type", null: false
    t.index ["lonlat"], name: "index_transit_stops_on_lonlat", using: :gist
    t.index ["parent_station_id"], name: "index_transit_stops_on_parent_station_id"
  end

  create_table "transit_trip_calendars", force: :cascade do |t|
    t.bigint "transit_trip_id"
    t.bigint "transit_calendar_id"
    t.index ["transit_calendar_id"], name: "index_transit_trip_calendars_on_transit_calendar_id"
    t.index ["transit_trip_id"], name: "index_transit_trip_calendars_on_transit_trip_id"
  end

  create_table "transit_trip_shapes", force: :cascade do |t|
    t.bigint "transit_trip_id"
    t.bigint "transit_shape_id"
    t.index ["transit_shape_id"], name: "index_transit_trip_shapes_on_transit_shape_id"
    t.index ["transit_trip_id"], name: "index_transit_trip_shapes_on_transit_trip_id"
  end

  create_table "transit_trip_stop_times", force: :cascade do |t|
    t.bigint "transit_trip_id"
    t.bigint "transit_stop_time_id"
    t.index ["transit_stop_time_id"], name: "index_transit_trip_stop_times_on_transit_stop_time_id"
    t.index ["transit_trip_id"], name: "index_transit_trip_stop_times_on_transit_trip_id"
  end

  create_table "transit_trips", force: :cascade do |t|
    t.string "gtfs_id", null: false
    t.bigint "transit_route_id"
    t.bigint "transit_service_id"
    t.bigint "transit_shape_id"
    t.integer "direction", null: false
    t.string "block", null: false
    t.string "headsign"
    t.index ["gtfs_id"], name: "index_transit_trips_on_gtfs_id"
    t.index ["transit_route_id"], name: "index_transit_trips_on_transit_route_id"
    t.index ["transit_service_id"], name: "index_transit_trips_on_transit_service_id"
    t.index ["transit_shape_id"], name: "index_transit_trips_on_transit_shape_id"
  end

end
