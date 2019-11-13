class UsersController < ApplicationController
  # Usersコントローラにリクエストが送信されると、
  # 下記のparams[:id]は/users/1の1に置き換わります。
  # つまり、User.find(params[:id])は、User.find(1)となります。
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new # ユーザーオブジェクトを生成し、インスタンス変数に代入します。
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = '新規作成に成功しました。'
      # 保存に成功した場合は、ここに記述した処理が実行されます。
      redirect_to @user
    else
      render :new
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end