class MachinesController < ApplicationController
  before_action :set_machine, only: %i[show update destroy generate_routine_sheet show_maintenances generate_corrective_sheet]
  # before_action :authenticate_user!
  def index
    render json: Machine.all
  end

  def show
    render json: @machine
  end

  def create
    machine = Machine.new(machine_params)

    if machine.save
      render json: machine, status: :created
    else
      render json: machine.error.details, status: :unprocessable_entity
    end
  end

  def update
    if @machine.update(machine_params)
      render json: @machine
    else
      render json: machine.error.details, status: :unprocessable_entity
    end
  end

  def destroy
    if @machine.destroy
      render json: @machine
    else
      render json: machine.error.details, status: :unprocessable_entity
    end
  end

  def generate_routine_sheet
    month = params[:month].to_i
    year = params[:year].to_i

    unless month.between?(1, 12) && year.positive?
      return render json: { error: 'Invalid month or year' }, status: :unprocessable_entity
    end

    temp_file = @machine.sheet_routine(month, year)

    if temp_file && File.exist?(temp_file.path)
      file_content = File.read(temp_file.path)
      temp_file.close
      temp_file.unlink

      send_data(
        file_content,
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        filename: "Rutina_#{month}_#{year}_#{@machine.code}.xlsx"
      )
    else
      render json: { error: 'Archivo no encontrado' }, status: :internal_server_error
    end
  end

  def generate_corrective_sheet
    temp_file = @machine.sheet_corrective(nil, nil)
    if temp_file && File.exist?(temp_file.path)
      file_content = File.read(temp_file.path)
      temp_file.close
      temp_file.unlink

      send_data(
        file_content,
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        filename: "Correctivo#{@machine.code}.xlsx"
      )
    else
      render json: { error: 'Archivo no encontrado' }, status: :internal_server_error
    end
  end

  def show_maintenances
    render json: @machine.maintenances
  end

  private

  def set_machine
    @machine = Machine.find_by(id: params[:id])
    return if @machine.present?

    render status: :not_found
  end

  def machine_params
    params.require(:machine).permit(:code, :brand, :model, :horsepower, :routine_detail,
                                    :corrective_detail, :preventive_detail)
  end
end
