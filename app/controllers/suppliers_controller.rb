class SuppliersController < ApplicationController
  before_action :set_supplier, only: %i[show update destroy show_notes]
  before_action :authenticate_user!

  def index_with_note
    authorize Supplier
    name = params[:name]
    suppliers = Supplier.by_name(name).all

    render json:
      suppliers.map { |supplier|
        {
          id: supplier.id,
          name: supplier.name,
          phone: supplier.phone,
          email: supplier.email,
          note: supplier.average_note.round(2)
        }
      }
  end

  def index
    authorize Supplier
    name = params[:name]
    suppliers = Supplier.by_name(name).all

    render json: suppliers
  end

  def show
    authorize @supplier
    render json: @supplier
  end

  def show_notes
    authorize Supplier
    render json: {
      total_note: @supplier.average_note.round(2),
      average_quality_note: @supplier.average_note(:quality_note).round(2),
      average_cost_note: @supplier.average_note(:cost_note).round(2),
      average_delivery_note: @supplier.average_note(:delivery_note).round(2),
      average_service_note: @supplier.average_note(:service_note).round(2),
      average_methods_of_payment_note: @supplier.average_note(:methods_of_payment_note).round(2),
      evaluations: @supplier.assessments.order(assessed_at: :desc)
    }
  end

  def create
    authorize Supplier
    supplier = Supplier.new(supplier_params)

    if supplier.save
      render json: supplier, status: :created
    else
      render json: supplier.error.details, status: :unprocessable_entity
    end
  end

  def update
    authorize @supplier
    if @supplier.update(supplier_params)
      render json: @supplier
    else
      render json: supplier.error.details, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @supplier
    if @supplier.destroy
      render json: @supplier
    else
      render json: supplier.error.details, status: :unprocessable_entity
    end
  end

  private

  def supplier_params
    params.require(:supplier).permit(:name, :phone, :email)
  end

  def set_supplier
    @supplier = Supplier.find_by(id: params[:id])
    return if @supplier.present?

    render status: :not_found
  end
end
