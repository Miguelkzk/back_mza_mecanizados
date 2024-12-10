# Creación de clientes
client1 = Client.create(name: 'Siemens')
client2 = Client.create(name: 'Cliente 2')
client3 = Client.create(name: 'Petrobras')
client4 = Client.create(name: 'Techint')
client5 = Client.create(name: 'Tenaris')
client6 = Client.create(name: 'Cargill')
client7 = Client.create(name: 'Aluar')

# Función para generar fechas distribuidas en el año 2023
def random_date_in_2023
  start_date = Date.new(2023, 1, 1)
  end_date = Date.new(2023, 12, 31)
  rand(start_date..end_date)
end

# Crear órdenes
clients = [client1, client2, client3, client4, client5, client6, client7]
states = ['delivered_and_invoiced']
currencies = ['ars', 'usd']

60.times do |i|
  ingresed_at = random_date_in_2023
  estimated_delivery_date = ingresed_at + rand(15..90).days
  delivery_at = estimated_delivery_date + rand(1..15).days

  order = Order.new(
    name: "Producto #{i + 1} - #{%w[algun laburo].sample}",
    purchase_order: "#{rand(100000..999999)}",
    quantity: rand(5..50),
    ingresed_at: ingresed_at,
    estimated_delivery_date: estimated_delivery_date,
    delivery_at: delivery_at,
    unit_price: rand(500..5000),
    state: 'delivered_and_invoiced',
    currency: currencies.sample
  )
  order.client = clients.sample
  order.save!
end
