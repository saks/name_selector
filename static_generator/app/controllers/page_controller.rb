class PageController < ApplicationController
  def index
  end

  def names
    render json: { '1' => 'one name', '2' => 'another name' }
  end
end
