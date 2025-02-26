class AssessmentsController < ApplicationController
  before_action :set_assessment, only: %i[destroy update]
  def create
    assessment = Assessment.new(assessment_params)

    if assessment.save
      render json: assessment, status: :created
    else
      render json: assessment.error.details, status: :unprocessable_entity
    end
  end

  def destroy
    if @assessment.destroy
      render json: @assessment
    else
      render json: assessment.error.details, status: :unprocessable
    end
  end

  def update
    if @assessment.update(assessment_params)
      render json: @assessment
    else
      render json: @assessment.error.details, status: :unprocessable
    end
  end

  def set_assessment
    @assessment = Assessment.find_by(id: params[:id])
    return @assessment if @assessment.present?

    render status: :not_found
  end

  private

  def assessment_params
    params.require(:assessment).permit(:quality_note, :ponderation_quality, :cost_note, :ponderation_cost,
                                       :delivery_note, :ponderation_delivery, :service_note,
                                       :ponderation_service, :methods_of_payment_note, :ponderation_methods_of_payment,
                                       :supplier_id, :assessed_at)
  end
end
