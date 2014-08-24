module ApplicationHelper
  # def devise_links
  #   if current_user # user_signed_in?
  #     link_to 'Log Out User', destroy_user_session_path, method: :delete
  #   else
  #     link_to 'Log In', new_user_session_path
  #   end
  # end

  def delete_text(book)
    book.deleteable? ? 'Delete' : 'Deactivate'
  end

  def current_user_admin(user)
    user.admin? ? ' [admin] ' : ''
  end

  def book_status(book)
    book.active? ? 'Active' : 'Inactive'
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'
    # arrow = direction == 'asc' ? '^' : 'v'
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
      when :success
        'alert-success'
      when :error
        'alert-danger'
      when :alert
        'alert-block'
      when :notice
        'alert-info'
      else
        flash_type.to_s
    end
  end
end
