class OrderItemsController < OrdersController
  before_action :authenticate_user!
  	def index
    	@items = current_cart.order.items
    end

    def create
    	current_cart.add_item(

  		product_id: params[:product_id],
  		quantity: params[:quantity]
  		
  		)

  		redirect_to new_order_path 

    end

   

    def destroy
	  	current_cart.remove_item(id: params[:id])
	  	redirect_to new_order_path
  	end

  	private

  	def product_params
      params.require(:order_item).permit(:quantity)
    end

end