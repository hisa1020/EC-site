require 'rails_helper'

RSpec.describe Potepan::ProductDecorator, type: :model do
  let(:taxonomy) { create(:taxonomy) }
  let(:taxon) { create(:taxon, taxonomy: taxonomy) }
  let!(:product) { create(:product, taxons: [taxon]) }
  let!(:related_product1) { create(:product, taxons: [taxon]) }
  let!(:related_product2) { create(:product, taxons: [taxon]) }
  let!(:duplicate_products) do
    Spree::Product.in_taxons(related_product2.taxons)
  end
  let!(:not_related_product) { create(:product) }

  it "同じカテゴリーの商品を取得している" do
    expect(product.related_products).to include related_product1
    expect(product.related_products).to include related_product2
  end

  it "メインの商品が関連商品に含まれていない" do
    expect(product.related_products).not_to include product
  end

  it "関係のない商品が含まれていない" do
    expect(product.related_products).not_to include not_related_product
  end

  it "関連商品に重複がない" do
    expect(product.related_products == product.related_products.uniq).to be true
  end
end
