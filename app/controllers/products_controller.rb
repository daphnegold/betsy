class ProductsController < ApplicationController

before_action only: [:show, :edit, :update] { @product = Product.find(params[:id]) }

  def index
    @products = Product.order(stock: :desc)
  end

  def show
    @review = Review.new(product_id: @product.id)
    if @current_order.orderitems.where("product_id = ?", params[:id]).first
      @order_item = @current_order.orderitems.where("product_id = ?", params[:id]).first
    else
      @order_item = Orderitem.new(product_id: @product.id)
    end
  end

  def category
    @category = Category.find_by(name: params[:category_name])
    @products = @category.products
  end

  def robot
    @robot = Robot.find_by(params[:id])
    @products = @robot.products.where(retire: false)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to product_path(id: @product.id)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    @product.update(product_params)
    if @product.save
      redirect_to robot_path(current_robot)
    else
      render 'edit'
    end
  end

  private

  def product_params
    params.require(:product).permit([:name, :description, :price, :robot_id, :categories, :picture_url, :stock, :category_ids => []])
  end
end
