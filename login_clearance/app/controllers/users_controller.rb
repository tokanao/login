class UsersController < Clearance::UsersController

#   def create
# binding.pry 
#     @user = ::User.find_by_id_and_confirmation_token(
#       params[:user_id], params[:token])
#     @user.confirm_email!
#
#     sign_in(@user)
#     flash_success_after_create
#     redirect_to(url_after_create)
#   end
end
