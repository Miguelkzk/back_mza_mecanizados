module FileUploadable
  extend ActiveSupport::Concern

  included do
    before_action :set_drive_service
  end

  def upload_file(file_class, order_id)
    file = params[:file]
    folder_id = params[:parent_id]

    if file.present?
      begin
        uploaded_file = @drive_service.upload_file(file.original_filename, file.tempfile.path, folder_id)
        record = file_class.new(name: uploaded_file.name, drive_id: uploaded_file.id, order_id: order_id)

        if record.save
          render json: record, status: :created
        else
          render json: record.errors.full_messages, status: :unprocessable_entity
        end
      rescue Google::Apis::ClientError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No file uploaded' }, status: :bad_request
    end
  end

  private

  def set_drive_service
    @drive_service = GoogleDriveService.new
  end
end
