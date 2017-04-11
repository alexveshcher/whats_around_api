require 'uri'
require 'net/http'
require 'net/https'
require 'json'

class TestsController < ApplicationController
  def try
    params.permit(:lat, :lng)
    latitude = params[:lat]
    longitude = params[:lng]
    # params[:lat, :lng]
    response = Net::HTTP.get_response(URI.parse("https://api.foursquare.com/v2/venues/search?ll=#{latitude},#{longitude}&client_id=NU54NGRVGGQQ2BDSTBGWVQ3LLP44USMS3AP4A1IBQXYFG5RD&client_secret=SD3LOHWHYN04KDUU0CB1HPNASPXTKAKB10QJQZTJ1PMDYWST&v=20170405&radius=1200"))
    puts "LINK: https://api.foursquare.com/v2/venues/search?ll=#{latitude},#{longitude}&client_id=NU54NGRVGGQQ2BDSTBGWVQ3LLP44USMS3AP4A1IBQXYFG5RD&client_secret=SD3LOHWHYN04KDUU0CB1HPNASPXTKAKB10QJQZTJ1PMDYWST&v=20170405&radius=1200"
    # puts response.body
    # json = File.read('foursquare.json')
    obj = JSON.parse(response.body)
    venues = obj['response']['venues']

    places = []
    venues.each do |v|
      id = v['id']
      name = v['name']
      address = v['location']['address']
      lat = v['location']['lat']
      lng = v['location']['lng']
      distance = v['location']['distance']
      categories = v['categories']

      categs = []
       categories.each do |c|
        categs << Category.new(c['id'], c['name'])
      end

      places << Place.new(id, name, address, lat, lng, distance, categs)
    end

    render json: places
  end


  def find_by_section
    # params.permit(:lat, :lng, :categories)
    p_latitude = params[:lat]
    p_longitude = params[:lng]
    p_section = params[:section]



    url = 'https://api.foursquare.com/v2/venues/explore'\
    "?ll=#{p_latitude},#{p_longitude}"\
    '&client_id=NU54NGRVGGQQ2BDSTBGWVQ3LLP44USMS3AP4A1IBQXYFG5RD'\
    '&client_secret=SD3LOHWHYN04KDUU0CB1HPNASPXTKAKB10QJQZTJ1PMDYWST'\
    '&v=20170405'\
    '&radius=15000'\
    "&section=#{p_section}"
    puts url
    response = Net::HTTP.get_response(URI.parse(url))



    obj = JSON.parse(response.body)
    venues = []
    obj['response']['groups'].first['items'].each do |i|
      venues << i['venue']
    end
    # venues = obj['response']['venues']

    places = []
    venues.each do |v|
      id = v['id']
      name = v['name']
      address = v['location']['address']
      lat = v['location']['lat']
      lng = v['location']['lng']
      distance = v['location']['distance']
      categories = v['categories']

      categs = []
       categories.each do |c|
        categs << Category.new(c['id'], c['name'])
      end
      new_place = Place.new(id, name, address, lat, lng, distance, categs)
      # puts new_place.inspect
      places << new_place
    end

    # render JSON.pretty_generate(some_data)
    render json: places

  end
end

class Place
  attr_accessor :id, :name, :address, :lat, :lng, :distance, :categories

  def initialize(id, name, address, lat, lng, distance, categories)
    @id = id
    @name = name
    @address = address
    @lat = lat
    @lng = lng
    @distance = distance
    @categories = categories
  end
end

class Category
  attr_accessor :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

end
