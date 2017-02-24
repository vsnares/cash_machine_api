class Api::CashMachineController < ApplicationController
  respond_to :json

  def charge
    service = ChargeService.new(params[:hash_of_coins]).run
    if service.success?
      render :status => 200,
             :json => { success: true, balance: service.result }
    else
      render :status => 422,
             :json => { success: false , errors: service.errors[:message] }
    end
  end

  def withdraw
    service = WithdrawService.new(amount: params[:sum]).run

    if service.success?
      render json: { success: service.success, result: service.result }, status: :ok
    else
      render json: { success: service.success, errors: service.errors[:message] }, status: :unprocessable_entity
    end
  end
end
