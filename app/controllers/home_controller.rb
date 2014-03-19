class HomeController < ApplicationController
  def index
    @user_count = User.count
    @place_count = Place.count
    @place_req_count = PlaceRequest.count
  end

  def map
    @user_count = User.count
    @places = Place.accessible_by(current_ability).includes(:photos)
    @places.each do |place|
      place.desc = view_context.escape_javascript(place.desc)
    end

    respond_to do |format|
      format.html
      format.json { }
    end
  end

  def mobile
  end

  def about
    @user_count = User.count
    @place_count = Place.count
  end

  def press
    @creators = [
      { username: 'zaiste', email: 'oh@zaiste.net', baseline: 'The architect' },
      { username: 'albanlv', email: 'albanlv@gmail.com', baseline: 'The inspiration' },
      { username: 'ferrerb', email: 'ferrerbartomeu@gmail.com', baseline: 'The pollinizer' },
      { username: 'tomkuk', email: 'tomasz.kuklis@gmail.com', baseline: 'The artist coder' },
      { username: 'tukan2can', email: 'tukan2can@gmail.com', baseline: 'The brogrammer' },
      { username: 'mu', email: 'julien.muresianu@gmail.com', baseline: 'The mind' }
    ]
  end
end
