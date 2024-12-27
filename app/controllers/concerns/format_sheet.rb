module FormatSheet
  include Styles
  def header_sheet(sheet, type, month, year)
    initialize_styles sheet.workbook
    sheet.merge_cells('A1:D4')
    sheet.add_image(image_src: 'public/logo cut.png', noSelect: true, noMove: true) do |image|
      image.start_at 0, 0
      image.width = 220 # ancho de la imagen
      image.height = 90 # alto de la imagen
    end
    # encabezado
    sheet.add_row Array.new(4, '') + ['MANTENIMIENTO DE INFRAESTRUCTURA'] + Array.new(10, ''), style: @centered_b_style
    sheet.add_row []
    sheet.merge_cells('E1:O2')
    sheet.add_row Array.new(4, '') + ['ORDEN DE MANTENIMIENTO'] + Array.new(7, '') +
                  ['Nº ORDEN:', '', "#{self.maintenances.where(type_maintenance: type).count + 1}"],
                  style: @centered_title
    sheet.merge_cells('E3:L4')
    sheet.merge_cells('M3:N4')
    sheet.merge_cells('O3:O4')

    sheet.add_row Array.new(15, ''), style: @centered_b_style
    sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('A5:O5')

    sheet.add_row ['', 'RESPONSABLE:'] + Array.new(8, '') + ['FECHA DE EMISION'] + Array.new(4, ''),
                  style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('B6:H6')
    sheet.merge_cells('K6:M6')

    sheet.add_row ['', 'Pablo Kruzliak'] + Array.new(8, '') + ["#{if year.present? && month.present? then Date.new(year, month, 1) end } "] + Array.new(4, ''), style:
      [@gray_bg_border_l] + Array.new(7, @centered_style) + Array.new(2, @gray_bg) +
      Array.new(3, @centered_style) + [@gray_bg, @gray_bg_border_r]
    sheet.merge_cells('B7:H7')
    sheet.merge_cells('K7:M7')

    sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('A8:O8')

    sheet.add_row ['', 'CODIGO:'] + Array.new(5, '') + ['EQUIPO:'] + Array.new(7, ''),
                  style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('B9:C9')
    sheet.merge_cells('H9:N9')

    sheet.add_row ['', code.to_s] + Array.new(5, '')+ [model.to_s] + Array.new(7, ''), style:
      [@gray_bg_border_l] + Array.new(2, @centered_style) + Array.new(4, @gray_bg) +
      Array.new(7, @centered_style) + [@gray_bg_border_r]
    sheet.merge_cells('B10:C10')
    sheet.merge_cells('H10:N10')

    sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('A12:O12')
    sheet.add_row Array.new(4, '') + ['TIPO DE MANTENIMIENTO'] + Array.new(10, ''), style:
    [@gray_bg_border_l] + Array.new(3, @gray_bg) + Array.new(6, @b_centred) +
    Array.new(4, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('E13:J13')
    sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('A14:O14')
    sheet.add_row ['', 'DE RUTINA', '', '', '', '', 'PREVENTIVO', '', '', '', '', 'CORRECTIVO', '', '', ''], style:
      [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('B15:D15')
    sheet.merge_cells('G15:I15')
    sheet.merge_cells('L15:N15')

    sheet.add_row ['', '', "#{if type == 'routine' then 'X' end}", '', '', '', '',
                   "#{if type == 'preventive' then 'X' end}", '', '', '', '',
                   "#{if type == 'corrective' then 'X' end}", '', '', ''], style:
      [@gray_bg_border_l, @gray_bg, @centered_style] + Array.new(4, @gray_bg) + [@centered_b_style] + Array.new(4, @gray_bg) +
      [@centered_b_style, @gray_bg, @gray_bg_border_r]
    sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('A17:O17')
  end

  def footer_sheet(sheet, month, year)
    initialize_styles sheet.workbook
    sheet.add_row ['', 'PERSONAL AFECTADO'] + Array.new(4, '') + ['HORAS', '', '', 'REPUESTOS UTILIZADOS'] + Array.new(5, ''), style:
    [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('B31:E31')
    sheet.merge_cells('G31:H31')
    sheet.merge_cells('J31:N31')

    6.times do |i|
      sheet.add_row Array.new(15, ''),
      style: [@gray_bg_border_l] + Array.new(4, @centered_style) +
      [@gray_bg, @centered_style, @centered_b_style, @gray_bg] + Array.new(5, @centered_style) + [@gray_bg_border_r]
      sheet.merge_cells("B#{32 + i}:E#{32 + i}")
      sheet.merge_cells("G#{32 + i}:H#{32 + i}")
      sheet.merge_cells("J#{32 + i}:N#{32 + i}")
    end

    sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('A38:O38')
    sheet.add_row ['', 'OBSERVACIONES'] + Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('B39:D39')

    3.times do |i|
      sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @centered_style) + [@gray_bg_border_r]
      sheet.merge_cells("B#{40 + i}:N#{40 + i}")
    end

    sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('A43:O43')
    sheet.add_row ['', 'FIRMA DEL RESPONSABLE'] + Array.new(8, '') + ['FECHA CIERRE'] + Array.new(4, ''), style:
    [@gray_bg_border_l] + Array.new(13, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('B44:H44')
    sheet.merge_cells('K44:N44')

    sheet.add_row Array.new(10, '') + ["#{if year.present? && month.present? then Date.new(year, month, -1) end}"] + Array.new(4, ''), style:
    [@gray_bg_border_l] + Array.new(7, @centered_style) + [@gray_bg, @gray_bg] + Array.new(4, @centered_style) + [@gray_bg_border_r]
    sheet.add_row Array.new(15, ''), style: [@gray_bg_border_l] + Array.new(7, @centered_style) + Array.new(6, @gray_bg) + [@gray_bg_border_r]
    sheet.merge_cells('B45:H46')
    sheet.merge_cells('K45:N45')
    sheet.add_row Array.new(15, ''), style: @gray_bg_border
    sheet.merge_cells('A47:O47')

  end

  private

  def initialize_styles(workbook)
    @centered_b_style = Styles.centered_b_style(workbook)
    @centered_style = Styles.centered_style(workbook)
    @centered_title = Styles.centered_title(workbook)
    @b_centred = Styles.b_centred(workbook)
    @gray_bg = Styles.gray_bg(workbook)
    @gray_bg_border_l = Styles.gray_bg_border_l(workbook)
    @gray_bg_border_r = Styles.gray_bg_border_r(workbook)
    @gray_bg_border = Styles.gray_bg_border(workbook)
  end
end