class User < ApplicationRecord
  # 追加したコードでは、before_saveメソッドにブロック{ self.email = email.downcase }を渡してユーザーのメールアドレスを設定します。
  # 現在のメールアドレス（self.email）の値をdowncaseメソッドを使って小文字に変換
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
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 } # 存在性（presence）と、最小文字数（6文字以上とする）の2つを設定
end