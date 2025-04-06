class PagesController < ApplicationController
  def home
    Rails.logger.info('pages#home') { 'Rendered the homepage' }

    return unless current_user
    return if current_user.payment_processor.nil?

    # Ensure Stripe is properly configured
    if Stripe.api_key.present?
      @portal_session = current_user.payment_processor.billing_portal
    else
      Rails.logger.error("Stripe API key is missing!")
    end
  end

  def about; end
end
