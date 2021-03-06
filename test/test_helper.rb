ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require "rails/test_help"
require "capybara/rails"
require "mocha/mini_test"
require "simplecov"
require "minitest/pride"

SimpleCov.start("rails")

class ActiveSupport::TestCase

  def setup
  end

  def create_user
    User.create(username: "John", password: "Password")
    user.roles << Role.find_by(name: "registered_user")
  end

  def create_shop
    category_1 = Category.create(name: "Lard")
    category_2 = Category.create(name: "Coconut Category")
    Item.create(name: "Slotaitems", price: 20,
                description: "Super yummy", category_id: category_1.id)
    Item.create(name: "Dang Coconut", price: 17,
                description: "Dang, these are good", category_id: category_2.id)
    Item.create(name: "Old Items", price: 20,
                description: "Super yummy", category_id: category_1.id,
                status: "retired")
  end

  def create_item(name, price, description)
    Item.create(name: name, price: price,
                description: description)
  end

  def create_cart(item)
    @cart = Cart.new( { item.id.to_s => 1 } )
  end

  def create_two_item_cart
    @item1 = create_item("Slotaitem", 6.99, "yummy")
    @item2 = create_item("Doritos", 2.99, "cheesy")
    create_cart(@item1)
    @cart.add_item(@item2.id.to_s)
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
  end

  def create_item(name, price, description)
    Item.create(name: name, price: price,
                description: description)
  end

  def create_user
    @user = User.create(username: "emily", password: "password", first_name: "Emily", last_name: "Dowdle")
  end

  def create_admin_and_store
    @admin = User.create(username: "admin", password: "password")
    @admin.roles.create(name: "business_admin")
    @store = Store.create(name: "GoatSoap")
    @store.users << @admin
  end

  def create_active_store
    @active_store = Store.create(name:"Some Active Store",
                        status: "accepted")
  end

  def create_pending_store
    @pending_store = Store.create(name:"Some Pending Store",
                        status: "Pending")
  end

  def create_declined_store
    @declined_store = Store.create(name:"Some Declined Store",
                        status: "declined")
  end

  def create_platform_admin
    @platform_admin = User.create(username: "platform_admin", password: "password")
    @platform_admin.roles.create(name: "platform_admin")
  end

  def create_cart_for_visitor
    visit items_path
    within("#items") do
      click_button "Add to Cart"
    end
  end

  def login_user
    visit "/"
    within(".nav-wrapper") do
      click_link "Login"
    end
    fill_in "Username", with: "emily"
    fill_in "Password", with: "password"
    click_button "Login"
  end

  def login_admin
    visit "/"
    within(".nav-wrapper") do
      click_link "Login"
    end
    fill_in "Username", with: "admin"
    fill_in "Password", with: "password"
    click_button "Login"
  end

  def login_platform_admin
    visit "/"
    within(".nav-wrapper") do
      click_link "Login"
    end
    fill_in "Username", with: "platform_admin"
    fill_in "Password", with: "password"
    click_button "Login"
  end

  def create_shop
    category_1 = Category.create(name: "Lard")
    category_2 = Category.create(name: "Coconut Category")
    Item.create(name: "Slotaitems", price: 20,
                description: "Super yummy", category_id: category_1.id)
    Item.create(name: "Dang Coconut", price: 17,
                description: "Dang, these are good", category_id: category_2.id)
    Item.create(name: "Old Items", price: 20,
                description: "Super yummy", category_id: category_1.id,
                status: "retired")
  end

  def create_shop_and_logged_in_user
    create_shop
    user = create_user
    order = user.orders.create(total_price: 20)
    order.item_orders.create(item_id: Item.all.first.id,
                             quantity: 1, subtotal: 20)
    order.item_orders.create(item_id: Item.all.last.id,
                             quantity: 1, subtotal: 20)

    login_user

    visit orders_path
    click_link("View Order Details")
  end

  def create_order(status, price, user_id)
    Order.create(status: status, total_price: price, user_id: user_id)
  end

  def teardown
    reset_session!
  end
end

DatabaseCleaner.strategy = :transaction

class Minitest::Spec
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
