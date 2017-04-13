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
    "&section=#{p_section}"\
    '&venuePhotos=1'
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
      photo_url_prefix = v['photos']['groups'].first['items'].first['prefix']
      photo_url_suffix = v['photos']['groups'].first['items'].first['suffix']
      photo_url = "#{photo_url_prefix}300x300#{photo_url_suffix}"

      categs = []
       categories.each do |c|
        categs << Category.new(c['id'], c['name'])
      end
      new_place = Place.new(id, name, address, lat, lng, distance, categs, photo_url)
      # puts new_place.inspect
      places << new_place
    end

    # render JSON.pretty_generate(some_data)
    render json: places

  end

  def random
    # params.permit(:lat, :lng, :categories)
    p_latitude = params[:lat]
    p_longitude = params[:lng]
    p_radius = params[:radius]


    url = 'https://api.foursquare.com/v2/venues/explore'\
    "?ll=#{p_latitude},#{p_longitude}"\
    '&client_id=NU54NGRVGGQQ2BDSTBGWVQ3LLP44USMS3AP4A1IBQXYFG5RD'\
    '&client_secret=SD3LOHWHYN04KDUU0CB1HPNASPXTKAKB10QJQZTJ1PMDYWST'\
    '&v=20170405'\
    "&radius=#{p_radius}"\
    "&section=topPicks"\
    '&venuePhotos=1'
    puts url
    response = Net::HTTP.get_response(URI.parse(url))



    obj = JSON.parse(response.body)
    venues = []
    obj['response']['groups'].first['items'].each do |i|
      venues << i['venue']
    end
    # venues = obj['response']['venues']

    places = []
    v =  venues.sample

    id = v['id']
    name = v['name']
    address = v['location']['address']
    lat = v['location']['lat']
    lng = v['location']['lng']
    distance = v['location']['distance']
    categories = v['categories']
    photo_url_prefix = v['photos']['groups'].first['items'].first['prefix']
    photo_url_suffix = v['photos']['groups'].first['items'].first['suffix']
    photo_url = "#{photo_url_prefix}300x300#{photo_url_suffix}"

    categs = []
    categories.each do |c|
        categs << Category.new(c['id'], c['name'])
    end
    new_place = Place.new(id, name, address, lat, lng, distance, categs, photo_url)
    places << new_place

    # render JSON.pretty_generate(some_data)
    render json: places
  end

  def find_by_category
    p_latitude = params[:lat]
    p_longitude = params[:lng]
    p_radius = params[:radius]
    p_category = params[:category]

    categoryId = 'no_category'
    if(p_category == "historic") #Historic Site
      categoryId = '4deefb944765f83613cdba6e'
    end

    url = 'https://api.foursquare.com/v2/venues/explore'\
    "?ll=#{p_latitude},#{p_longitude}"\
    '&client_id=NU54NGRVGGQQ2BDSTBGWVQ3LLP44USMS3AP4A1IBQXYFG5RD'\
    '&client_secret=SD3LOHWHYN04KDUU0CB1HPNASPXTKAKB10QJQZTJ1PMDYWST'\
    '&v=20170405'\
    "&radius=#{p_radius}"\
    "&categoryId=#{categoryId}"\
    '&venuePhotos=1'
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
      photo_url_prefix = v['photos']['groups'].first['items'].first['prefix']
      photo_url_suffix = v['photos']['groups'].first['items'].first['suffix']
      photo_url = "#{photo_url_prefix}300x300#{photo_url_suffix}"

      categs = []
       categories.each do |c|
        categs << Category.new(c['id'], c['name'])
      end
      new_place = Place.new(id, name, address, lat, lng, distance, categs, photo_url)
      # puts new_place.inspect
      places << new_place
    end

    # render JSON.pretty_generate(some_data)
    render json: places
  end

end

class Place
  attr_accessor :id, :name, :address, :lat, :lng, :distance, :categories, :photo_url

  def initialize(id, name, address, lat, lng, distance, categories, photo_url)
    @id = id
    @name = name
    @address = address
    @lat = lat
    @lng = lng
    @distance = distance
    @categories = categories
    @photo_url = photo_url
  end
end

class Category
  attr_accessor :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

end
