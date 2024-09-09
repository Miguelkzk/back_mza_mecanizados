class MaterialsController < ApplicationController
  def create
    material = Material.new(materails_params)

    if material.save
      render json: material, status: :created
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
end
