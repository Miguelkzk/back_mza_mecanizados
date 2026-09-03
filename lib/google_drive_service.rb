require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'json'
require 'stringio'
class GoogleDriveService
  APPLICATION_NAME = 'back_mza_mecanizados'.freeze
  GOGLE_DRIVE_CRENDENTIALS = JSON.parse(ENV['CREDENTIALS_DRIVE'])
  SCOPE = Google::Apis::DriveV3::AUTH_DRIVE

  def initialize
    @service = Google::Apis::DriveV3::DriveService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def list_files
    @service.list_files(fields: 'nextPageToken, files(id, name)')
  end

  def create_folder(name, parent_id = nil)
    file_metadata = { name: name, mime_type: 'application/vnd.google-apps.folder'}
    file_metadata[:parents] = [parent_id] if parent_id

    # Llamada para crear carpeta y me devuelve la carpeta creada
    create_file(file_metadata, { fields: 'id' }, parent_id)
  end

  def delete_file(file_id)
    @service.delete_file(file_id)
  end

  def upload_file(file_name, file_path, parent_id = nil)
    file = Google::Apis::DriveV3::File.new
    file.name = file_name
    file.parents = [parent_id] if parent_id

    create_file(file, { upload_source: file_path, content_type: 'application/octet-stream' }, parent_id)
  end

  # hay un bug que la api de google que a veces muestra una carpeta como que no existe cuando en realidad si.
  # Se soluciona haciendo un find de esa carpeta.
  def create_file(file, attrs, parent_id = nil)
    @service.create_file(file, **attrs)
  rescue Google::Apis::ClientError => e
    raise e unless e.message.include?('notFound') && parent_id.present?

    result = get_by_id(parent_id)
    raise e unless result[:status]

    @service.create_file(file, **attrs)
  end

  def get_by_id(file_or_folder_id)
    file = @service.get_file(file_or_folder_id, fields: 'id, name, mimeType')

    { status: true, response: file }
  rescue Google::Apis::ClientError
    { status: false }
  end

  private

  def authorize
    json_key_io = StringIO.new(GOGLE_DRIVE_CRENDENTIALS.to_json) # uso stringio para convertir el hash en un archivo
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: json_key_io,
      scope: SCOPE
    )
    authorizer.fetch_access_token!
    authorizer
  end
end