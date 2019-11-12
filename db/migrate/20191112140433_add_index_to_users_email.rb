class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    # usersテーブルのemailカラムにインデックスを追加するため、add_indexというRailsのメソッドを記述しています。
    add_index :users, :email, unique: true # add_indexにunique: trueオプションを指定することでデータベースに一意性を強制することができる
  end
end
