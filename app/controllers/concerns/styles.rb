module Styles
  def self.centered_b_style(workbook)
    workbook.styles.add_style(
      b: true,
      alignment: { horizontal: :center, vertical: :center, wrap_text: true },
      sz: 12,
      border: { style: :thin, color: '000000' }
    )
  end

  def self.centered_style(workbook)
    workbook.styles.add_style(
      alignment: { horizontal: :center, vertical: :center, wrap_text: true },
      sz: 10,
      border: { style: :thin, color: '000000' }
    )
  end

  def self.centered_title(workbook)
    workbook.styles.add_style(
      alignment: { horizontal: :center, vertical: :center, wrap_text: true },
      sz: 12,
      border: { style: :thin, color: '000000' }
    )
  end

  def self.b_centred(workbook)
    workbook.styles.add_style(
      b: true,
      alignment: { horizontal: :center, vertical: :center, wrap_text: true },
      sz: 10,
      border: { style: :thin, color: '000000' }
    )
  end

  def self.calendar_style(workbook)
    workbook.styles.add_style(
      alignment: { horizontal: :left, vertical: :bottom, wrap_text: true },
      sz: 8,
      border: { style: :thin, color: '000000' }
    )
  end

  def self.gray_bg(workbook)
    workbook.styles.add_style(
      bg_color: 'F2F2F2',
      b: true,
      alignment: { horizontal: :center, vertical: :center, wrap_text: true },
      sz: 10,
    )
  end

  def self.gray_bg_border_l(workbook)
    workbook.styles.add_style(
      bg_color: 'F2F2F2',
      border: {
        style: :thin,
        color: '000000',
        edges: [:left]
      },
      b: true,
      sz: 10,
      alignment: { horizontal: :center, vertical: :center, wrap_text: true }
    )
  end

  def self.gray_bg_border_r(workbook)
    workbook.styles.add_style(
      bg_color: 'F2F2F2',
      border: {
        style: :thin,
        color: '000000',
        edges: [:right] # Bordes izquierdo y derecho
      },
      b: true,
      sz: 10,
      alignment: { horizontal: :center, vertical: :center, wrap_text: true }
    )
  end

  def self.gray_bg_border(workbook)
    workbook.styles.add_style(
      bg_color: 'F2F2F2',
      alignment: { horizontal: :center, vertical: :center, wrap_text: true },
      sz: 8,
      border: [
        { style: :thin, color: '000000', edges: [:left] },
        { style: :thin, color: '000000', edges: [:right] },
        { style: :thin, color: '000000', edges: [:bottom] }
      ]
    )
  end

  def self.centred_with_color(workbook)
    workbook.styles.add_style(
      sz: 10,
      b: true, # negrita,
      bg_color: '61d2f0',
      border: { style: :thin, color: '000000' },
      alignment: { horizontal: :center, vertical: :center, wrap_text: true }
    )
  end
end
