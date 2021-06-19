require "open-uri"
require "nokogiri"
require_relative "property"

class ScrapeUrbanZoomService
  def initialize(input)
    @flattype = @property.flat_type.first
    @floornum = @property.floor
    @unitnum = @property.unit
    @areasqm = @property.area
    @postalcode = @property.address
  end

  def call
    url = "https://www.urbanzoom.com/house?flatType=#{flattype}%20ROOM&floorNum=#{floornum}&unitNum=#{unitnum}&areaInSqm=#{areasqm}&ref=home-search&housingType=public&postalCode=#{postalcode}"
    html = open(url).read
    # 1. Parse HTML
    doc = Nokogiri::HTML(html, nil, "utf-8")
    # 2. For the first five results
    results = []
    doc.search(".fixed-recipe-card").first(5).each do |element|
      # 3. Create recipe and store it in results
      name = element.search(".fixed-recipe-card__title-link").first.text.strip
      description = element.search(".fixed-recipe-card__description").first.text.strip
      rating = element.search(".stars.stars-5").first.attribute("data-ratingstars").value
      recipe_url = element.search(".fixed-recipe-card__title-link").first.attribute("href").value
      recipe_html = open(recipe_url).read
      recipe_doc = Nokogiri::HTML(recipe_html, nil, "utf-8")
      prep_time = recipe_doc.search(".recipe-meta-item-body").first.text.strip
      results << Recipe.new(name: name, description: description, rating: rating, prep_time: prep_time)
    end
    results
  end
end