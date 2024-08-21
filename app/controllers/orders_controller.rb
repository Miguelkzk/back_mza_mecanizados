class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy]

  def index
    orders = Order.includes(:client).all

    render json: orders.map { |order|
      {
        id: order.id,
        purchase_order: order.purchase_order,
        client: order.client.name,
        name: order.name,
        state: order.state
      }
    }
  end

  def show
    render json: @order.as_json.merge(client: @order.client.name, drawings: @order.drawings)
  end

  def create
    order = Order.new(order_params)

    if order.save
      render json: order, status: :created
    else
      render json: order.error.details, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: order.error.details, status: :unprocessable_entity
    end
  end

  def destroy
    if @order.destroy
      render json: @order
    else
      render json: order.error.details, status: :unprocessable_entity
    end
  end

  def create_folder
    drive_service = GoogleDriveService.new
    folder_name = params[:name]
    parent_id = '1ucIa7E9E3eG7ldf5ckqKZoVXTHf0qZcq'
    folder = drive_service.create_folder(folder_name, parent_id)
    render json: { id: folder.id, name: folder_name }, status: :created
  end

  private

  def set_order
    @order = Order.find_by(id: params[:id])
    return @order if @order.present?

    render status: :not_found
  end

  def order_params
    params.require(:order).permit(:name, :purchase_order, :quantity, :ingresed_at,
                                  :delivery_at, :total_price, :unit_price, :comment, :state, :client_id)
  end
end
