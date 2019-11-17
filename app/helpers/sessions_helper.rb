module SessionsHelper

  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 永続的セッションを記憶します（Userモデルを参照）。
  # 下記のコードにより、ログインするユーザーはブラウザで
  # 有効な記憶トークンを取得できるよう記録されます
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄します。
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # セッションと@current_user（ログイン中のユーザー）を破棄します
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
  # 追加したcurrent_userの機能で、「現在ログインしているユーザー」の値を取得できる。
  # 一時的セッションにいるユーザーを返します。それ以外の場合はcookiesに対応するユーザーを返します。
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。
  def current_user?(user)
    user == current_user
  end


  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def logged_in?
    !current_user.nil?
  end
  
  # 記憶しているURL（またはデフォルトURL）にリダイレクトします。
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLを記憶します。
  # 記憶したいURLはrequestオブジェクトを使い、request.original_urlと記述する事で取得できます。
  # ページへのアクセスのみを記憶するためrequest.get?を条件式に指定してGETリクエストのみを記憶するように記述。
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
# このlog_inヘルパーメソッドを定義したことにより、ユーザーのログインを行って
# createアクションを完了してユーザー情報ページへリダイレクトする準備が整いました。
# 追加したcurrent_userの機能で、「現在ログインしているユーザー」の値を取得できる。