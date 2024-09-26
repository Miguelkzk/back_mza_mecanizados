class SupplierDeliveryNotesController < ApplicationController
  include FileUploadable
  before_action :set_supplier_delivery_note, only: %i[destroy]

  def upload
    upload_file(SupplierDeliveryNote, params[:order_id])
  end

  def destroy
    if @supplier_delivery_note.destroy
      render json: @supplier_delivery_note
    else
      render json: supplier_delivery_note.error.details, status: :unprocessable_entity
    end
  end

  private

  def supplier_delivery_note_params
    params.require(:supplier_delivery_note).permit(:file, :parent_id, :order_id)
  end

  def set_supplier_delivery_note
    @supplier_delivery_note  = SupplierDeliveryNote.find_by(id: params[:id])
    return if @supplier_delivery_note.present?

    render status: :not_found
  end
end
