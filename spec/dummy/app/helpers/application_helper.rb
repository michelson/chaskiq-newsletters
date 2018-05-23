module ApplicationHelper

  def current_user
    User.last
  end
end
