class TransactionController < ApplicationController
  before_action :validate_transaction_params, only: [:create]
  before_action :set_credit_card, only: [:create]

  def create
    if @credit_card.status != 'active' || @credit_card.limit_cents < params[:amount]
      return render status: :payment_required
    end

    ZippiMediator.submit_transaction(
      amount_cents: params[:amount],
      occurred_at: params[:datetime],
    )

    updated_limit = @credit_card.limit_cents - params[:amount]
    @credit_card.update(limit_cents: updated_limit)

    render status: :ok
  end

  private
  def validate_transaction_params
    params.require(%i[id amount datetime])
    
    params[:amount] = (Float(params[:amount]) * 100).round
    params[:datetime] = DateTime.
      strptime(params[:datetime], "%d/%m/%Y %R").
      change(:offset => "-0300")
  end

  def set_credit_card
    @credit_card = CreditCard.find(params[:id])
  end
end
