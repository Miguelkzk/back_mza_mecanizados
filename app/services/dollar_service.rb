class DollarService
  def self.average_dollar_price(month)
    date = Date.parse("#{month}-01")
    start_at = date.beginning_of_month.strftime('%Y-%m-%d')
    end_at = date.end_of_month.strftime('%Y-%m-%d')

    uri = URI("https://mercados.ambito.com//dolar/oficial/historico-general//#{start_at}/#{end_at}")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    sales_prices = data[1..].map { |row| row[2].gsub(',', '.').to_f }
    average = sales_prices.sum / sales_prices.size
    average.round(2)
  rescue JSON::ParserError => e
    Rails.logger.error("Error al parsear la respuesta de la API: #{e.message}")
    []
  end
end
