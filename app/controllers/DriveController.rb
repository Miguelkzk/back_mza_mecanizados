# app/controllers/drive_controller.rb
class DriveController < ApplicationController
  def index
    drive_service = GoogleDriveService.new
    files = drive_service.list_files
    render json: files.files
  end
end
