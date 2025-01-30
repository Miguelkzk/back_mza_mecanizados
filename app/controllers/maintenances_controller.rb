class MaintenancesController < ApplicationController
  before_action :authenticate_user!
  def upload
    authorize Maintenance
    file = params[:file]
    folder_id = params[:folder_id]

    if file.present?
      drive_service = GoogleDriveService.new
      begin
        uploaded_file = drive_service.upload_file(file.original_filename, file.tempfile.path, folder_id)
        maintenance = Maintenance.new(name: uploaded_file.name, drive_id: uploaded_file.id,
                                      machine_id: params[:machine_id], type_maintenance: params[:type_maintenance],
                                      issue_date: params[:issue_date])

        if maintenance.save
          render json: maintenance, status: :created
        else
          render json: maintenance.errors.full_messages, status: :unprocessable_entity
        end
      rescue Google::Apis::ClientError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No file uploaded' }, status: :bad_request
    end
  end

  def destroy
    authorize Maintenance
    maintenance = Maintenance.find(params[:id])
    if maintenance.destroy
      render json: maintenance
    else
      render json: maintenance.error.details, status: :unprocessable_entity
    end
  end

  private

  def maintenance_params
    params.require(:maintenance).permit(:name, :issue_date, :type_maintenance, :machine_id, :file, :folder_id)
  end
end
