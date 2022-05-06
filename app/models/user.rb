# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors.add attribute, (options[:message] || "is not an email")
    end
  end
end

class User < ApplicationRecord
  has_many :bulletins, dependent: :destroy

  validates :name, presence: true, length: { in: 1..256 }
  validates :email, presence: true, uniqueness: true, email: true
end
