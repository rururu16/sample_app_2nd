class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "初期表示"
  end
end
