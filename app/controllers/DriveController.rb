# app/controllers/drive_controller.rb
class DriveController < ApplicationController
  before_action :drive_service, only: %i[index create_folder destroy]
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

  def drive_service
    @drive_service = GoogleDriveService.new
  end
end
