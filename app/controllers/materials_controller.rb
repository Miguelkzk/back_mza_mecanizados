class MaterialsController < ApplicationController
  before_action :set_material, only: %i[destroy update]
  before_action :authenticate_user!
  def create
    authorize Material
    material = Material.new(materails_params)

    if material.save
      render json: material, status: :created
    else
      render json: material.error.details, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @material
    if @material.destroy
      render json: @material
    else
      render json: material.error.details, status: :unprocessable_entity
    end
  end

  def update
    authorize @material
    if @material.update(materails_params)
      render json: @material
    else
      render json: material.error.details, status: :unprocessable_entity
    end
  end

  private

  def materails_params
    params.require(:material).permit(:description, :quantity,
                                     :supplier_note, :ingresed_at, :supplier_id,
                                     :order_id)
  end

  def set_material
    @material = Material.find_by(id: params[:id])
    return @material if @material.present?

    render status: :not_found
  end
end
