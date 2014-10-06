require 'acts_as_indexed'

module Refinery
  module Banners
    class Banner < Refinery::Core::BaseModel
      self.table_name = 'refinery_banners'

      acts_as_indexed :fields => [:name, :url, :title, :description]

      # attr_accessible :name, :title, :description, :image_id, :url, :is_active, :start_date, :expiry_date, :position, :page_ids, :locale

      validates :name, :presence => true
      validates_presence_of :start_date
      validates_length_of :title, :in => 0..255, :allow_nil => true
      validates_length_of :description, :in => 0..255, :allow_nil => true
          
      belongs_to :image, :class_name => '::Refinery::Image'
      has_and_belongs_to_many :pages, :class_name => '::Refinery::Page', :join_table => 'refinery_banners_pages'

      scope :not_expired, lambda {
        banners = Arel::Table.new(::Refinery::Banners::Banner.table_name)
        where(banners[:expiry_date].eq(nil).or(banners[:expiry_date].gt(Time.now)))
      }
      scope :active, where(:is_active => true)
      scope :published, lambda {
        not_expired.active.where("start_date <= ?", Time.now).order(:position)
      }
      scope :publish_in_current_locale, lambda{
        not_expired.active.where("start_date <= ?", Time.now).where("locale = ? or locale = ''", ::I18n.locale).order(:position)
      }

    end
  end
end