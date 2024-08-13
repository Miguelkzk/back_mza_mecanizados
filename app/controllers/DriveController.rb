# app/controllers/drive_controller.rb
class DriveController < ApplicationController
  def index
    drive_service = GoogleDriveService.new
    files = drive_service.list_files
    render json: files.files
  end

  def show
    file_id = params[:id]
    view_url = "https://drive.google.com/file/d/#{file_id}/view"
    render json: { url: view_url }
  end

  def create_folder
    drive_service = GoogleDriveService.new
    folder_name = params[:name]
    parent_id = params[:parent_id]

    folder = drive_service.create_folder(folder_name, parent_id)
    render json: { id: folder.id, name: folder_name }, status: :created
  end
end
