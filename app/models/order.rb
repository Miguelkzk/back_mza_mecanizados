class Order < ApplicationRecord
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

  require 'axlsx'
  require 'axlsx_styler'

  def generate_work_order
    package = Axlsx::Package.new
    workbook = package.workbook

    # Definir estilos
    header_style = workbook.styles.add_style(
      sz: 12, # Tamaño de fuente
      b: true, # Negrita
      alignment: { horizontal: :left, vertical: :center }
    )

    centered_style = workbook.styles.add_style(
      alignment: { horizontal: :center, vertical: :center }
    )

    # Crear una hoja de cálculo
    workbook.add_worksheet(name: 'Orden de trabajo') do |sheet|
      # LOGO Y TITULO
      # Aquí puedes agregar código para el logo si lo necesitas
      # sheet.add_image(image_src: Rails.root.join('public/logo.jpg').to_s, noSelect: true, noMove: true) do |image|
      #   image.start_at 0, 0
      #   image.end_at 1, 5
      # end
      # sheet.merge_cells('A1:F1')
      # sheet.add_row ['Mendoza Mecanizados S.R.L.'], style: title_style, height: 30

      # ENCABEZADO
      sheet.add_row ['', '', '', 'Orden de trabajo', id], style: header_style
      sheet.add_row ['', '', '', 'Cliente', client.name], style: header_style
      sheet.add_row ['', '', '', 'Fecha de entrega', delivery_at.strftime('%d/%m/%Y')], style: header_style
      sheet.add_row ['', '', '', 'Cantidad a fabricar', quantity], style: header_style

      # DESCRIPCIÓN
      sheet.add_row ['Descripción', name], style: centered_style
      sheet.merge_cells 'B5:E5'


      # MATERIALES
      sheet.add_row ['Recepción de Materiales'], style: header_style
      sheet.merge_cells 'A6:E6'

      sheet.add_row ['Material', 'Proveedor', 'Cantidad', 'Fecha Ing.', 'RTO Prov'], style: header_style

      materials.each do |material|
        sheet.add_row [material.description, material.supplier.name, material.quantity,
                       "IMPLEMENTAR", material.supplier_note]
      end
      sheet.add_row []
      sheet.add_row ['Detalle de tareas:'], style: header_style

      # PROCESO PRODUCTIVO
      sheet.add_row ['Proceso Productivo'], style: header_style
      sheet.add_row ['Procedimiento', 'Maquina/as', 'Operario/os', 'Firma'], style: header_style
      sheet.add_row []

      # CONTROL DIMENSIONAL
      sheet.add_row ['Control Dimensional'], style: header_style
      sheet.add_row ['PROCEDIMIENTO'], style: header_style
      sheet.add_row ['instrumentos'], style: header_style
      sheet.add_row ['Inspector', 'Fecha de inspección', 'Firma', 'Nro de informe'], style: header_style
      sheet.add_row ['Kruzliak Pablo', '', '', '']
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
