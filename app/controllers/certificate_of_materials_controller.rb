class CertificateOfMaterialsController < ApplicationController
  include FileUploadable

  def upload
    upload_file(CertificateOfMaterial, params[:order_id])
  end

  private

  def certificate_of_materials_params
    params.require(:certificate_of_materials).permit(:file, :parent_id, :order_id)
  end

end
