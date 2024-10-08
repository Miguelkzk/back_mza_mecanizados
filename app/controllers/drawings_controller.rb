class DrawingsController < ApplicationController
  include FileUploadable
  before_action :set_drawing, only: %i[destroy]
  before_action :authenticate_user!
  def upload
    authorize Drawing
    upload_file(Drawing, params[:order_id])
  end

  def destroy
    authorize @drawing
    if @drawing.destroy
      render json: @drawing
    else
      render json: drawing.error.details, status: :unprocessable_entity
    end
  end

  private

  def drawings_params
    params.require(:drawings).permit(:file, :parent_id, :order_id)
  end

  def set_drawing
    @drawing = Drawing.find_by(id: params[:id])
    return if @drawing.present?

    render status: :not_found
  end
end
