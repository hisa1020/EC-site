require 'rails_helper'

RSpec.feature "Potepan::Categories", type: :feature do
  let(:taxonomy) { create(:taxonomy) }
  let(:taxon) { create(:taxon, taxonomy: taxonomy) }
  let(:image) { create(:image) }
  let(:product) { create(:product, taxons: [taxon]) }
  let!(:product_not_in_taxon) { create(:product, price: 1.00) }

  background do
    product.images << image
    visit potepan_category_path(taxon.id)
  end

  scenario "page_header左側にカテゴリー名を表示" do
    within('.page-title') do
      expect(page).to have_content taxon.name
    end
  end

  scenario "パンくずリストにカテゴリー名を表示" do
    within('.breadcrumb') do
      expect(page).to have_content taxon.name
    end
  end

  scenario "カテゴリー情報を表示" do
    within('.side-nav') do
      expect(page).to have_content taxonomy.name
      taxonomy.taxons.leaves.all? do |taxon|
        expect(page).to have_content taxon.name
        expect(page).to have_content taxon.products.count.to_s
      end
    end
  end

  scenario "各カテゴリー名からcategories/showへ移動" do
    within('.side-nav') do
      click_link taxon.name
      expect(current_path).to eq potepan_category_path(taxon.id)
    end
  end

  scenario "productBoxとtaxon.productsの数が同数" do
    expect(page.all('.productBox').count).to eq taxon.products.count
  end

  scenario "同カテゴリーの商品情報を表示" do
    within('.productBox') do
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price.to_s
      expect(page).to have_selector "img[alt='#{product.name}']"
    end
  end

  scenario "関係のない商品の情報を表示していない" do
    within('.productBox') do
      expect(page).not_to have_content product_not_in_taxon.name
      expect(page).not_to have_content product_not_in_taxon.display_price.to_s
    end
  end

  scenario "各商品のクリックでproducts/showへ移動" do
    within('.productBox') do
      click_link product.name
      expect(current_path).to eq potepan_product_path(product.id)
    end
  end
end
