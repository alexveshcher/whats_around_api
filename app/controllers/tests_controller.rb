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
      lat = v['location']['lat']
      lng = v['location']['lng']
      distance = v['location']['distance']
      categories = v['categories']

      categs = []
       categories.each do |c|
        categs << Category.new(c['id'], c['name'])
      end

      places << Place.new(id, name, lat, lng, distance, categs)
    end

    render json: places
  end
end

class Place
  attr_accessor :id, :name, :lat, :lng, :distance, :categories

  def initialize(id, name, lat, lng, distance, categories)
    @id = id
    @name = name
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
