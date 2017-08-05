require_dependency "landlord/application_controller"

module Landlord
  class ProfileController < ApplicationController
    before_action :authenticate_user!

    # Display User Profile form
    # GET /profile
    def edit
    end

    # Save User Profile data
    # PATCH/PUT /profile
    def update
      respond_to do |format|
        current_user.assign_attributes(user_params)

        notice = 'Profile was successfully updated.'
        notice = "A confirmation link has been sent to your new email address. Please click it to complete your update." if current_user.email_changed?

        if current_user.save
          format.html { redirect_to edit_profile_path, notice: notice }
          format.json { render :edit, status: :ok, location: current_user }
        else
          format.html { render :edit }
          format.json { render json: current_user.errors, status: :unprocessable_entity }
        end
      end
    end

    private

      def user_params
        params[:user] = params[:user].except(:password, :password_confirmation) if params[:user][:password].empty?
        params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
      end

  end
end
