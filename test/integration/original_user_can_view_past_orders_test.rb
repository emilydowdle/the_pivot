require "test_helper"

class UserCanViewPastOrdersTest < ActionDispatch::IntegrationTest
  test "user can view all past orders" do
    category_1 = Category.create(name: "Lard")
    item_1 =
    Item.create(name: "Slotaitems", price: 20,
                description: "Super yummy", category_id: category_1.id)
    user = User.create(username: "John", password: "Password")
    order = user.orders.create(total_price: 20)
    order.item_orders.create(item_id: item_1.id,
                             quantity: 1, subtotal: 20)

    visit "/"

    within(".nav-wrapper") do
      click_link "Login"
    end

    fill_in "Username", with: "John"
    fill_in "Password", with: "Password"

    click_button "Login"

    visit orders_path(user.id)

    assert page.has_content?("#{order.created_at.strftime("%B %d, %Y")}")
  end

  test "user can view a singular past order" do
    category_1 = Category.create(name: "Lard")
    item_1 =
    Item.create(name: "Slotaitems", price: 20,
                description: "Super yummy", category_id: category_1.id)
    user = User.create(username: "John", password: "Password")
    order = user.orders.create(status: "Ordered", total_price: 20)
    order.item_orders.create(item_id: item_1.id,
                             quantity: 1, subtotal: 20)

    visit "/"

    within(".nav-wrapper") do
      click_link "Login"
    end

    fill_in "Username", with: "John"
    fill_in "Password", with: "Password"

    click_button "Login"

    visit orders_path(user.id)

    click_link "View Order Details"
    within(".items_ordered") do
      assert page.has_content?("Slotaitems")
      assert page.has_content?("1")
      assert page.has_content?("20")
      assert page.has_content?("View Item")
      assert page.has_content?("Available")
    end

    within(".order_status") do
      assert page.has_content?("Ordered")
    end
    within(".order_total") do
      assert page.has_content?("20")
    end

    within(".order_status") do
      assert page.has_content?("Ordered: #{order.created_at.strftime("%B %d, %Y")}")
      assert page.has_content?("Status")
      assert page.has_content?("Updated At: ")
    end
  end
end
