class DrawingsController < ApplicationController
  include FileUploadable

  before_action :set_drawing, only: %i[destroy]
  def upload
    upload_file(Drawing, params[:order_id])
  end

  def destroy
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
