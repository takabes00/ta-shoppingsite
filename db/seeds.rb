Rails.application.config.active_record.whitelist_attributes = false
 
ActiveRecord::Base.class_eval do
  class << self
    def create_or_update! attrs={}
      instance = first_or_initialize(attrs)
      instance.save!
    end
  end
end
 
Spree::Config[:currency] = "JPY"
 
 
# PaymentMethod
Spree::PaymentMethod::Check.create_or_update!({
    :name => "チェック",
    :description => "Pay by check.",
    :active => true
  })
 
 
# Taxonomy
Spree::Taxonomy.create_or_update!({:name => 'カテゴリ名'})
 
 
# OptionType
Spree::OptionType.create_or_update!({
  :name => "オプションタイプの名称",
  :presentation => "オプションタイプの表示名",
  :position => 1
  })
 
 
# Property
Spree::Property.create_or_update!({
  :name => "プロパティの名称",
  :presentation => "プロパティの表示名",
  })
 
 
# Prototype
Spree::Prototype.create_or_update!({
  :name => "プロトタイプの名称",
  :properties => [Spree::Property.first]
  })
 
 
# Country
Spree::Country.create_or_update!({"name"=>"日本", "iso3"=>"JPN", "iso"=>"JP", "iso_name"=>"JAPAN", "numcode"=>"392"})
 
 
# Zone
Spree::Zone.create_or_update!({:name => "全国共通", :description => "日本全国"})
Spree::Zone.first.zone_members.create_or_update!(:zoneable => Spree::Country.first)
 
# ShippingCategory
Spree::ShippingCategory.create_or_update!({:name => "通常梱包"})
 
 
# ShippingMethod
Spree::ShippingMethod.create_or_update!({
  :name => "ヤマト宅急便 ",
  :zones => [Spree::Zone.first],
  :shipping_categories => [Spree::ShippingCategory.first],
  :calculator => Spree::Calculator::PerItem.create!({:preferred_amount => 600, :preferred_currency => "JPY"}),
  :calculator_type => "Spree::Calculator::Shipping::PerItem"
  })
 
 
# State
country = Spree::Country.first
unless Spree::State.any?
  Spree::State.create!({"name"=>"北海道", "abbr"=>"Hokkaido", :country=>country})
  Spree::State.create!({"name"=>"青森県", "abbr"=>"Aomori", :country=>country})
  Spree::State.create!({"name"=>"岩手県", "abbr"=>"Iwate", :country=>country})
  Spree::State.create!({"name"=>"宮城県", "abbr"=>"Miyagi", :country=>country})
  Spree::State.create!({"name"=>"秋田県", "abbr"=>"Akita", :country=>country})
  Spree::State.create!({"name"=>"山形県", "abbr"=>"Yamagata", :country=>country})
  Spree::State.create!({"name"=>"福島県", "abbr"=>"Fukushima", :country=>country})
  Spree::State.create!({"name"=>"茨城県", "abbr"=>"Ibaraki", :country=>country})
  Spree::State.create!({"name"=>"栃木県", "abbr"=>"Tochigi", :country=>country})
  Spree::State.create!({"name"=>"群馬県", "abbr"=>"Gunma", :country=>country})
  Spree::State.create!({"name"=>"埼玉県", "abbr"=>"Saitama", :country=>country})
  Spree::State.create!({"name"=>"千葉県", "abbr"=>"Chiba", :country=>country})
  Spree::State.create!({"name"=>"東京都", "abbr"=>"Tokyo", :country=>country})
  Spree::State.create!({"name"=>"神奈川県", "abbr"=>"Kanagawa", :country=>country})
  Spree::State.create!({"name"=>"新潟県", "abbr"=>"Niigata", :country=>country})
  Spree::State.create!({"name"=>"富山県", "abbr"=>"Toyama", :country=>country})
  Spree::State.create!({"name"=>"石川県", "abbr"=>"Ishikawa", :country=>country})
  Spree::State.create!({"name"=>"福井県", "abbr"=>"Fukui", :country=>country})
  Spree::State.create!({"name"=>"山梨県", "abbr"=>"Yamanashi", :country=>country})
  Spree::State.create!({"name"=>"長野県", "abbr"=>"Nagano", :country=>country})
  Spree::State.create!({"name"=>"岐阜県", "abbr"=>"Gifu", :country=>country})
  Spree::State.create!({"name"=>"静岡県", "abbr"=>"Shizuoka", :country=>country})
  Spree::State.create!({"name"=>"愛知県", "abbr"=>"Aichi", :country=>country})
  Spree::State.create!({"name"=>"三重県", "abbr"=>"Mie", :country=>country})
  Spree::State.create!({"name"=>"滋賀県", "abbr"=>"Shiga", :country=>country})
  Spree::State.create!({"name"=>"京都府", "abbr"=>"Kyoto", :country=>country})
  Spree::State.create!({"name"=>"大阪府", "abbr"=>"Osaka", :country=>country})
  Spree::State.create!({"name"=>"兵庫県", "abbr"=>"Hyogo", :country=>country})
  Spree::State.create!({"name"=>"奈良県", "abbr"=>"Nara", :country=>country})
  Spree::State.create!({"name"=>"和歌山県", "abbr"=>"Wakayama", :country=>country})
  Spree::State.create!({"name"=>"鳥取県", "abbr"=>"Tottori", :country=>country})
  Spree::State.create!({"name"=>"島根県", "abbr"=>"Shimane", :country=>country})
  Spree::State.create!({"name"=>"岡山県", "abbr"=>"Okayama", :country=>country})
  Spree::State.create!({"name"=>"広島県", "abbr"=>"Hiroshima", :country=>country})
  Spree::State.create!({"name"=>"山口県", "abbr"=>"Yamaguchi", :country=>country})
  Spree::State.create!({"name"=>"徳島県", "abbr"=>"Tokushima", :country=>country})
  Spree::State.create!({"name"=>"香川県", "abbr"=>"Kagawa", :country=>country})
  Spree::State.create!({"name"=>"愛媛県", "abbr"=>"Ehime", :country=>country})
  Spree::State.create!({"name"=>"高知県", "abbr"=>"Kochi", :country=>country})
  Spree::State.create!({"name"=>"福岡県", "abbr"=>"Fukuoka", :country=>country})
  Spree::State.create!({"name"=>"佐賀県", "abbr"=>"Saga", :country=>country})
  Spree::State.create!({"name"=>"長崎県", "abbr"=>"Nagasaki", :country=>country})
  Spree::State.create!({"name"=>"熊本県", "abbr"=>"Kumamoto", :country=>country})
  Spree::State.create!({"name"=>"大分県", "abbr"=>"Oita", :country=>country})
  Spree::State.create!({"name"=>"宮崎県", "abbr"=>"Miyazaki", :country=>country})
  Spree::State.create!({"name"=>"鹿児島県", "abbr"=>"Kagoshima", :country=>country})
  Spree::State.create!({"name"=>"沖縄県", "abbr"=>"Okinawa", :country=>country})
end
 
 
# TaxCategory
Spree::TaxCategory.create_or_update!({:name => "消費税一般", :is_default => true})
 
 
# TaxRate
Spree::TaxRate.create_or_update!({
  :name => "全国共通",
  :zone => Spree::Zone.first, 
  :amount => 0.05,
  :tax_category => Spree::TaxCategory.first,
  :calculator => Spree::Calculator::DefaultTax.create!
})
 
# Product
Spree::Product.create_or_update!({
  :name => "最初の商品",
  :price => 1000,
  :shipping_category => Spree::ShippingCategory.first,
  :tax_category => Spree::TaxCategory.first,
  :description => '商品説明',
  :available_on => Time.zone.now
  })
 
# Variant
Spree::Variant.create_or_update!({
  :product => Spree::Product.first,
  :sku => 'sku-001',
  :cost_price => 100
  })
Spree::Product.first.master.update_attributes!({
  :sku => 'sku-001',
  :cost_price => 100  
  })
 
 
# StockLocation
Spree::StockLocation.create_or_update!({
  :name => 'デフォルトの倉庫',
  :active => true,
  :country => Spree::Country.first
  })
# Spree::StockMovement.create_or_update!(:quantity => 100, :stock_item => Spree::Variant.first.stock_items.first)
Spree::StockMovement.create(:quantity => 100, :stock_item => Spree::Variant.first.stock_items.first)
 
 
# Admin
# email = 'spree@example.com'
# password = 'spree123'
# Spree::User.create_or_update!({
#   :password => password,
#   :password_confirmation => password,
#   :email => email,
#   :login => email,
#   :spree_roles => [Spree::Role.find_or_create_by_name('admin')]
#   })