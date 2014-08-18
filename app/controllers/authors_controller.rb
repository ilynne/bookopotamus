class AuthorsController < ApplicationController
  def index
    @authors = Author.order(:last_name)
    render json: @authors.map{|a| {:last_first => a.last_first}}
  end
end
