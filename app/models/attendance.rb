class Attendance < ApplicationRecord
  belongs_to :user
  # worked_on:日付取り扱い
  validates :worked_on, presence: true
  # note:備考
  validates :note, length: { maximum: 50 }
  
  # 出勤時間が存在しない場合、退勤時間は無効。
  validate :finished_at_is_invalid_without_a_started_at

  # started_at:出勤時刻 finished_at:出勤時刻
  def finished_at_is_invalid_without_a_started_at
      # blank?は対象がnil "" " " [] {}のいずれかでtrueを返します。
      # present?はその逆（値が存在する場合）にtrueを返します。
      # つまり「出勤時間が無い、かつ退勤時間が存在する場合」、trueとなって処理が実行されるわけです。
      errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
end