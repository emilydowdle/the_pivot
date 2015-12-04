require "test_helper"

class VisitorCanAddItemsToCartTest < ActionDispatch::IntegrationTest

  test "visitor can add items to cart from index" do
    category_1 = Category.create(name: "Lard")
    category_2 = Category.create(name: "Coconut Category")

    Item.create(name: "Slotaitems", price: 20,
                description: "Super yummy", category_id: category_1.id)
    Item.create(name: "Trader Joe's BBQ", price: 15,
                description: "I'd trade slota for these!",
                category_id: category_2.id)
    Item.create(name: "Dang Coconut", price: 17,
                description: "Dang, these are good", category_id: category_2.id)
    Item.create(name: "Lard Yummies", price: 19,
                description: "Chock Full of Lard", category_id: category_1.id)

    visit items_path

    within(".nav-wrapper") do
      assert page.has_content?("Cart (0)")
    end

    within("#all-items") do
      click_button "Add to Cart"
    end

    assert page.has_content?("Added Slotaitems to cart.")
    assert page.has_content?("Cart (1)")

    within(".nav-wrapper") do
      click_link "Cart"
    end

    assert_equal cart_items_path, current_path

    assert page.has_content?("Slotaitems")
    assert page.has_content?("20")
    assert page.has_content?("Super yummy")
    assert page.has_content?("Total: $20")
  end

  test "can add multiple items to cart" do
    category_1 = Category.create(name: "Lard")
    category_2 = Category.create(name: "Coconut Category")

    Item.create(name: "Slotaitems", price: 20,
                description: "Super yummy", category_id: category_1.id)
    Item.create(name: "Trader Joe's BBQ", price: 15,
                description: "I'd trade slota for these!",
                category_id: category_2.id)
    Item.create(name: "Dang Coconut", price: 17,
                description: "Dang, these are good", category_id: category_2.id)
    Item.create(name: "Lard Yummies", price: 19,
                description: "Chock Full of Lard", category_id: category_1.id)

    visit items_path

    assert page.has_content?("Cart (0)")

    within("#all-items") do
      click_button "Add to Cart"
    end

    assert page.has_content?("Added Slotaitems to cart.")
    assert page.has_content?("Cart (1)")

    within("#lard-yummies") do
      click_button "Add to Cart"
    end

    within(".nav-wrapper") do
      click_link "Cart"
    end

    assert_equal cart_items_path, current_path

    assert page.has_content?("Slotaitems")
    assert page.has_content?("20")
    assert page.has_content?("Super yummy")

    assert page.has_content?("Lard Yummies")
    assert page.has_content?("19")
    assert page.has_content?("Chock Full of Lard")

    assert page.has_content?("Total: $39")
  end

  test "can add item to cart from category show pages" do
    category_1 = Category.create(name: "Lard")
    category_2 = Category.create(name: "Coconut Category")

    Item.create(name: "Slotaitems", price: 20,
                description: "Super yummy", category_id: category_1.id)
    Item.create(name: "Trader Joe's BBQ", price: 15,
                description: "I'd trade slota for these!",
                category_id: category_2.id)
    Item.create(name: "Dang Coconut", price: 17,
                description: "Dang, these are good", category_id: category_2.id)
    Item.create(name: "Lard Yummies", price: 19,
                description: "Chock Full of Lard", category_id: category_1.id)

    visit "/lard"

    assert page.has_content?("Cart (0)")

    within("#all-items") do
      click_button "Add to Cart"
    end

    assert page.has_content?("Added Slotaitems to cart.")
    assert page.has_content?("Cart (1)")

    within(".nav-wrapper") do
      click_link "Cart"
    end

    assert_equal cart_items_path, current_path

    assert page.has_content?("Slotaitems")
    assert page.has_content?("20")
    assert page.has_content?("Super yummy")
    assert page.has_content?("Total: $20")
  end
end
