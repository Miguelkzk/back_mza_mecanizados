class Order < ApplicationRecord
  require 'caxlsx'

  ############################################################################################
  # ENUMS
  ############################################################################################

  enum state: { without_material: 0, with_material_but_not_started: 1, in_progress: 2,
                not_invoiced: 3, delivered_and_invoiced: 4, incomplete: 5 }

  enum currency: { ars: 0, usd: 1 }

  ############################################################################################
  # ASSOCIATIONS
  ############################################################################################

  belongs_to :client
  has_many :drawings
  has_many :materials
  has_many :suppliers, through: :materials
  has_one :work_order
  has_many :certificate_of_materials
  has_many :supplier_delivery_notes
  has_many :delivery_notes
  has_many :file_purchase_orders
  ############################################################################################
  # VALIDATIONS
  ############################################################################################

  validates :name, :purchase_order, :quantity, :unit_price,
            :currency, :ingresed_at, :estimated_delivery_date, presence: true

  validates :estimated_delivery_date, comparison: { greater_than: :ingresed_at }

  ############################################################################################
  # SCOPES
  ############################################################################################

  scope :status, ->(state = nil) { state.present? ? where(state: state) : all }

  scope :by_purchase_order, ->(purchase_order) { where('purchase_order LIKE ?', "%#{purchase_order}%") if purchase_order.present? }

  scope :by_client_name, ->(client_name) { joins(:client).where('clients.name ILIKE ?',"%#{client_name}%") if client_name.present? }

  scope :by_name, ->(name) { where('name ILIKE ?', "%#{name}%") if name.present? }

  ############################################################################################
  # CALLBACKS
  ############################################################################################

  after_create :create_folder

  ############################################################################################
  # INSTANCE METHODS
  ############################################################################################

  def create_folder
    drive_service = GoogleDriveService.new
    folder_name = name
    parent_id = '1ucIa7E9E3eG7ldf5ckqKZoVXTHf0qZcq'
    folder = drive_service.create_folder(folder_name, parent_id)
    update(drive_id: folder.id)
  end

  def generate_work_order
    package = Axlsx::Package.new
    workbook = package.workbook

    work_order&.destroy

    # estilos
    header_style = workbook.styles.add_style(
      sz: 12, # font size
      alignment: { horizontal: :left, vertical: :center },
      border: { style: :thin, color: '000000' }
    )

    centered_style = workbook.styles.add_style(
      alignment: { horizontal: :center, vertical: :center },
      border: { style: :thin, color: '000000' }
    )

    centered_b_style = workbook.styles.add_style(
      sz: 12,
      b: true, # negrita,
      alignment: { horizontal: :center, vertical: :center },
      border: { style: :thin, color: '000000' }
    )

    centered_style_with_color = workbook.styles.add_style(
      sz: 12,
      b: true, # negrita,
      bg_color: '61d2f0',
      border: { style: :thin, color: '000000' },
      alignment: { horizontal: :center, vertical: :center, wrap_text: true }
    )

    # Genera un excel
    workbook.add_worksheet(name: 'Orden de trabajo') do |sheet|
      # LOGO
      sheet.merge_cells('A1:B4')
      sheet.add_image(image_src: 'public/logo MM.png', noSelect: true, noMove: true) do |image|
        image.start_at 0, 0
        image.width = 440 # ancho de la imagen
        image.height = 94 # alto de la imagen
      end

      # ENCABEZADO
      sheet.add_row ['', '', 'Orden de trabajo', id], style: centered_b_style
      sheet.add_row ['', '', 'Cliente', client.name], style: centered_b_style
      sheet.add_row ['', '', 'Fecha de entrega', estimated_delivery_date.strftime('%d/%m/%Y')], style: centered_b_style
      sheet.add_row ['', '', 'Cantidad a fabricar', quantity], style: centered_style

      # DESCRIPCIÓN
      sheet.add_row ['DESCRIPCIÓN', name, '', ''], style: [centered_style_with_color, centered_b_style,
                                                           centered_b_style, centered_b_style]
      sheet.merge_cells 'B5:D5' # Combinar celdas
      sheet.add_row ['PLANO', "Implementar", 'OC', purchase_order], style: [centered_style_with_color,
                                                                            centered_style, centered_style_with_color,
                                                                            centered_style]

      # MATERIALES
      sheet.add_row ['RECEPCIÓN DE MATERIALES', '', '', ''], style: centered_b_style
      sheet.add_row ['', '', '', ''], style: centered_b_style
      sheet.merge_cells 'A7:D8' # Combinar celdas

      material_start_row = 9
      material_end_row = material_start_row + materials.count + 1 # para celdas dinamicas

      sheet.add_row ['Material', 'Proveedor', 'Cantidad', 'RTO Prov'], style: centered_style_with_color
      materials.each do |material|
        sheet.add_row [material.description, material.supplier.name, material.quantity, material.supplier_note], style: centered_style
      end

      # TAREAS
      sheet.add_row ['Detalle de tareas:', '', '', ''], style: header_style
      sheet.add_row ['', '', '', ''], style: header_style
      sheet.add_row ['', '', '', ''], style: header_style
      sheet.merge_cells "A#{material_end_row}:D#{material_end_row + 2}"

      # PROCESO PRODUCTIVO
      sheet.add_row ['PROCESO PRODUCTIVO', '', '', ''], style: centered_b_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.merge_cells "A#{material_end_row + 3}:D#{material_end_row + 4}"
      sheet.add_row ['Procedimiento', 'Maquina/as', 'Operario/os', 'Firma'], style: centered_style_with_color
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style

      # CONTROL DIMENSIONAL
      sheet.add_row ['CONTROL DIMENSIONAL', '', '', ''], style: centered_b_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.merge_cells "A#{material_end_row + 12}:D#{material_end_row + 13}"
      sheet.add_row ['Instrumento', 'Nro de certificado', 'Procedimiento', 'Inspector'], style: centered_style_with_color
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style


      # PIE DE PAGINA
      sheet.add_row ['Nro de informe', 'Fecha de inspección', 'Aprobó OT', 'Firma'], style: centered_style_with_color
      sheet.add_row ['', '', 'Kruzliak Pablo', ''], style: centered_style
      sheet.add_row ['Observaciones:', '', '', ''], style: header_style
      sheet.add_row ['', '', '', ''], style: header_style
      sheet.add_row ['', '', '', ''], style: header_style
      sheet.add_row ['', '', '', ''], style: header_style
      sheet.add_row ['', '', '', ''], style: header_style
      sheet.add_row ['', '', '', ''], style: header_style
      sheet.merge_cells "A#{material_end_row + 23}:D#{material_end_row + 28}"

      # Establecer anchos de columnas
      sheet.column_info[0].width = 28 # Columna A
      sheet.column_info[1].width = 28 # Columna B
      sheet.column_info[2].width = 28 # Columna C
      sheet.column_info[3].width = 28 # Columna D
    end

    # Guardar en un archivo temporal
    temp_file = Tempfile.new(['order', '.xlsx'])
    package.serialize(temp_file.path)
    work_order = WorkOrder.new(order: self)
    work_order_name = "Orden de trabajo: #{id}"
    work_order.upload_work_order(work_order_name, temp_file.path, drive_id)

    # Eliminar el archivo temporal
    temp_file.close
    temp_file.unlink
  end

  ############################################################################################
  # CLASS METHODS
  ############################################################################################
  # def self.ransackable_attributes(auth_object = nil)
  #   ['name']
  # end
end
