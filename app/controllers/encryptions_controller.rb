class EncryptionsController < ApplicationController
    before_action :authenticate_user!
    def index
    end

    def new
        @encryption = Encryption.new
    end

    def show
        @encryption = Encryption.find(params[:id])
    end

    def create
        @encryption = Encryption.new(encryption_params.merge(user_id: current_user.id))
        if @encryption.valid?
            @encryption.save
            EncryptionService.new(encryption: @encryption).call!
            redirect_to encryption_path(@encryption), notice: 'Encryption was successfully created'
        else
            flash.now[:alert] = @encryption.errors.full_messages.join(',')
            render :new
        end
    end

    private
    def encryption_params
        params.require(:encryption).permit(:message, :a, :b)
    end
end
