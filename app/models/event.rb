class Event < ApplicationRecord
  TAGS = %w[workshop seminar conference dinner party concert kids crafts games festival wine art theater sports poetry literature charity race]
  validates :title, presence: true
  validates :start_time, presence: true

  scope :approved, -> { where(status: "approved") }
  scope :pending, -> { where(status: "pending") }
  scope :upcoming, -> { where("start_time >= ?", Time.current) }
  scope :tagged_with, ->(tag) { where("tags @> ?", "{#{tag}}") }
end
