module OffsitePayments #:nodoc:
  module Integrations #:nodoc:
    module DirecPay
      mattr_accessor :production_url, :test_url

      self.production_url = "https://www.timesofmoney.com/direcpay/secure/dpMerchantTransaction.jsp"
      self.test_url       = "https://test.direcpay.com/direcpay/secure/dpMerchantTransaction.jsp"

      def self.service_url
        mode = OffsitePayments.mode
        case mode
        when :production
          self.production_url
        when :test
          self.test_url
        else
          raise StandardError, "Integration mode set to an invalid value: #{mode}"
        end
      end

      def self.notification(post, options = {})
        Notification.new(post)
      end

      def self.return(query_string, options = {})
        Return.new(query_string, options)
      end

      def self.request_status_update(mid, transaction_id, notification_url)
        Status.new(mid).update(transaction_id, notification_url)
      end

      class Helper < OffsitePayments::Helper
        mapping :account,  'MID'
        mapping :order,    'Merchant Order No'
        mapping :amount,   'Amount'
        mapping :currency, 'Currency'
        mapping :country,  'Country'

        mapping :billing_address,  :city     => 'custCity',
                                   :address1 => 'custAddress',
                                   :state    => 'custState',
                                   :zip      => 'custPinCode',
                                   :country  => 'custCountry',
                                   :phone    => 'custMobileNo'

        mapping :shipping_address, :name     => 'deliveryName',
                                   :city     => 'deliveryCity',
                                   :address1 => 'deliveryAddress',
                                   :state    => 'deliveryState',
                                   :zip      => 'deliveryPinCode',
                                   :country  => 'deliveryCountry',
                                   :phone    => 'deliveryMobileNo'

        mapping :customer, :name  => 'custName',
                           :email => 'custEmailId'

        mapping :description, 'otherNotes'
        mapping :edit_allowed, 'editAllowed'

        mapping :return_url, 'Success URL'
        mapping :failure_url, 'Failure URL'

        mapping :operating_mode, 'Operating Mode'
        mapping :other_details, 'Other Details'
        mapping :collaborator, 'Collaborator'

        OPERATING_MODE = 'DOM'
        COUNTRY        = 'IND'
        CURRENCY       = 'INR'
        OTHER_DETAILS  = 'NULL'
        EDIT_ALLOWED   = 'Y'

        PHONE_CODES = {
          'IN' => '91',
          'US' => '01',
          'CA' => '01'
        }

        ENCODED_PARAMS = [ :account, :operating_mode, :country, :currency, :amount, :order, :other_details, :return_url, :failure_url, :collaborator ]

        def initialize(order, account, options = {})
          super
          collaborator = OffsitePayments.mode == :test || options[:test] ? 'TOML' : 'DirecPay'
          add_field(mappings[:collaborator], collaborator)
          add_field(mappings[:country], 'IND')
          add_field(mappings[:operating_mode], OPERATING_MODE)
          add_field(mappings[:other_details], OTHER_DETAILS)
          add_field(mappings[:edit_allowed], EDIT_ALLOWED)
        end


        def customer(params = {})
          add_field(mappings[:customer][:name], full_name(params))
          add_field(mappings[:customer][:email], params[:email])
        end

        # Need to format the amount to have 2 decimal places
        def amount=(money)
          cents = money.respond_to?(:cents) ? money.cents : money
          raise ArgumentError, "amount must be a Money object or an integer" if money.is_a?(String)
          raise ActionViewHelperError, "amount must be greater than $0.00" if cents.to_i <= 0

          add_field(mappings[:amount], sprintf("%.2f", cents.to_f/100))
        end

        def shipping_address(params = {})
          super(update_address(:shipping_address, params))
        end

        def billing_address(params = {})
          super(update_address(:billing_address, params))
        end

        def form_fields
          add_failure_url
          add_request_parameters

          unencoded_parameters
        end

        private

        def add_request_parameters
          params = ENCODED_PARAMS.map{ |param| fields[mappings[param]] }
          encoded = encode_value(params.join('|'))

          add_field('requestparameter', encoded)
        end

        def unencoded_parameters
          params = fields.dup
          # remove all encoded params from exported fields
          ENCODED_PARAMS.each{ |param| params.delete(mappings[param]) }
          # remove all special characters from each field value
          params = params.collect{|name, value| [name, remove_special_characters(value)] }
          Hash[params]
        end

        def add_failure_url
          if fields[mappings[:failure_url]].nil?
            add_field(mappings[:failure_url], fields[mappings[:return_url]])
          end
        end

        def update_address(address_type, params)
          params = params.dup
          address = params[:address1]
          address = "#{address} #{params[:address2]}" if params[:address2].present?
          address = "#{params[:company]} #{address}" if params[:company].present?
          params[:address1] = address

          params[:phone] = normalize_phone_number(params[:phone])
          add_land_line_phone_for(address_type, params)

          if address_type == :shipping_address
            shipping_name = full_name(params) || fields[mappings[:customer][:name]]
            add_field(mappings[:shipping_address][:name], shipping_name)
          end
          params
        end

        # Split a single phone number into the country code, area code and local number as best as possible
        def add_land_line_phone_for(address_type, params)
          address_field = address_type == :billing_address ? 'custPhoneNo' : 'deliveryPhNo'

          if params.has_key?(:phone2)
            phone = normalize_phone_number(params[:phone2])
            phone_country_code, phone_area_code, phone_number = nil

            if params[:country] == 'IN' && phone =~ /(91)? *(\d{3}) *(\d{4,})$/
              phone_country_code, phone_area_code, phone_number = $1, $2, $3
            else
              numbers = phone.split(' ')
              case numbers.size
              when 3
                phone_country_code, phone_area_code, phone_number = numbers
              when 2
                phone_area_code, phone_number = numbers
              else
                phone =~ /(\d{3})(\d+)$/
                phone_area_code, phone_number = $1, $2
              end
            end

            add_field("#{address_field}1", phone_country_code || phone_code_for_country(params[:country]) || '91')
            add_field("#{address_field}2", phone_area_code)
            add_field("#{address_field}3", phone_number)
          end
        end

        def normalize_phone_number(phone)
          phone.gsub(/[^\d ]+/, '') if phone
        end

        # Special characters are NOT allowed while posting transaction parameters on DirecPay system
        def remove_special_characters(string)
          string.gsub(/[~"'&#%]/, '-')
        end

        def encode_value(value)
          encoded = Base64.strict_encode64(value)
          string_to_encode = encoded[0, 1] + "T" + encoded[1, encoded.length]
          Base64.strict_encode64(string_to_encode)
        end

        def decode_value(value)
          decoded = Base64.decode64(value)
          string_to_decode = decoded[0, 1] + decoded[2, decoded.length]
          Base64.decode64(string_to_decode)
        end

        def phone_code_for_country(country)
          PHONE_CODES[country]
        end

        def full_name(params)
          return if params[:name].blank? && params[:first_name].blank? && params[:last_name].blank?

          params[:name] || "#{params[:first_name]} #{params[:last_name]}"
        end
      end

      class Notification < OffsitePayments::Notification
        RESPONSE_PARAMS = ['DirecPay Reference ID', 'Flag', 'Country', 'Currency', 'Other Details', 'Merchant Order No', 'Amount']

        def acknowledge(authcode = nil)
          true
        end

        def complete?
          status == 'Completed' || status == 'Pending'
        end

        def status
          case params['Flag']
          when 'SUCCESS'
            'Completed'
          when 'PENDING'
            'Pending'
          when 'FAIL'
            'Failed'
          else
            'Error'
          end
        end

        def item_id
          params['Merchant Order No']
        end

        def transaction_id
          params['DirecPay Reference ID']
        end

        # the money amount we received in X.2 decimal
        def gross
          params['Amount']
        end

        def currency
          params['Currency']
        end

        def country
          params['Country']
        end

        def other_details
          params['Other Details']
        end

        def test?
          false
        end

        # Take the posted data and move the relevant data into a hash
        def parse(post)
          super

          values = params['responseparams'].to_s.split('|')
          response_params = values.size == 3 ? ['DirecPay Reference ID', 'Flag', 'Error message'] : RESPONSE_PARAMS
          response_params.each_with_index do |name, index|
            params[name] = values[index]
          end
          params
        end
      end

      class Return < OffsitePayments::Return
        def initialize(post_data, options = {})
          @notification = Notification.new(treat_failure_as_pending(post_data), options)
        end

        def success?
          notification.complete?
        end

        def message
          notification.status
        end

        private

        # Work around the issue that the initial return from DirecPay is always either SUCCESS or FAIL, there is no PENDING
        def treat_failure_as_pending(post_data)
          post_data.sub(/FAIL/, 'PENDING')
        end
      end

      class Status
        include ActiveMerchant::PostsData

        STATUS_TEST_URL = 'https://test.direcpay.com/direcpay/secure/dpMerchantTransaction.jsp'
        STATUS_LIVE_URL = 'https://www.timesofmoney.com/direcpay/secure/dpPullMerchAtrnDtls.jsp'

        attr_reader :account, :options

        def initialize(account, options = {})
          @account, @options = account, options
        end

        # Use this method to manually request a status update to the provided notification_url
        def update(authorization, notification_url)
          url = test? ? STATUS_TEST_URL : STATUS_LIVE_URL
          parameters = [ authorization, account, notification_url ]
          data = ActiveMerchant::PostData.new
          data[:requestparams] = parameters.join('|')

          response = ssl_get("#{url}?#{data.to_post_data}")
        end

        def test?
          OffsitePayments.mode == :test || options[:test]
        end
      end
    end
  end
end
