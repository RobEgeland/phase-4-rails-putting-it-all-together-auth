class RecipesController < ApplicationController
    # rescue_from ActiveRecord::RecordInvalid, with: :render_invalid

    def index 
        recipes = Recipe.all 
        if session.include? :user_id
            render json: recipes, status: :created
        else
            render json: {errors: [login: "Must be logged in to view recipes"]}, status: :unauthorized
        end
    end

    def create 
        if session.include? :user_id
            recipe = Recipe.new(recipe_params)
            recipe.user_id = session[:user_id]
            recipe.save
            if recipe.valid?
                render json: recipe, status: :created 
            else
                render json: {errors: [data: "Invalid Data"]}, status: :unprocessable_entity
            end
        else
            render json: {errors: [login: "Must be logged in to create a recipe"]}, status: :unauthorized
        end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    # def render_invalid(invalid)
    #     render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    # end
end
