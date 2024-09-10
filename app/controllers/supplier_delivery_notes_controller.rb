class SupplierDeliveryNotesController < ApplicationController
  before_action :set_drive_service

  def upload
    file = params[:file]
    folder_id = params[:parent_id]
    order_id = params[:order_id]

    if file.present?
      begin
        uploaded_file = @drive_service.upload_file(file.original_filename, file.tempfile.path, folder_id)
        delivery_note = SupplierDeliveryNote.new(name: uploaded_file.name,
                                                 drive_id: uploaded_file.id, order_id: order_id)
        if delivery_note.save
          render json: delivery_note, status: :created
        else
          render json: delivery_note.errors.full_messages, status: :unprocessable_entity
        end
      rescue Google::Apis::ClientError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

    else
      render json: { error: 'No file uploaded' }, status: :bad_request
    end
  end

  private

  def supplier_delivery_note_params
    params.require(:supplier_delivery_note).permit(:file, :parent_id, :order_id)
  end

  def set_drive_service
    @drive_service = GoogleDriveService.new
  end
end
