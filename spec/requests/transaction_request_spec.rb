require 'rails_helper'

RSpec.describe "Transaction", type: :request do
  context 'for active CreditCard' do
    let!(:credit_card) { FactoryBot.create(:credit_card, status: 'active', limit_cents: 25000) }

    it 'allows below limit transactions' do
      post '/transaction', params: { amount: 125.01, datetime: '01/02/2019 17:10', id: credit_card.id }
      expect(response).to have_http_status(:ok)
    end

    it 'calls ZippiMediator' do
      expect(ZippiMediator).to receive(:submit_transaction).with(
        amount_cents: 3348,
        occurred_at: Time.new(2019, 2, 1, 17, 10, 0, '-03:00')
      )
      post '/transaction', params: { amount: 33.48, datetime: '01/02/2019 17:10', id: credit_card.id }
    end

    it 'doesn\'t allow above limit transactions' do
      post '/transaction', params: { amount: 250.01, datetime: '01/02/2019 17:10', id: credit_card.id }
      expect(response).to have_http_status(:payment_required)
    end

    it 'updates limit after each transaction' do
      post '/transaction', params: { amount: 33.48, datetime: '01/02/2019 17:10', id: credit_card.id }
      expect(response).to have_http_status(:ok)
      credit_card.reload
      expect(credit_card.limit_cents).to eq(21652)

      post '/transaction', params: { amount: 216.53, datetime: '02/02/2019 10:01', id: credit_card.id }
      expect(response).to have_http_status(:payment_required)
    end
  end

  context 'for blocked CreditCard' do
    let!(:credit_card) { FactoryBot.create(:credit_card, status: 'blocked', limit_cents: 30000) }

    it 'doesn\'t allow below limit transactions' do
      post '/transaction', params: { amount: 125.01, datetime: '01/02/2019 17:10', id: credit_card.id }
      expect(response).to have_http_status(:payment_required)
    end

    it 'doesn\'t allow above limit transactions' do
      post '/transaction', params: { amount: 350.01, datetime: '01/02/2019 17:10', id: credit_card.id }
      expect(response).to have_http_status(:payment_required)
    end
  end

  

  context 'returns if request is malformed' do
    it 'for missing amount' do
      post '/transaction', params: { datetime: '02/02/2019 10:01', id: 1 }
      expect(response).to have_http_status(:bad_request)
    end

    it 'for missing datetime' do
      post '/transaction', params: { amount: 1.99, id: 1 }
      expect(response).to have_http_status(:bad_request)
    end

    it 'for missing id' do
      post '/transaction', params: { amount: 1.99, datetime: '02/02/2019 10:01' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'for sending a non-parsable amount' do
      post '/transaction', params: { amount: 'test', datetime: '02/02/2019 10:01', id: 1 }
      expect(response).to have_http_status(:bad_request)
    end

    it 'for sending a non-parsable time' do
      post '/transaction', params: { amount: 1.99, datetime: '123', id: 1 }
      expect(response).to have_http_status(:bad_request)
    end

    it 'for sending an unregistered id' do
      post '/transaction', params: { amount: 1.99, datetime: '02/02/2019 10:01', id: 1 }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
