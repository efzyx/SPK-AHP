class AlternativesController < ApplicationController
  before_action :set_alternative, only: [:edit, :update, :destroy]

  def index
    @alternatives = Alternative.all
  end

  def new
    @alternative = Alternative.new
  end

  def edit
  end

  def create
    @alternative = Alternative.new(alternative_params)

      if @alternative.save
        redirect_to new_alternative_path, notice: 'Alternatif berhasil disimpan'
      else
        render :new
      end
  end

  def update
      if @alternative.update(alternative_params)
        redirect_to edit_alternative_path, notice: 'Alternatif was successfully updated.'
      else
        render :edit
      end
  end

  def destroy
    @alternative.destroy
    redirect_to alternatives_url, notice: 'Alternatif was successfully destroyed.'
  end

  private
    def set_alternative
      @alternative = Alternative.find(params[:id])
    end

    def alternative_params
      params.require(:alternative).permit(:name)
    end
end
