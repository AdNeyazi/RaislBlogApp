class Project < ApplicationRecord
  has_rich_text :body
  acts_as_list

  has_one_attached :image

  validates :title, presence: true
  validates :link, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }
  validates :body, presence: true

  before_validation :set_default_position

  private

  def set_default_position
    self.position ||= Project.maximum(:position).to_i + 1
  end
end
