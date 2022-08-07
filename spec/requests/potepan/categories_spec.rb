require 'rails_helper'

RSpec.describe "Potepan::Categories", type: :request do
  let(:taxonomy) { create(:taxonomy) }
  let(:taxon) { create(:taxon, taxonomy: taxonomy) }
  let(:image) { create(:image) }
  let(:product) { create(:product, taxons: [taxon]) }
  let!(:product_not_in_taxon) { create(:product, price: 1.00) }

  before do
    product.images << image
    get potepan_category_path(taxon.id)
  end

  it "statusが200であること" do
    expect(response.status).to eq(200)
  end

  it "カテゴリー情報の取得" do
    expect(response.body).to include taxonomy.name
    taxonomy.taxons.leaves.all? do |taxon|
      expect(response.body).to include taxon.name
      expect(response.body).to include taxon.products.count.to_s
    end
  end

  it "同カテゴリーの商品情報を取得" do
    expect(response.body).to include product.name
    expect(response.body).to include product.display_price.to_s
  end

  it "関係のない商品情報を取得していない" do
    expect(response.body).not_to include product_not_in_taxon.name
    expect(response.body).not_to include product_not_in_taxon.display_price.to_s
  end
end
