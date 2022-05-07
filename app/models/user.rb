# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bulletins, dependent: :destroy

  validates :name, presence: true, length: { in: 1..256 }
  validates :email, presence: true, uniqueness: true
end
