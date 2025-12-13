module Api
  class MenusController < ApplicationController
    before_action :set_restaurant
    before_action :set_menu, only: %i[show update destroy]

    def index
      @menus = @restaurant.menus
      render json: @menus
    end

    def show
      render json: @menu
    end

    def create
      @menu = @restaurant.menus.new(menu_params)

      if @menu.save
        render json: @menu, status: :created
      else
        render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @menu.update(menu_params)
        render json: @menu
      else
        render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @menu.destroy
      head :no_content
    end

    private

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Restaurant not found' }, status: :not_found
    end

    def set_menu
      @menu = @restaurant.menus.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Menu not found' }, status: :not_found
    end

    def menu_params
      params.require(:menu).permit(:name, :description, :price, :category, :dietary_type)
    end
  end
end
