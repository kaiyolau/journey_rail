class Api::V1::GiftsController < ApplicationController
  def create
    # generate a new gift => with a status of "pending"
    # if this gift can be saved into the db
    gift = Gift.new(amount: params[:amount])
    journey = Journey.find_by_id(params[:journey_id])
    gift.sender = current_user
    gift.receiver = journey.user
    gift.journey = journey
    gift.status = "pending"

    if gift.save
      # generate a stripe request to send to stripe to tell them to charge this customer
      Stripe.api_key = 'pk_live_51LfTJUIYP2C9iMUxysiIPo7aoAb47FzDJsnNE3A2xukLiAEEuxjhcA0CSJ8ri1et8f7tS1l4ZzEOzXPUxvwyhWGf00CU4wxq46'
      # Token is created using Stripe Checkout or Elements
      # Get the payment token ID submitted by the form:
      token = params[:stripeToken]
      charge = Stripe::Charge.create({
        amount: params[:amount],
        currency: 'usd',
        description: 'Gift this journey',
        source: token
      })
      # if it's paid => set the status to 'success' => response to the front-end
      if charge&.paid
        gift.update(status: "Success", payment_id: charge.id )
        render(json:{status:200, msg: "success"})
      else # otherwise => set the status to 'failed' => response failed to the front-end
        gift.update(status: 'failed')
        render(json:{status:500, msg: "failed"})
      end

    else
      render(json:{status:401, msg: "check the params"})
    end

  end



end
