# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Name.create([{name: "Lorena", lat: 41.8897166, lng:  -87.6378000, group_id: 1},
            {name: "Matt", lat: 41.8897200, lng:  -87.6379000, group_id: 1},
            {name: "Niki", lat: 41.8897220, lng:  -87.6376000, group_id: 1},
            {name: "Eileen", lat: 41.8897240, lng:  -87.6375000, group_id: 1}])

Group.create([{name: "Where you at"}])
