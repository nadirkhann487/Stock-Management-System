class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update,:item_status]
  before_action :current_cart, only: [:new,:edit]
  after_action :clear_token, only: [:show]
  helper_method :current_cart
   helper_method :order_dispatched


  def item_status
    @item = OrderItem.find(params[:item_id])
    if @item.status == 'Picked'
      @item.update_attribute(:status, 'Not Picked')
    else
     @item.update_attribute(:status, 'Picked')
   end

    if @order.items.find_by(status: 'Not Picked')
      @order.update_attribute(:status, 'open') 
    else
      @order.update_attribute(:status, 'Picked') 
    end
    redirect_to @order
  end

  def current_cart
    @current_cart ||= OrderCart.new(token: cart_token)
  end

  def order_dispatched 
     @item = Order.find(params[:item_id])
    
      @item.update_attributes(:status => "Dispatched", :dispatch_date => params[:date], :mode_of_transport => params[:mode], :responsible_person => params[:responsible_person])
      redirect_to action: 'index', notice: 'Order was successfully dispatched.'
  end

  # GET /orders
  # GET /orders.json
  def index
    if @order = Order.find_by(status: "cart")
      session[:cart_token] = @order.token
      @cart_token = session[:cart_token]   
    end
    @q = Order.ransack(params[:q])
    if ["manager","salesperson"].include?(current_user.user_type.downcase)  
      @orders = @q.result(distinct: true).where.not(status: "cart").sort_by{ |m| m.status.downcase }
    elsif current_user.user_type.downcase == 'picker'
      @orders = @q.result(distinct: true).where(status: "open").sort_by{ |m| m.status.downcase }
    else
      @orders = @q.result(distinct: true).where(status: "Picked").sort_by{ |m| m.status.downcase }
      render :dispatch
    end
     
  end


  # GET /orders/1
  # GET /orders/1.json
  def show
   
  end

  # GET /orders/new
  def new
    @order = current_cart.order
    @items = @order.items
  end

  # GET /orders/1/edit
  def edit
     @order = current_cart.order
    @items = @order.items
  end

  # POST /orders
  # POST /orders.json
  
  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update_attributes(order_params.merge(status: 'open'))
        @cart_token = nil
        session[:cart_token] = nil
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
      session[:cart_token] = @order.token
      @cart_token = session[:cart_token]
      @items = @order.items.sort_by{ |m| m.status.downcase }
    end

  def cart_token
    return @cart_token unless @cart_token.nil?

    session[:cart_token] ||= SecureRandom.hex{8}
    @cart_token = session[:cart_token]
  end

  def clear_token
     @cart_token = nil
      session[:cart_token] = nil

  end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:first_name, :last_name, :token, :status, :dispatch_priority)
    end
end
