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

  ############################################################################################
  # VALIDATIONS
  ############################################################################################

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
    folder_name = self.name
    parent_id = '1ucIa7E9E3eG7ldf5ckqKZoVXTHf0qZcq'
    folder = drive_service.create_folder(folder_name, parent_id)
    self.update(drive_id: folder.id)
  end

  def generate_work_order
    package = Axlsx::Package.new
    workbook = package.workbook

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
      b: true, # negrita
      alignment: { horizontal: :center, vertical: :center },
      border: { style: :thin, color: '000000' }
    )

    centered_b_style_with_wrap = workbook.styles.add_style(
      sz: 12,
      b: true, # Negrita
      alignment: { horizontal: :center, vertical: :center, wrap_text: true },
      border: { style: :thin, color: '000000' }
    )

    # Genera un excel
    workbook.add_worksheet(name: 'Orden de trabajo') do |sheet|
      # LOGO
      sheet.merge_cells('A1:B4')
      sheet.add_image(image_src: 'public/logo MM.png', noSelect: true, noMove: true) do |image|
        image.start_at 0, 0 # Inicia en la celda A1
        image.width = 454 # Ajusta el ancho de la imagen
        image.height = 94 # Ajusta el alto de la imagen
      end

      # ENCABEZADO
      sheet.add_row ['', '', 'Orden de trabajo', id], style: centered_b_style
      sheet.add_row ['', '', 'Cliente', client.name], style: centered_b_style
      sheet.add_row ['', '', 'Fecha de entrega', delivery_at.strftime('%d/%m/%Y')], style: centered_b_style
      sheet.add_row ['', '', 'Cantidad a fabricar', quantity], style: centered_style

      # DESCRIPCIÓN
      sheet.add_row ['DESCRIPCIÓN', name, '', ''], style: centered_b_style
      sheet.merge_cells 'B5:D5' # Combinar celdas
      sheet.add_row ['PLANO', "Implementar", 'OC', purchase_order], style: centered_b_style

      # MATERIALES
      sheet.add_row ['RECEPCIÓN DE MATERIALES', '', '', ''], style: centered_b_style
      sheet.add_row ['', '', '', ''], style: centered_b_style
      sheet.merge_cells 'A7:D8' # Combinar celdas


      material_start_row = 9
      material_end_row = material_start_row + materials.count + 1

      # Combinar celdas dinámicamente

      sheet.add_row ['Material', 'Proveedor', 'Fecha Ing.', 'RTO Prov'], style: centered_b_style
      materials.each do |material|
        sheet.add_row [material.description, material.supplier.name, "IMPLEMENTAR", material.supplier_note], style: centered_style
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
      sheet.add_row ['Procedimiento', 'Maquina/as', 'Operario/os', 'Firma'], style: centered_b_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.add_row ['', '', '', ''], style: centered_style

      # CONTROL DIMENSIONAL
      sheet.add_row ['CONTROL DIMENSIONAL', '', '', ''], style: centered_b_style
      sheet.add_row ['', '', '', ''], style: centered_style
      sheet.merge_cells "A#{material_end_row + 11}:D#{material_end_row + 12}"
      # sheet.add_row ['PROCEDIMIENTO', '', '', ''], style: centered_b_style
      # sheet.merge_cells "A#{material_end_row + 9}:B#{material_end_row + 9}"
      # sheet.merge_cells "C#{material_end_row + 9}:D#{material_end_row + 9}"
      # sheet.add_row ['INSTRUMENTOS UTILIZADOS  (TIPO, MARCA Y CODIGO INTERNO)', '', '', ''], style: centered_b_style_with_wrap
      # sheet.add_row ['', '', '', ''], style: centered_style
      # sheet.add_row ['', '', '', ''], style: centered_style
      # sheet.add_row ['', '', '', ''], style: centered_style
      # sheet.add_row ['', '', '', ''], style: centered_style
      # sheet.add_row ['', '', '', ''], style: centered_style
      # sheet.merge_cells "A#{material_end_row + 10}:B#{material_end_row + 15}"

      # PIE DE PAGINA
      sheet.add_row ['Inspector', 'Fecha de inspección', 'Firma', 'Nro de informe'], style: header_style
      sheet.add_row ['Kruzliak Pablo', '', '', ''], style: centered_style

      # Establecer anchos de columnas
      sheet.column_info[0].width = 28 # Columna A
      sheet.column_info[1].width = 28 # Columna B
      sheet.column_info[2].width = 28 # Columna C
      sheet.column_info[3].width = 28 # Columna D
    end

    # Guardar en un archivo temporal
    temp_file = Tempfile.new(['order', '.xlsx'])
    package.serialize(temp_file.path)

    temp_file
  end

  ############################################################################################
  # CLASS METHODS
  ############################################################################################
end
