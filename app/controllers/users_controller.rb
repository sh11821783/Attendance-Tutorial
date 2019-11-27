class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
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
    # 「1ヶ月分の勤怠データの中で、出勤時間が何も無い状態では無いものの数を代入」
    @worked_sum = @attendances.where.not(started_at: nil).count # countメソッドは配列の要素数を取得することができます。
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
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      # 更新成功時の処理
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      # 更新失敗時の処理
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  private
  
  # 名前、メールアドレス、所属、パスワード、パスワード再入力カラムの設定
  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end
  
  def basic_info_params
    params.require(:user).permit(:department, :basic_time, :work_time)
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