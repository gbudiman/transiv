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

ActiveRecord::Schema.define(version: 2018_09_25_191340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "transit_agencies", force: :cascade do |t|
    t.string "gtfs_id", null: false
    t.string "handle", null: false
    t.string "live_feed"
    t.index ["gtfs_id"], name: "index_transit_agencies_on_gtfs_id", unique: true
  end

  create_table "transit_predictions", force: :cascade do |t|
    t.bigint "transit_trip_id"
    t.bigint "transit_stop_id"
    t.integer "predictions", null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transit_stop_id", "transit_trip_id"], name: "unique_prediction_stop_trip_constraint", unique: true
    t.index ["transit_stop_id"], name: "index_transit_predictions_on_transit_stop_id"
    t.index ["transit_trip_id", "transit_stop_id"], name: "precition_trip_stop"
    t.index ["transit_trip_id"], name: "index_transit_predictions_on_transit_trip_id"
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
    t.index ["gtfs_id"], name: "index_transit_services_on_gtfs_id", unique: true
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
    t.index ["transit_stop_id", "transit_trip_id", "departure"], name: "unique_transit_stop_time_constraint", unique: true
    t.index ["transit_stop_id"], name: "index_transit_stop_times_on_transit_stop_id"
    t.index ["transit_trip_id"], name: "index_transit_stop_times_on_transit_trip_id"
  end

  create_table "transit_stops", force: :cascade do |t|
    t.string "gtfs_id", null: false
    t.string "handle", null: false
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.bigint "parent_station_id"
    t.integer "stop_type", null: false
    t.index ["gtfs_id"], name: "index_transit_stops_on_gtfs_id", unique: true
    t.index ["lonlat"], name: "index_transit_stops_on_lonlat", using: :gist
    t.index ["parent_station_id"], name: "index_transit_stops_on_parent_station_id"
  end

  create_table "transit_trips", force: :cascade do |t|
    t.string "gtfs_id", null: false
    t.bigint "transit_route_id"
    t.bigint "transit_service_id"
    t.bigint "transit_shape_id"
    t.integer "direction", null: false
    t.string "block", null: false
    t.string "headsign"
    t.index ["block"], name: "index_transit_trips_on_block"
    t.index ["gtfs_id"], name: "index_transit_trips_on_gtfs_id"
    t.index ["transit_route_id", "gtfs_id", "direction"], name: "unique_transit_trip_constraint", unique: true
    t.index ["transit_route_id"], name: "index_transit_trips_on_transit_route_id"
    t.index ["transit_service_id"], name: "index_transit_trips_on_transit_service_id"
    t.index ["transit_shape_id"], name: "index_transit_trips_on_transit_shape_id"
  end

  add_foreign_key "transit_routes", "transit_agencies", name: "transit_routes_transit_agency_id_fk"
  add_foreign_key "transit_stop_times", "transit_stops", name: "transit_stop_times_transit_stop_id_fk"
  add_foreign_key "transit_stop_times", "transit_trips", name: "transit_stop_times_transit_trip_id_fk"
  add_foreign_key "transit_trips", "transit_routes", name: "transit_trips_transit_route_id_fk"
  add_foreign_key "transit_trips", "transit_services", name: "transit_trips_transit_service_id_fk"
  add_foreign_key "transit_trips", "transit_shapes", name: "transit_trips_transit_shape_id_fk"
end
