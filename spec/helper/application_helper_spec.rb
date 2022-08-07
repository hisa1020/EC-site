require 'rails_helper'

RSpec.describe "ApplicationHelper", type: :helper do
  describe "#full_title" do
    context "page_titleがnilの場合" do
      it "BIGBAG Storeをタイトルに返す" do
        expect(helper.full_title(nil)).to eq("BIGBAG Store")
      end
    end

    context "page_titleが空文字の場合" do
      it "BIGBAG Storeをタイトルに返す" do
        expect(helper.full_title("")).to eq("BIGBAG Store")
      end
    end

    context "page_titleがあるとき" do
      it "Return page_name - BIGBAG Storeをタイトルに返す" do
        expect(helper.full_title(:page_name)).to eq("page_name - BIGBAG Store")
      end
    end
  end
end
