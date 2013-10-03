module Spree
  module Api
    class IntegratorController < Spree::Api::BaseController
      helper_method :collection_attributes,
        :stock_transfer_attributes

      respond_to :json

      def index
        @collections = [
          OpenStruct.new({ name: 'orders',                 token: 'number',  frequency: '5.minutes' }),
          OpenStruct.new({ name: 'users',                  token: 'number',  frequency: '5.minutes' }),
          OpenStruct.new({ name: 'products',               token: 'number',  frequency: '1.hour' }),
          OpenStruct.new({ name: 'return_authorizations',  token: 'id',      frequency: '1.hour' }),
          OpenStruct.new({ name: 'stock_transfers',        token: 'id',      frequency: '1.hour' })
        ]
      end

      def show_orders
        @since  = params[:since] || 1.day.ago
        @orders = orders(@since)
      end

      def show_stock_transfers
        @since           = params[:since] || 1.day.ago
        @stock_transfers = stock_transfers(@since)
      end

      def show_products
        @since    = params[:since] || 1.day.ago
        @products = products(@since)
      end

      private
      def orders(since)
        Spree::Order.complete
                    .ransack(:updated_at_gteq => since).result
                    .page(params[:page])
                    .per(params[:per_page])
                    .order('updated_at ASC')
      end

      def stock_transfers(since)
        Spree::StockTransfer
                    .ransack(:updated_at_gteq => since).result
                    .page(params[:page])
                    .per(params[:per_page])
                    .order('updated_at ASC')
      end

      def products(since)
        Spree::Product
                    .ransack(:updated_at_gteq => since).result
                    .page(params[:page])
                    .per(params[:per_page])
                    .order('updated_at ASC')
      end

      def collection_attributes
        [:name, :token, :frequency]
      end

      def stock_transfer_attributes
        [:id, :reference_number, :created_at, :updated_at]
      end
    end
  end
end

