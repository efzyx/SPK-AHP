class CriterionsController < ApplicationController
  before_action :authenticate_user! , except: [:index]
    before_action :set_criterion, only: [:edit, :update, :destroy]

    def index
      @criterions = Criterion.all.order(id: :asc)
    end

    def new
      @criterion = Criterion.new
    end

    def edit
    end

    def create
      @criterion = Criterion.new(criterion_params)

        if @criterion.save
          redirect_to new_criterion_path, notice: 'Kriteria berhasil disimpan'
        else
          render :new
          flash[:warning] = 'Gagal simpan, periksa kembali'
        end
    end

    def update
        if @criterion.update(criterion_params)
          redirect_to edit_criterion_path, notice: 'Kriteria berhasil dirubah.'
        else
          render :edit
          flash[:warning] = 'Gagal update, periksa kembali'
        end
    end

    def destroy
      @criterion.destroy
      redirect_to criterions_url, notice: 'Kriteria berhasil dihapus'
    end

    private
      def set_criterion
        @criterion = Criterion.find(params[:id])
      end

      def criterion_params
        params.require(:criterion).permit(:name)
      end
  end
