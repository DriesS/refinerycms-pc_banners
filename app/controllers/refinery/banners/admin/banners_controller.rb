module Refinery
  module Banners
    module Admin
      class BannersController < ::Refinery::AdminController

        crudify :'refinery/banners/banner',
                :title_attribute => 'name', :xhr_paging => true

        private
          def banner_params
            params.require(:banner).permit!
          end

      end
    end
  end
end
