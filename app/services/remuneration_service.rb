class RemunerationService
  def self.create_remuneration_for_month(month)
    profits = Order.profit_of_month(month)
    total_ars = profits[:total_ars]
    total_usd = profits[:total_usd]
    average_rate = DollarService.average_dollar_price(month)

    date = Date.parse("#{month}-01")
    year = date.year

    existing_remuneration = Remuneration.where(date: date.beginning_of_month..date.end_of_month).first
    if existing_remuneration.present?
      existing_remuneration.update(amount_ars: total_ars, amount_usd: total_usd, exchange_rate: average_rate)
      return
    end

    remuneration = Remuneration.new(amount_ars: total_ars, amount_usd: total_usd, date: Date.parse("#{month}-01"), exchange_rate: average_rate)

    parent = Remuneration.search_parent(year)

    if parent.present?
      remuneration.parent = parent
      remuneration.save
    else
      if date.month == 1
        remuneration.save
      else
        raise 'No se puede crear una remuneración sin un padre'
      end
    end
  end
end
