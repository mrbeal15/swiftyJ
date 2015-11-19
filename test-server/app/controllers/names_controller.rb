class NamesController < ApplicationController
  require 'json'
  def index
    @names = Group.find(1).names

    render :json => @names
  end

  def coord
    @names = Group.find(1).names
    render :json => @names
  end

  def create
    p "========================================"
    p name_params["coord"]
    p "========================================"
    @name = Name.create(name: name_params["name"])

  end

  def destroy

  end

  private

  def name_params
    params.permit(:name, :coord)
  end
end
