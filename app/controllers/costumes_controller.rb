class CostumesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_costume, only: %i[edit update destroy]

  def index
    @costumes = Costume.all
  end

  def show
    @costume = Costume.find(params[:id])
    @booking = Booking.new
  end

  def new
    # Reste à faire : gérer les authorisation avec devise
    @costume = Costume.new
  end

  def create
    # attention ne marche pas si user non connecté, il faut gérer les authorisation avec devise
    costume = Costume.new(costume_params)
    costume.owner = current_user
    if costume.save
      redirect_to costume_path(costume)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # le bouton ne doit s'afficher que pour le owner
  end

  def update
    @costume.update(costume_params)
    if costume.save
      redirect_to costume_path(costume)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # le bouton ne doit s'afficher que pour le owner
    @costume.destroy
    redirect_to restaurants_path, status: :see_other
  end

  def my_costumes
    # Reste à faire : gérer les authorisation avec devise
    @costumes = Costume.where(owner: "current_user")
  end

  private

  def costume_params
    params.require(:costume).permit(:photo, :size, :price, :condition, :name, :min_duration, :age, :gender, :description)
  end

  def set_costume
    @costume = Costume.find(params[:id])
  end

  def owner?
    @costume = Costume.find(params[:id])
    @costume.owner == current_user
  end
end
