class Post < ApplicationRecord
  belongs_to :author
  belongs_to :genre
end
