class ClientsController < ApplicationController
  before_action :set_client, only: %i[show update destroy]
  before_action :authenticate_user!
  def index
    authorize Client
    name = params[:name]
    render json: Client.by_name(name).all
  end

  def show
    authorize @client
    render json: @client
  end

  def create
    authorize Client
    client = Client.new(client_params)

    if client.save
      render json: client, status: :created
    else
      render json: client.error.details, status: :unprocessable_entity
    end
  end

  def update
    authorize @client
    if @client.update(client_params)
      render json: @client
    else
      render json: client.error.details, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @client
    if @client.destroy
      render json: @client
    else
      render json: client.error.details, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :state, :phone, :email)
  end

  def set_client
    @client = Client.find_by(id: params[:id])
    return if @client.present?

    render status: :not_found
  end
end
