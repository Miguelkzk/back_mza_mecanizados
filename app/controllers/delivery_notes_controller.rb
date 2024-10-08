class DeliveryNotesController < ApplicationController
  include FileUploadable

  before_action :set_delivery_note, only: %i[destroy]
  before_action :authenticate_user!
  def upload
    authorize DeliveryNote
    upload_file(DeliveryNote, params[:order_id])
  end

  def destroy
    authorize @delivery_note
    if @delivery_note.destroy
      render status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  private

  def delivery_note_params
    params.require(:delivery_note).permit(:file, :parent_id, :order_id)
  end

  def set_delivery_note
    @delivery_note = DeliveryNote.find_by(id: params[:id])
    return if @delivery_note.present?

    render status: :not_found
  end
end
