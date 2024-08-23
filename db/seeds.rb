client1 = Client.create(name: 'IMPSA')
client2 = Client.create(name: 'WEATHERFORD')
client3 = Client.create(name: 'Techint')
client4 = Client.create(name: 'Ternium')
client5 = Client.create(name: 'Arcor')

order1 = Order.new(name: 'Valvula check HPC 15kpsi P/Servicio de PH', purchase_order: '1231231',
                   quantity: 12, ingresed_at: '12/7/2024', delivery_at: '25/12/2024', unit_price: 1231,
                   state: 'without_material', currency: 'ars')
order1.client = client1
order1.save

order2 = Order.new(name: 'Tubería de alta presión 10kpsi', purchase_order: '4564564',
                   quantity: 20, ingresed_at: '15/8/2024', delivery_at: '30/12/2024', unit_price: 1560,
                   state: 'in_progress', currency: 'usd')
order2.client = client2
order2.save

order3 = Order.new(name: 'Bomba de vacío tipo anillo líquido', purchase_order: '7897897',
                   quantity: 5, ingresed_at: '18/9/2024', delivery_at: '10/1/2025', unit_price: 2375,
                   state: 'with_material_but_not_started', currency: 'ars')
order3.client = client3
order3.save

order4 = Order.new(name: 'Generador de vapor 500kg/h', purchase_order: '1122334',
                   quantity: 3, ingresed_at: '20/10/2024', delivery_at: '15/2/2025', unit_price: 3250,
                   state: 'not_invoiced', currency: 'usd')
order4.client = client4
order4.save

order5 = Order.new(name: 'Compresor de aire 250hp', purchase_order: '2233445',
                   quantity: 8, ingresed_at: '5/11/2024', delivery_at: '20/3/2025', unit_price: 4520,
                   state: 'delivered_and_invoiced', currency: 'ars')
order5.client = client5
order5.save

order6 = Order.new(name: 'Transformador de potencia 10MVA', purchase_order: '3344556',
                   quantity: 2, ingresed_at: '1/12/2024', delivery_at: '25/4/2025', unit_price: 6875,
                   state: 'incomplete', currency: 'usd')
order6.client = client1
order6.save

order7 = Order.new(name: 'Válvula de alivio de presión 1500psi', purchase_order: '4455667',
                   quantity: 15, ingresed_at: '15/1/2025', delivery_at: '10/5/2025', unit_price: 1290,
                   state: 'without_material', currency: 'ars')
order7.client = client2
order7.save

order8 = Order.new(name: 'Motor eléctrico trifásico 75hp', purchase_order: '5566778',
                   quantity: 4, ingresed_at: '20/2/2025', delivery_at: '30/6/2025', unit_price: 3200,
                   state: 'in_progress', currency: 'usd')
order8.client = client3
order8.save

order9 = Order.new(name: 'Intercambiador de calor placas y juntas', purchase_order: '6677889',
                   quantity: 10, ingresed_at: '25/3/2025', delivery_at: '15/7/2025', unit_price: 4750,
                   state: 'with_material_but_not_started', currency: 'ars')
order9.client = client4
order9.save

order10 = Order.new(name: 'Tanque de almacenamiento de 50m³', purchase_order: '7788990',
                    quantity: 1, ingresed_at: '30/4/2025', delivery_at: '10/8/2025', unit_price: 15000,
                    state: 'not_invoiced', currency: 'usd')
order10.client = client5
order10.save

order11 = Order.new(name: 'Plataforma metálica para planta', purchase_order: '8899001',
                    quantity: 3, ingresed_at: '5/5/2025', delivery_at: '25/9/2025', unit_price: 6000,
                    state: 'delivered_and_invoiced', currency: 'ars')
order11.client = client1
order11.save

order12 = Order.new(name: 'Chiller de 300 toneladas de refrigeración', purchase_order: '9900112',
                    quantity: 2, ingresed_at: '10/6/2025', delivery_at: '5/10/2025', unit_price: 24500,
                    state: 'incomplete', currency: 'usd')
order12.client = client2
order12.save

order13 = Order.new(name: 'Sistema de control de flujo para proceso químico', purchase_order: '10111223',
                    quantity: 7, ingresed_at: '15/7/2025', delivery_at: '20/11/2025', unit_price: 7800,
                    state: 'without_material', currency: 'ars')
order13.client = client3
order13.save

order14 = Order.new(name: 'Bombas centrífugas de 10hp', purchase_order: '12131425',
                    quantity: 6, ingresed_at: '20/8/2025', delivery_at: '15/12/2025', unit_price: 3500,
                    state: 'in_progress', currency: 'usd')
order14.client = client4
order14.save