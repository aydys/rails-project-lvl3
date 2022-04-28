class User < ApplicationRecord
  has_many :bulletins, dependent: :destroy
end
