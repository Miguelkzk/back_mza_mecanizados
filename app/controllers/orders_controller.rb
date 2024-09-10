class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy generate_work_order]

  def index
    state = params[:state]
    purchase_order = params[:purchase_order]
    client_name = params[:client_name]
    name = params[:name]

    orders = Order.status(state).by_purchase_order(purchase_order).by_client_name(client_name)
                  .by_name(name).includes(:client).all

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
    total_price = @order.unit_price * @order.quantity
    materials = @order.materials

    materials_with_supplier = materials.map do |material|
      material.as_json.merge(
        supplier_name: material.supplier.name,
        ingresed_at: material.ingresed_at.strftime('%d/%m/%Y')
      )
    end

    render json: @order.as_json.merge(
      client: @order.client.name,
      drawings: @order.drawings,
      materials: materials_with_supplier,
      work_order: @order.work_order,
      certificate_of_materials: @order.certificate_of_materials,
      total_price: total_price
    )
  end

  def generate_work_order
    if @order.generate_work_order
      render json: { message: 'Work order generated successfully.' }, status: :ok
    else
      render json: { error: 'Failed to generate work order.' }, status: :unprocessable_entity
    end
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

  private

  def set_order
    @order = Order.find_by(id: params[:id])
    return @order if @order.present?

    render status: :not_found
  end

  def order_params
    params.require(:order).permit(:name, :purchase_order, :quantity, :ingresed_at,
                                  :delivery_at, :unit_price, :comment, :state, :currency, :client_id, :client_name)
  end
end
