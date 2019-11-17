class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  # Usersコントローラにリクエストが送信されると、
  # 下記のparams[:id]は/users/1の1に置き換わります。
  # つまり、User.find(params[:id])は、User.find(1)となります。

  # 全てのユーザーを表示するため、全ユーザーが代入されたインスタンス変数。
  # よって、複数形であるため@users。
  def index # ユーザー一覧ページ
    # User.paginateは:pageパラメータに基づき、データベースからひとかたまりのデータを取得します。
    # つまり1ページ目ではidが1から30までのユーザー、2ページ目は31から60までのユーザーという具合にデータが取り出されます。
    @users = User.paginate(page: params[:page]) # キーが:pageで値がページ番号のハッシュを引数にとります。
  end
  
  def show
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後、ログインします。
      flash[:success] = '新規作成に成功しました。'
      # 保存に成功した場合は、ここに記述した処理が実行されます。
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit # 編集ページ
  end
  
  def update # 更新ページ
    # update_attributes:データベースのレコードを複数同時に更新することができるメソッド
    if @user.update_attributes(user_params)
      # 更新に成功した場合の処理を記述します。
      # サクセスメッセージの代入。
      flash[:success] = "ユーザー情報を更新しました。"
      # リダイレクト先をユーザー情報ページに指定する。
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  # beforeフィルター
  
  
  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end
  
  
  # ログイン済みのユーザーか確認します。logged_in_userメソッドはprivateキーワード下に定義。
  def logged_in_user
    # unless文により、ログインしていないユーザーだった場合リダイレクトされるようになっています。
    # unlessは条件式がfalseの場合のみ記述した処理が実行される構文です。
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      # リダイレクトされた時点でアクションは終了するので編集ページが開かれることはない仕組み。
      redirect_to login_url
    end
  end
  
  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # システム管理権限所有かどうか判定します。  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end