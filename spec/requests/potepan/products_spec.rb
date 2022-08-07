require 'rails_helper'

RSpec.describe "Potepan::Products", type: :request do
  let(:taxonomy) { create(:taxonomy) }
  let(:taxon) { create(:taxon, taxonomy: taxonomy) }
  let(:product) { create(:product, taxons: [taxon]) }
  let(:image) { create(:image) }
  let(:related_products) do
    5.times.collect do |i|
      create(:product, name: "product#{i + 1}", price: "#{i + 1}", taxons: [taxon])
    end
  end
  let!(:not_related_product) { create(:product, price: 6.00) }

  before do
    product.images << image
    related_products.each do |related_product|
      related_product.images << create(:image)
    end
    get potepan_product_path(product.id)
  end

  it "statusが200であること" do
    expect(response.status).to eq(200)
  end

  it "商品情報の取得" do
    expect(response.body).to include product.name
    expect(response.body).to include product.display_price.to_s
    expect(response.body).to include product.description
  end

  it "4件の関連商品情報を取得" do
    related_products[0..3].all? do |related_product|
      expect(response.body).to include related_product.name
      expect(response.body).to include related_product.display_price.to_s
    end
  end

  it "4件を超える商品情報を取得していない" do
    expect(response.body).not_to include related_products[4].name
  end

  it "関係のない商品情報を取得していない" do
    expect(response.body).not_to include not_related_product.name
    expect(response.body).not_to include not_related_product.display_price.to_s
  end
end
