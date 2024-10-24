class FilePurchaseOrdersController < ApplicationController
  include FileUploadable
  before_action :set_file_purchase_order, only: %i[destroy]
  before_action :authenticate_user!

  def upload
    authorize FilePurchaseOrder
    upload_file(FilePurchaseOrder, params[:order_id])
  end

  def destroy
    authorize @file_purchase_order
    if @file_purchase_order.destroy
      render json: @file_purchase_order
    else
      render json: @file_purchase_order.error.details, status: :unprocessable_entity
    end
  end

  private

  def file_purchase_orders_params
    params.require(:file_purchase_orders).permit(:file, :parent_id, :order_id)
  end

  def set_file_purchase_order
    @file_purchase_order = FilePurchaseOrder.find_by(id: params[:id])
    return if @file_purchase_order.present?

    render status: :not_found
  end
end
