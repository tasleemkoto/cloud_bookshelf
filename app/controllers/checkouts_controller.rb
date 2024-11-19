class CheckoutsController < ApplicationController
  
  def index
    @checkouts = checkout.all
  end

  def new
    @checkouts = checkout.new
  end

  def create
    @checkout = Checkout.new(checkout_params)
    if @checkout.save
      redirect_to @checkout, notice: 'Checkout was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end

  end

  def edit
    @checkout = checkout.find(params[:id])

  end

  def update
    @checkout = checkout.find(params[:id])
    if @checkout.update(checkout_params)
      redirect_to @checkout, notice: "checkout successfully updated!"
    else
      render :edit
    end
  end
end
