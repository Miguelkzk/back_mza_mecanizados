class CertificateOfMaterialsController < ApplicationController
  include FileUploadable
  before_action :set_certificate_of_material, only: %i[destroy]
  before_action :authenticate_user!
  def upload
    authorize CertificateOfMaterial
    upload_file(CertificateOfMaterial, params[:order_id])
  end

  def destroy
    authorize @certificate_of_material
    if @certificate_of_material.destroy
      render state: :ok
    else
      render state: :unprocessable_entity
    end
  end

  private

  def certificate_of_materials_params
    params.require(:certificate_of_materials).permit(:file, :parent_id, :order_id)
  end

  def set_certificate_of_material
    @certificate_of_material = CertificateOfMaterial.find_by(id: params[:id])
    return if @certificate_of_material.present?

    render state: :not_found
  end
end
