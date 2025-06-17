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

  def contact
  end

  def send_contact
    @contact_message = ContactMessage.new(contact_params)

    if @contact_message.save
      # Here you would typically send an email notification
      flash[:notice] = "Thank you for your message! We'll get back to you soon."
      redirect_to contact_path
    else
      flash.now[:alert] = "There was a problem sending your message. Please try again."
      render :contact, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end
end
