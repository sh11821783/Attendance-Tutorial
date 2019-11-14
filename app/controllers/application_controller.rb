class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # include SessionsHelperにより、モジュールの読み込みを設定できました。
  include SessionsHelper
end