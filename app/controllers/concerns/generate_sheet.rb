module GenerateSheet
  I18n.locale = :es
  include Styles
  include GenerateCalendar
  include FormatSheet
  require 'caxlsx'
  require 'date'

  def sheet_preventive(frequency)
    package = Axlsx::Package.new
    workbook = package.workbook
    initialize_styles workbook
    workbook.add_worksheet(name: 'Orden de mantenimiento') do |sheet|
      header_sheet(sheet, 'preventive', nil, nil)
      sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
      sheet.add_row ['', 'TAREAS REALIZADAS'] + Array.new(6, '') + ['INDICAR FRECUENCIA -->'] + Array.new(3, '') + ['TRIM', '', ''], style: [@gray_bg_border_l] + Array.new(11, @gray_bg) + [@centered_style, @centered_style] + [@gray_bg_border_r]
      sheet.merge_cells('B19:D19')
      sheet.merge_cells('I19:L19')
      sheet.merge_cells('M19:N19')

      6.times do |i|
        if i == 2
          sheet.add_row Array.new(12, '') + ['SEMESTRAL', '', ''], style: [@gray_bg_border_l] + Array.new(10, @centered_style) + [@gray_bg] + Array.new(2, @centered_style) + [@gray_bg_border_r]
          next
        elsif i == 5
          sheet.add_row ['', 'MARCAR CON UN TILDE CUANDO SE REALICE LA RUTINA MANTENIMIENTO SEGÚN FRECUENCIA ESTABLECIDA. SI SE DETECTA UNA OBSERVACIÓN DETALLAR EN EL CAMPO DE "OBSERVACIONES".'] + Array.new(10, '') + ['ANUAL', '', ''], style: [@gray_bg_border_l] + Array.new(10, @gray_bg_border)+ [@gray_bg] + Array.new(2, @centered_style) + [@gray_bg_border_r]
          2.times do |j|
            sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(10, @gray_bg_border)+ [@gray_bg] + Array.new(2, @centered_style) + [@gray_bg_border_r]
          end
          next
        end
        sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(10, @centered_style) + [@gray_bg] + Array.new(2, @centered_style) + [@gray_bg_border_r]
      end

      case frequency

      when 'biannual'
        row = sheet.rows[22]
        row.cells[12].value = 'X'
        row = sheet.rows[19]
        row.cells[1].value = preventive_detail_biannual

      when 'annual'
        row = sheet.rows[25]
        row.cells[12].value = 'X'
        row = sheet.rows[19]
        row.cells[1].value = preventive_detail_annual
      else
        row = sheet.rows[19]
        row.cells[12].value = 'X'
        row = sheet.rows[19]
        row.cells[1].value = preventive_detail_biannual
      end

      sheet.merge_cells('B20:K24')
      sheet.merge_cells('M20:N21')
      sheet.merge_cells('M22:N22')
      sheet.merge_cells('M23:N24')
      sheet.merge_cells('B25:K27')
      sheet.merge_cells('M25:N25')
      sheet.merge_cells('M26:N27')
      3.times do
        sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
      end

      footer_sheet(sheet, nil, nil)

      sheet.column_widths(*Array.new(15, 7))
    end
    temp_file = Tempfile.new(['maintenance', '.xlsx'])
    package.serialize(temp_file.path)
    temp_file
  end

  def sheet_corrective(_month, _year)
    package = Axlsx::Package.new
    workbook = package.workbook
    initialize_styles workbook

    workbook.add_worksheet(name: 'Orden de mantenimiento') do |sheet|
      header_sheet(sheet, 'corrective', _month, _year)
      sheet.add_row Array.new(15,''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
      sheet.add_row ['', 'TAREAS REALIZADAS'] + Array.new(13, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
      sheet.merge_cells('B19:D19')
      8.times do |i|
        sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @centered_style) + [@gray_bg_border_r]
        sheet.merge_cells("B#{20 + i}:N#{20 + i}")
      end

      3.times do
        sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
      end

      footer_sheet(sheet, _month, _year)

      sheet.column_widths(*Array.new(15, 7))

    end
    temp_file = Tempfile.new(['maintenance', '.xlsx'])
    package.serialize(temp_file.path)
    temp_file
  end

  def sheet_routine(month, year)
    package = Axlsx::Package.new
    workbook = package.workbook
    month_name = I18n.t('date.month_names')[month]
    initialize_styles workbook

    workbook.add_worksheet(name: 'Orden de mantenimiento') do |sheet|
      header_sheet(sheet, 'routine', month, year)
      sheet.merge_cells('A17:O17')
      sheet.add_row ['', 'MES', "#{month_name} "] + Array.new(5, '') + ['TAREAS REALIZADAS'] + Array.new(6, ''),
                    style: [@gray_bg_border_l] + Array.new(6, @b_centred) + Array.new(1, @gray_bg) + Array.new(6, @b_centred) + [@gray_bg_border_r]
      sheet.merge_cells('C18:G18')
      sheet.merge_cells('I18:N18')
      sheet.add_row ['', 'L', 'M', 'X', 'J', 'V', 'S', 'D', routine_detail.to_s] + Array.new(7, ''),
                    style: [@gray_bg_border_l] + Array.new(7, @centered_style) + Array.new(6, @centered_style) + [@gray_bg_border_r]

      calendar = generate_calendar(month, year)
      calendar.each do |week|
        sheet.add_row [''] + week + Array.new(7, ''), style: [@gray_bg_border_l] + Array.new(13, @calendar) + [@gray_bg_border_r]
      end

      sheet.merge_cells('I19:N25')
      sheet.add_row Array.new(8, '') +
      ["MARCAR CON UN TILDE CUANDO SE REALICE LA RUTINA MANTENIMIENTO DIARIO. SI SE DETECTA UNA OBSERVACIÓN DETALLAR EN EL CAMPO DE \"OBSERVACIONES\""] +
      Array.new(6, ''),
      style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
      sheet.merge_cells('I26:N28')
      sheet.add_row Array.new(15,''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
      sheet.merge_cells('A29:O29')
      sheet.add_row Array.new(15,''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
      sheet.add_row Array.new(15,''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
      sheet.add_row Array.new(15,''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]


      footer_sheet(sheet, month, year)
      sheet.column_widths(*Array.new(15, 7))
    end

    temp_file = Tempfile.new(['maintenance', '.xlsx'])
    package.serialize(temp_file.path)
    temp_file
  end

  def production_sheet(orders, year)
    package = Axlsx::Package.new
    workbook = package.workbook
    initialize_styles workbook
    workbook.add_worksheet(name: 'Informe producción') do |sheet|
      sheet.add_row ["INFORME DE PRODUCCION DE : #{year.present? ? year : 'TODOS LOS AÑOS'}"], style: Array.new(6, @centered_b_style)
      sheet.merge_cells('A1:E1')
      sheet.add_row ['OT', 'Cliente', 'Descripción', 'Fecha de ingreso', 'Fecha pactada de entrega', 'Fecha de entrega real'], style: Array.new(6, @centred_with_color)
      orders.each do |order|
        sheet.add_row [order.id, order.client.name, order.name, order.ingresed_at.strftime('%d/%m/%Y'),
                       order.estimated_delivery_date.strftime('%d/%m/%Y'),
                       order.delivery_at.present? ? order.delivery_at.strftime('%d/%m/%Y') : 'En curso'], style: Array.new(6, @centered_style)
      end
      sheet.add_row ['Emitido: ', Date.today.strftime('%d/%m/%Y')]
    end
    temp_file = Tempfile.new(['order', '.xlsx'])
    package.serialize(temp_file.path)
    temp_file
  end

  private

  def initialize_styles(workbook)
    @centered_b_style = Styles.centered_b_style(workbook)
    @centered_style = Styles.centered_style(workbook)
    @centered_title = Styles.centered_title(workbook)
    @b_centred = Styles.b_centred(workbook)
    @calendar = Styles.calendar_style(workbook)
    @gray_bg = Styles.gray_bg(workbook)
    @gray_bg_border_l = Styles.gray_bg_border_l(workbook)
    @gray_bg_border_r = Styles.gray_bg_border_r(workbook)
    @gray_bg_border = Styles.gray_bg_border(workbook)
    @centred_with_color = Styles.centred_with_color(workbook)
  end

end
