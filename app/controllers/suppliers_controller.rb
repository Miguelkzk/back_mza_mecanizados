class SuppliersController < ApplicationController
  before_action :set_supplier, only: %i[show update destroy]

  def index
    name = params[:name]
    render json: Supplier.by_name(name).all
  end

  def show
    render json: @supplier
  end

  def create
    supplier = Supplier.new(supplier_params)

    if supplier.save
      render json: supplier, status: :created
    else
      render json: supplier.error.details, status: :unprocessable_entity
    end
  end

  def update
    if @supplier.update(supplier_params)
      render json: @supplier
    else
      render json: supplier.error.details, status: :unprocessable_entity
    end
  end

  def destroy
    if @supplier.destroy
      render json: @supplier
    else
      render json: supplier.error.details, status: :unprocessable_entity
    end
  end

  private

  def supplier_params
    params.require(:supplier).permit(:name)
  end

  def set_supplier
    @supplier = Supplier.find_by(id: params[:id])
    return if @supplier.present?

    render status: :not_found
  end
end
