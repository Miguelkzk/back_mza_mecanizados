module GenerateSheet
  I18n.locale = :es
  include Styles
  include GenerateCalendar
  include FormatSheet
  require 'caxlsx'
  require 'date'
  def sheet_preventive
    # Implementar el método
  end

  def sheet_corrective
    # Implementar el método
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
      sheet.add_row ['', 'L', 'M', 'X', 'J', 'V', 'S', 'D', '', routine_detail.to_s] + Array.new(7, ''),
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
    temp_file.path
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

  end
end
