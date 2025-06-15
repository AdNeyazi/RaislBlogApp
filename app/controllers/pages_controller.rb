class PagesController < ApplicationController
  def home
    Rails.logger.info('pages#home') { 'Rendered the homepage' }

    # Eager load body since it's used in the view
    @posts = Post.includes(:rich_text_body).order(created_at: :desc).limit(3)

    return unless current_user
    return if current_user.payment_processor.nil?

    if Stripe.api_key.present?
      @portal_session = current_user.payment_processor.billing_portal
    else
      Rails.logger.error("Stripe API key is missing!")
    end
  end

  def about; end
end
