Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope '/transaction' do
    post '', to: 'transaction#create'
  end
end
