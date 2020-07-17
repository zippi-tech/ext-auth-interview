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

class CreditCard < ApplicationRecord
end
