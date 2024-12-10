class RemunerationsController < ApplicationController
  before_action :set_remuneration, only: %i[show_childrens]
  before_action :authenticate_user!

  def show_parents
    remunerations = Remuneration.where(parent_id: nil, parent_type: nil)
    remunerations = remunerations.sort_by { |r| r.date }
    render json: remunerations
  end

  def show_childrens
    childrens = @remuneration.remunerations
    parent_and_childrens = [@remuneration].compact + childrens
    parent_and_childrens.sort_by! { |r| r.date }
    render json: parent_and_childrens
  end

  def create_remuneration_for_month
    RemunerationService.create_remuneration_for_month(params[:month])

    render json: { message: 'Remuneration created' }, status: :created
  end

  private

  def set_remuneration
    @remuneration = Remuneration.find_by(id: params[:id])
    return @remuneration if @remuneration.present?

    render json: { error: 'Remuneration not found' }, status: :not_found
  end

  def remuneration_params
    params.require(:remuneration).permit(:month)
  end
end
