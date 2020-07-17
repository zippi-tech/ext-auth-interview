# frozen_string_literal: true

# == Schema Information
#
# Table name: credit_cards
#
#  id          :integer          not null, primary key
#  status      :string
#  limit_cents :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


FactoryBot.define do
  factory :credit_card do
    status { 'active' }
    limit_cents { 100000 }
  end
end
