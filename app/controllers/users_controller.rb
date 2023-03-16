class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_vendeur_or_admin!
  
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_status_user, :toggle_status_vendeur, :toggle_status_admin]


    def index
      @users = User.all.where(role: 0).order(:id)
      @vendeurs = User.all.where(role: 1).order(:id)
      @admins = User.all.where(role: 2).order(:id) 
    end 

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = User.find(params[:id])
    end


    def update
        respond_to do |format|
            if @user.update(friend_params)
              format.html { redirect_to user_url(@user), notice: "user was successfully updated." }
              format.json { render :show, status: :ok, location: @user }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
          end
        
    end

    def toggle_status_user
      @user.user!
      redirect_to users_url, notice: "le rôle a bien été modifié"
    end

    def toggle_status_vendeur
      @user.vendeur!
      redirect_to users_url, notice: "le rôle a bien été modifié"
    end

    def toggle_status_admin
      @user.admin!
      redirect_to users_url, notice: "le rôle a bien été modifié"
    end
      
    def editer_mail()
      @user = User.first
      puts @user

    #  UserMailer.with(user: @user)
     # .welcome().deliver_now
      #flash[:notice] = "le mail user a bien été envoyé"
      #redirect_to user_path(@user)
    end 



      private

      def authenticate_vendeur_or_admin!
        unless current_user && (current_user.vendeur? || current_user.admin?)
          redirect_to root_path, alert: "Vous n'avez pas accès à cette page."
        end
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end
   

     # Only allow a list of trusted parameters through.
     def user_params
        params.require(:user).permit(:email, :username, :role)
      end
  

end
