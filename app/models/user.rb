class User < ApplicationRecord
  
  # 「remember_token」という仮装の属性を作成。
  attr_accessor :remember_token
  # 追加したコードでは、before_saveメソッドにブロック{ self.email = email.downcase }を渡してユーザーのメールアドレスを設定します。
  # 現在のメールアドレス（self.email）の値をdowncaseメソッドを使って小文字に変換。
  # selfは、メソッドを呼び出している時点でのユーザーオブジェクトを指しています。
  before_save { self.email = email.downcase }
   # key :value 基本的にはハッシュ[設定したキー]でキーとセットになっているバリューを取り出すことができます。
  validates :name,  presence: true, length: { maximum: 50 } #  name属性に50文字以下であること
  # 下記の正規表現でメールアドレスのフォーマットを検証できる
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
   # emailカラムにも存在性の検証を追加
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true # 一意性(他に同じデータがない)の検証
  validates :department, length: { in: 2..50 }, allow_blank: true # この設定では、値が空文字""の場合バリデーションをスルーします。
  validates :basic_time, presence: true # 存在性の検証
  validates :work_time, presence: true # 存在性の検証
  has_secure_password
  # 存在性（presence）と、最小文字数（6文字以上とする）の2つを設定。
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true # パスワードはスルーして更新できるようにする。 
  
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
   self.remember_token = User.new_token
   update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致すればtrueを返す。
  def authenticated?(remember_token)
   # ダイジェストが存在しない場合はfalseを返して終了します。
   return false if remember_digest.nil?
   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄します。
  def forget
   update_attribute(:remember_digest, nil)
  end
end