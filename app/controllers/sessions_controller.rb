class SessionsController < ApplicationController

  def new
  end

  def create
    # ログインフォームから受け取ったemailの値を使ってユーザーオブジェクトを検索しています。
    # downcaseメソッドを呼び出すことで、入力したメールアドレスは全て小文字として判定されます。
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user # ログイン後にユーザー情報ページにリダイレクトします。
    else
      # ここにはエラーメッセージ用のflashを入れます。
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  def destroy
    log_out
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end