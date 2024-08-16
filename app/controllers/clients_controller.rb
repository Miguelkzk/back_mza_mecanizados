class ClientsController < ApplicationController
  before_action :set_client, only: %i[show update destroy]

  def index
    render json: Client.all
  end

  def show
    render json: @client
  end

  def create
    client = Client.new(client_params)

    if client.save
      render json: client, status: :created
    else
      render json: client.error.details, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      render json: @client
    else
      render json: client.error.details, status: :unprocessable_entity
    end
  end

  def destroy
    if @client.destroy
      render json: @client
    else
      render json: client.error.details, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:name)
  end

  def set_client
    @client = Client.find_by(id: params[:id])
    return if @client.present?

    render status: :not_found
  end
end
