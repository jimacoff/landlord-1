require 'stripe_event'
require 'landlord'

# Initialize Stripe and StripeEvent gems

Rails.configuration.stripe = {
  publishable_key: ENV['stripe_publishable_key'], # Get this from Stripe dashboard
  secret_key:      ENV['stripe_api_key'],         # Get this from Stripe dashboard
  webhook_secret:  ENV['stripe_webhook_secret'],  # Define this in app, then include in webhook URL (Stripe dashboard)
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.authentication_secret = Rails.configuration.stripe[:webhook_secret]

StripeEvent.event_retriever = lambda do |params|
  return nil if Landlord::StripeWebhook.exists?(stripe_id: params[:id])
  Landlord::StripeWebhook.create!(stripe_id: params[:id])
  Stripe::Event.retrieve(params[:id])
end

StripeEvent.configure do |events|

  # Occurs whenever any property of a customer changes.
  events.subscribe 'customer.updated' do |event|
    Landlord::Account.update_from_stripe_customer_event(event)
  end

  # Occurs whenever a card's details are changed.
  events.subscribe 'customer.source.updated' do |event|
    Landlord::Account.update_from_stripe_card_event(event)
  end

  # Occurs three days before the trial period of a subscription is scheduled to end.
  events.subscribe 'customer.subscription.trial_will_end' do |event|
    subscription = event.data.object
    account = Landlord::Account.find_by(stripe_id: subscription.customer)
    if account
      Landlord::AccountMailer.trial_will_end(account).deliver_later
    end
  end

  # Occurs whenever a customer with no subscription is signed up for a plan.
  events.subscribe 'customer.subscription.created' do |event|
    Landlord::Account.update_from_stripe_subscription_event(event)
  end

  # Occurs whenever a subscription changes. Examples would include switching from one plan to another, or switching status from trial to active.
  events.subscribe 'customer.subscription.updated' do |event|
    Landlord::Account.update_from_stripe_subscription_event(event)
  end

  # Occurs whenever a customer ends their subscription.
  events.subscribe 'customer.subscription.deleted' do |event|
    Landlord::Account.update_from_stripe_subscription_event(event)
  end

  # Occurs whenever a new charge is created and is successful.
  events.subscribe 'charge.succeeded' do |event|
    charge = event.data.object
    receipt = Landlord::Receipt.save_from_stripe(charge)
    if receipt
      Landlord::ReceiptMailer.succeeded(receipt).deliver_later
    end
  end

  # Occurs whenever a failed charge attempt occurs.
  events.subscribe 'charge.failed' do |event|
    charge = event.data.object
    receipt = Landlord::Receipt.save_from_stripe(charge)
    if receipt
      Landlord::ReceiptMailer.failed(receipt).deliver_later
    end
  end

  # Occurs whenever a charge is refunded, including partial refunds.
  events.subscribe 'charge.refunded' do |event|
    charge = event.data.object
    receipt = Landlord::Receipt.save_from_stripe(charge)
    if receipt
      Landlord::ReceiptMailer.refunded(receipt).deliver_later
    end
  end

  # Occurs whenever a customer disputes a charge with their bank (chargeback).
  events.subscribe 'charge.dispute.created' do |event|
    Landlord::SupportMailer.message('Stripe dispute', 'charge.dispute.created: ' + event.id).deliver_later
  end

end