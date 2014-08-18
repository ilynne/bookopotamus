class Author < ActiveRecord::Base
  has_many :books

  def last_first
    last_name.present? ? "#{last_name}, #{first_name}" : nil
  end

  def last_first=(name)
    name_parts = name.split(', ')
    self.last_name = name_parts[0]
    self.first_name = name_parts[1]
  end
end
