class AdminsBackoffice::AdminsController < AdminsBackofficeController
  before_action :verify_password, only: [:update]
  before_action :set_admin, only: [:edit, :update, :destroy]

  def index
    # Abir um console dentro da aplicação
    console
    @admins = Admin.all.page(params[:page])
    
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(params_admin)
    if @admin.save
      redirect_to admins_backoffice_admins_path, notice: "Admin criado com sucesso!"
    else
      render :enew
      @admin.errors
    end
  end

  def edit
  end

  def update
    if @admin.update(params_admin)
      AdminMailer.update_email(current_admin, @admin).deliver_now
      redirect_to admins_backoffice_admins_path, notice: "Admin atualizado com sucesso!"
    else
      render :edit
      @admin.errors
    end
  end

  def destroy
    if @admin.destroy
      redirect_to admins_backoffice_admins_path, notice: "Admin excluído com sucesso!"
    else
      render :index
    end
  end

  private

  def verify_password
    if params[:admin][:password].blank? && params[:admin][:password].blank?
      params[:admin].extract!(:password, :password_confirmation)
    end
  end

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def params_admin
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end
