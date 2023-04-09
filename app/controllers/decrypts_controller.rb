class DecryptsController < ApplicationController
  def new
    @decrypt = Decrypt.new
  end

  def create
    @decrypt = Decrypt.new(decrypt_params.merge(user_id: current_user.id))
    if @decrypt.valid?
      @decrypt.save
      DecryptService.new(decrypt: @decrypt).call!
      redirect_to decrypt_path(@decrypt), notice: 'Decryption was successfully created'
    else
      flash.now[:alert] = @decrypt.errors.full_messages.join(',')
      render :new
    end
  end

  def show
    @decrypt = Decrypt.find(params[:id])
    @decrypt_tries = @decrypt.decrypt_tries
  end

  private
  def decrypt_params
      params.require(:decrypt).permit(:enc_message)
  end
end
