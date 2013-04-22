class StaticController < ApplicationController
  def welcome
  end

  def default
    render params[:page]
  end
end
