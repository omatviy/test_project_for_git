require 'open-uri'
require 'nokogiri'
require 'csv'
url = 'https://rozetka.com.ua/mobile-phones/c80003/'
file = "file.csv"
class Parser
  attr_accessor :content

  def initialize
    @content=""
  end
  
  def get_data_write_to_csv(url, file_name)
    html = open(url) { |result| result.read }
    @content = Nokogiri::HTML(html)
    CSV.open(file_name, "w+") do |csv|
      csv << ["Товар", "Ціна"]
      @content.css("div.goods-tile__inner").each do  |item|
        begin
        title = get_title(item)
        price = get_price(item) + " грн"
        csv << [title, price]
        rescue
        end
      end
    end
  end
  def get_price(item)
    item.css("span.goods-tile__price-value").text.strip
  end
  def get_title(item)
    item.css("span.goods-tile__title").text.strip
  end
end
parser_object = Parser.new
parser_object.get_data_write_to_csv(url, file)