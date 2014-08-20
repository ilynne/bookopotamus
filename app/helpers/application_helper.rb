module ApplicationHelper
  def devise_links
    if current_user # user_signed_in?
      link_to 'Log Out User', destroy_user_session_path, method: :delete
    else
      link_to 'Log In', new_user_session_path
    end
  end

  def delete_text(book)
    book.deleteable? ? 'Delete' : 'Deactivate'
  end
end
