class User < ApplicationRecord
  has_many :bulletins, foreign_key: 'author_id', dependent: :destroy, inverse_of: 'author'
end
