require 'spec_helper'

module Spree
  describe Api::IntegratorController do
    render_views

    before { stub_authentication! }

    context '#index' do
      it 'gets all available collections' do
        api_get :index

        expect(json_response['collections']).to have(5).items
      end

      it 'all collections should be available to show' do
        api_get :index

        json_response['collections'].each do |collection|

          api_get "show_#{collection['name']}", since: 3.days.ago.utc.to_s,
            page: 1,
            per_page: 1

          response.should be_ok
        end
      end
    end

    context '#show_orders' do
      it 'gets orders changed since' do
        order = create(:completed_order_with_totals)
        Order.update_all(:updated_at => 2.days.ago)

        api_get :show_orders, since: 3.days.ago.utc.to_s,
          page: 1,
          per_page: 1

        json_response['orders']['count'].should eq 1
        json_response['orders']['current_page'].should eq 1

        json_response['orders']['page'].first['number'].should eq order.number
        json_response['orders']['page'].first.should have_key('ship_address')
        json_response['orders']['page'].first.should have_key('bill_address')
        json_response['orders']['page'].first.should have_key('payments')
        json_response['orders']['page'].first.should have_key('credit_cards')
      end
    end

    context '#show_stock_transfers' do
      it 'gets stock_transfers changed since' do
        source = create(:stock_location)
        destination = create(:stock_location_with_items, :name => 'DEST101')
        stock_transfer = StockTransfer.create do |transfer|
          transfer.source_location_id = source.id
          transfer.destination_location_id = destination.id
          transfer.reference = 'PO 666'
        end
        StockTransfer.update_all(:updated_at => 2.days.ago)

        StockMovement.create do |movement|
          movement.stock_item = source.stock_items.first
          movement.quantity = -1
          movement.originator = stock_transfer
        end

        StockMovement.create do |movement|
          movement.stock_item = destination.stock_items.first
          movement.quantity = 1
          movement.originator = stock_transfer
        end

        api_get :show_stock_transfers, since: 3.days.ago.utc.to_s,
          page: 1,
          per_page: 1

        transfer = json_response['stock_transfers']['page'].first
        transfer['destination_location']['name'].should eq 'DEST101'
        transfer['destination_movements'].first['quantity'].should eq 1
      end
    end

    context '#show_products' do
      it 'gets products changed since' do
        product = create(:product)
        Product.update_all(:updated_at => 2.days.ago)

        api_get :show_products, since: 3.days.ago.utc.to_s,
          page: 1,
          per_page: 1

        json_response['products']['count'].should eq 1
        json_response['products']['current_page'].should eq 1
        json_response['products']['page'].first['id'].should eq product.id
      end
    end

    context '#show_users' do
      it 'gets users changed since' do
        user = create(:user)
        Spree.user_class.update_all(:updated_at => 2.days.ago)

        api_get :show_users, since: 3.days.ago.utc.to_s,
          page: 1,
          per_page: 1

        json_response['users']['count'].should eq 1
        json_response['users']['current_page'].should eq 1
        json_response['users']['page'].first['id'].should eq user.id
      end
    end

    context '#show_return_authorizations' do
      it 'gets return_authorizations changed since' do
        return_authorization = create(:return_authorization)
        ReturnAuthorization.update_all(:updated_at => 2.days.ago)

        api_get :show_return_authorizations, since: 3.days.ago.utc.to_s,
          page: 1,
          per_page: 1

        json_response['return_authorizations']['count'].should eq 1
        json_response['return_authorizations']['current_page'].should eq 1
        json_response['return_authorizations']['page'].first['id'].should eq return_authorization.id
      end
    end
  end
end

