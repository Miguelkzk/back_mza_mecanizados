# app/controllers/drive_controller.rb
class DriveController < ApplicationController
  before_action :drive_service, only: %i[index create_folder destroy upload]
  def index
    files = @drive_service.list_files
    render json: files.files
  end

  def show
    file_id = params[:id]
    view_url = "https://drive.google.com/file/d/#{file_id}/view"
    render json: { url: view_url }
  end

  def destroy
    file_id = params[:id]
    begin
      @drive_service.delete_file(file_id)
      render json: { message: 'File delete successfuly' }, status: :ok
    rescue Google::Apis::ClientError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_folder
    folder_name = params[:name]
    parent_id = params[:parent_id]

    folder = @drive_service.create_folder(folder_name, parent_id)
    render json: { id: folder.id, name: folder_name }, status: :created
  end

  def upload
    file = params[:file]
    folder_id = params[:parent_id]

    if file.present?
      begin
        uploaded_file = @drive_service.upload_file(file.original_filename, file.tempfile.path, folder_id)
        render json: { id: uploaded_file.id, name: uploaded_file.name }, status: :created
      rescue Google::Apis::ClientError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No file uploaded' }, status: :bad_request
    end
  end


  def drive_service
    @drive_service = GoogleDriveService.new
  end
end
