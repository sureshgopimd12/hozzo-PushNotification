class Mutations {
  const Mutations();

  final String login = """
    mutation login(\$phone: String!, \$password: String!, \$fcm_token: String) {
      login(phone: \$phone, password: \$password, fcm_token: \$fcm_token) {
        access_token
        user {
          id
          name
          phone
          email
          image {
            url
          }
        }
      }
    }
  """;

  final String register = """
    mutation register(\$name: String!, \$email: String, \$phone: String!, \$password: String!, \$fcm_token: String) {
      register(name: \$name, email: \$email, phone: \$phone, password: \$password, fcm_token: \$fcm_token) {
        access_token
        user {
          id
          name
          phone
          email
          image {
            url
          }
        }
      }
    }
  """;

  final String sendOTP = """
    mutation sendOTP(\$phone: String!) {
      sendOtp(phone: \$phone) {
        type
        phone
        otp
        expires_in
      }
    }
  """;

  final String forgotPassword = """
    mutation forgotPassword(\$otp: String!,\$phone: String!,\$password: String!){
      forgotPassword(otp: \$otp, phone: \$phone, password: \$password) {
        message
      }
    }
  """;

  final String changePassword = """
    mutation changePassword(\$password: String!, \$new_password: String!){
      changePassword(password: \$password, new_password: \$new_password) {
        message
      }
    }
  """;

  final String logout = """
    mutation {
      logout {
        message
      }
    }
  """;

  final String addCustomerVehicle = """
    mutation addCustomerVehicle(\$vehicle_number: String!, \$vehicle_model_id: Int!) {
      addCustomerVehicle(vehicle_number: \$vehicle_number, vehicle_model_id: \$vehicle_model_id) {
        id
        vehicle_type{
          id
          name
        }
        title
        message
      }
    }
  """;

  final String createCustomerLocation = """
    mutation createCustomerLocation(\$location: String!, \$latlng: String!, \$address: String!, \$pincode: String!, \$address_type_name: String!) {
      createCustomerLocation(location: \$location, latlng: \$latlng, address: \$address, pincode: \$pincode, address_type_name: \$address_type_name) {
        title
        message
      }
    }
  """;

  final String orderPackageDetails = """
    mutation orderPackageDetails(
      \$customer_vehicle_id: Int!,
      \$serviceman_id: Int!,
      \$booking_date: Date!,
      \$booking_time_slot_id: Int!,
      \$packages_ids: [Int!]!,
      \$payment_method: Int!,
      \$customer_location_id: Int!,
      \$transaction_id: String,
      \$coupon_code: String
    ) {
    orderPackageDetails(
      customerVehicleID: \$customer_vehicle_id,
      servicemanID: \$serviceman_id,
      date: \$booking_date,
      timeSlotID: \$booking_time_slot_id,
      packageIDs: \$packages_ids,
      paymentMethod: \$payment_method,
      customerLocationID: \$customer_location_id,
      transactionID: \$transaction_id,
      couponCode: \$coupon_code
    ) {
        id
        invoice_number
        generated_order_id
        razorpay_key
        packages {
          name
        }
        order_date
        amount
        txn_id
        message
        bottom_text
      }
    }
  """;

  final String orderSubscriptionDetails = """
    mutation orderSubscriptionDetails(
      \$customer_vehicle_id: Int!,
      \$subscription_id: Int!,
      \$payment_method: Int!,
      \$customer_location_id: Int!,
      \$transaction_id: String) {
      orderSubscriptionDetails(
      customerVehicleID: \$customer_vehicle_id,
      subscriptionID: \$subscription_id,
      paymentMethod: \$payment_method,
      customerLocationID: \$customer_location_id,
      transactionID: \$transaction_id) {
        id
        invoice_number
        generated_order_id
        razorpay_key
        subscription_plan {
          name
          description
        }
        order_date
        amount
        txn_id
        message
        bottom_text
      }
    }
  """;

  final String createOverallFeedback = """
    mutation createOverallFeedback(\$rating: String!, \$remarks: String!) {
      createOverallFeedback(rating: \$rating, remarks: \$remarks) {
        id
        title
        message
      }
    }
  """;

  final String createServicemanFeedback = """
    mutation createServicemanFeedback(\$order_id: Int!, \$serviceman_rating: Float!, \$issue_ids: [Int!], \$message: String, \$images: [Upload!]) {
      createServicemanFeedback(orderID: \$order_id, servicemanRating: \$serviceman_rating, issueIDs: \$issue_ids, message: \$message, images: \$images) {
        title
        message
      }
    }
  """;

  final String updateProfile = """ 
    mutation updateProfile(\$input: Profile) {
      updateProfile(input: \$input) {
        access_token
        user {
          id
          name
          phone
          email
          image {
            url
          }
        }
        message
      }
    }
  """;

  final String deleteCustomerVehicle = """ 
    mutation deleteCustomerVehicle(\$id: Int!) {
      deleteCustomerVehicle(id: \$id) {
        id
        vehicle_number
        vehicleModel {
          id
          name
          vehicleType {
            id
            name
          }
          vehicleBrand {
            id
            name
          }
          image {
            url
          }
        }
      }
    }
  """;

  final String deleteCustomerLocation = """
    mutation deleteCustomerLocation(\$id: Int) {
      deleteCustomerLocation(id: \$id) {
        id
        address
        is_active
        pincode
        location_type {
          id
          name
        }
      }
    }
  """;
}
