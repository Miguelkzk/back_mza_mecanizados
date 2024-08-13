require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

class GoogleDriveService
  APPLICATION_NAME = 'back_mza_mecanizados'.freeze
  CREDENTIALS_PATH = 'config/credentials/credentials.json'.freeze
  SCOPE = Google::Apis::DriveV3::AUTH_DRIVE

  def initialize
    @service = Google::Apis::DriveV3::DriveService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def list_files
    @service.list_files(fields: 'nextPageToken, files(id, name)')
  end

  private

  def authorize
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(CREDENTIALS_PATH),
      scope: SCOPE
    )
    authorizer.fetch_access_token!
    authorizer
  end
end
