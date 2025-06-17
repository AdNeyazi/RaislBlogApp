class ContactMessage < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, 
            format: { with: URI::MailTo::EMAIL_REGEXP },
            length: { maximum: 255 }
  validates :subject, presence: true, length: { minimum: 2, maximum: 200 }
  validates :message, presence: true, length: { minimum: 10, maximum: 5000 }
  validates :status, presence: true, 
            inclusion: { in: %w[unread read replied archived] }

  scope :unread, -> { where(status: 'unread') }
  scope :read, -> { where(status: 'read') }
  scope :replied, -> { where(status: 'replied') }
  scope :archived, -> { where(status: 'archived') }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update(status: 'read')
  end

  def mark_as_replied!
    update(status: 'replied')
  end

  def archive!
    update(status: 'archived')
  end
end
