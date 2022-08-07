require 'rails_helper'

RSpec.feature "Potepan::Products", type: :feature do
  let(:taxonomy) { create(:taxonomy) }
  let(:taxon) { create(:taxon, taxonomy: taxonomy) }
  let(:product) { create(:product, taxons: [taxon]) }
  let(:image) { create(:image) }
  let(:related_products) do
    4.times.collect do |i|
      create(:product, name: "product#{i + 1}", price: "#{i + 1}", taxons: [taxon])
    end
  end
  let!(:not_related_product) { create(:product, price: 6.00) }

  background do
    product.images << image
    related_products.each do |related_product|
      related_product.images << create(:image)
    end
    visit potepan_product_path(product.id)
  end

  scenario "ロゴのクリックでpotepan_pathへ移動" do
    find('.navbar-brand').click
    expect(current_path).to eq potepan_path
  end

  scenario "navbar右側HOMEからpotepan_pathへ移動" do
    within('.navbar-right') do
      click_on "Home"
      expect(current_path).to eq potepan_path
    end
  end

  scenario "パンくずリストHOMEからpotepan_pathへ移動" do
    within('.breadcrumb') do
      click_on "Home"
      expect(current_path).to eq potepan_path
    end
  end

  scenario "page_header左側に商品名を表示" do
    within('.page-title') do
      expect(page).to have_content product.name
    end
  end

  scenario "パンくずリストに商品名を表示" do
    within('.breadcrumb') do
      expect(page).to have_content product.name
    end
  end

  scenario "一覧ページへ戻るからproducts/showへ移動" do
    click_on "一覧ページへ戻る"
    expect(current_path).to eq potepan_category_path(product.taxons.first.id)
  end

  scenario "商品情報を表示" do
    within('.singleProduct') do
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price.to_s
      expect(page).to have_content product.description
      expect(page).to have_selector "img[alt='#{product.name}']"
    end
  end

  scenario "関連商品の商品情報を表示" do
    related_products.all? do |related_product|
      expect(page).to have_content related_product.name
      expect(page).to have_content related_product.display_price.to_s
      expect(page).to have_selector "img[alt='#{related_product.name}']"
    end
  end

  scenario "4つの関連商品が表示されている" do
    expect(page.all('.productBox').count).to eq 4
  end

  scenario "関連商品のクリックで各商品詳細ページへ移動" do
    within('.productsContent') do
      related_products.each_with_index do |related_product, i|
        page.all(".productBox")[i].click_link related_product.name
        expect(current_path).to eq potepan_product_path(related_product.id)
      end
    end
  end

  scenario "メインの商品が関連商品に含まれていない" do
    within('.productsContent') do
      expect(page).not_to have_content product.name
      expect(page).not_to have_content product.display_price.to_s
    end
  end

  scenario "関係のない商品の情報を表示していない" do
    within('.productsContent') do
      expect(page).not_to have_content not_related_product.name
      expect(page).not_to have_content not_related_product.display_price.to_s
    end
  end
end
