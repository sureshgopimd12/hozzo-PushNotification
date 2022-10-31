class Queries {
  const Queries();

  final String checkRegisterd = """
    query checkRegisterd(\$phone: String!) {
      registerd(phone: \$phone) 
    }
  """;

  final String checkUsedEmail = """
    query checkUsedEmail(\$email: String!) {
      usedEmail(email: \$email)
    }
  """;

  final String getVehicleTypes = """
    query getVehicleTypes {
      vehicleTypes {
        id
        name
        image {
          url
        }
      }
    }
  """;

  final String getVehicleBrands = """
   query vehicleBrands {
      vehicleBrands {
        id
        name
      }
    }
  """;

  final String getVehicleModelsByBrand = """
    query getVehicleModelsByBrand(\$vehicle_brand_id: Int!) {
      vehicleModelsByBrand(vehicle_brand_id: \$vehicle_brand_id) {
        id
        name
        image {
          url
        }
      }
    }
  """;

  final String getCustomerVehicles = """
    query getCustomerVehicles {
      customerVehicles {
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

  final String getCustomerLocations = """
    query getCustomerLocations {
      customerLocations {
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

  final String getLocationTypes = """
    query getLocationTypes {
      locationTypes {
        id
        name
        is_active
      }
    }
  """;

  final String getServicemenStatusByPincode = """
  query getServicemenStatusByPincode(\$pincode: Int!, \$subscription_id: Int) {
    hasServicemenByPincode(pincode: \$pincode, subscriptionID: \$subscription_id) {
      code
      status
      title
      message
    }
  }
  """;

  final String getPackagesAndSubscriptions = """
    query getPackagesAndSubscriptions(\$vehicle_type_id: Int!, \$customer_location_id: String!) {
      packages(vehicle_type_id:\$vehicle_type_id, customer_location_id: \$customer_location_id) {
          id
          name
          description
          absolutePrice
          isFixed
          service_id
      }
      allSubscriptions(vehicle_type_id:\$vehicle_type_id, customer_location_id: \$customer_location_id) {
        id
        subscription_plan_detail_id
        name
        description
        price
      }
    }
  """;

  final String getVehiclesServicemanAndTimeSlots = """
    query getVehiclesServicemanAndTimeSlots(\$pincode: Int!, \$date: Date!) {
      customerVehicles {
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
      bestServiceman(pincode: \$pincode) {
        id
        name
        phone
        rating
        image {
          url
        }
      }
      timeSlots(pincode: \$pincode, date: \$date) {
        slots {
          id
          name
          status
        }
        message
      }
    }
  """;

  final String getServicemenByPincode = """
    query getServicemenByPincode(\$pincode: Int!) {
      servicemenByPincode(pincode: \$pincode) {
        id
        name
        phone
        rating
        image {
          url
        }
      }
    }
  """;

  final String getTimeSlotsByServicemanAndDate = """
    query getTimeSlotsByServicemanAndDate(\$serviceman_id: Int, \$date: Date!) {
      timeSlots(serviceman_id: \$serviceman_id, date: \$date) {
        slots {
          id
          name
          status
        }
        message
      }
    }
  """;

  final String getGreetingsBannersAndPopularPackages = """
    query getGreetingsBannersAndPopularPackages {
      greetings {
        title
        subtitle
      }
      banners {
        id
        title
        description
        image {
          url
        }
      }
      popularPackages {
        service_id
        service_name
        service_description
        service_amount
        service_pricings{
          vehicle_type
          price
        }
        service_image {
          url
        }
      }
      popularSubcriptions{
        id
        name
        description
        price
      }
      coupon_codes{
        id
        title
        description
        coupon_code
        image{
          url
        }
      }
    }
  """;
  final String getServicemenOrderStatus = """
    query getServicemenOrderStatus(\$order_id:Int!) {
      orderStatus(order_id:\$order_id) {
        invoice_number
        wash_date
        booked_date
        serviceman {
          name
          phone
          rating
          image {
            url
          }
        }
        statuses {
          name
          time
          message
          active
          is_cancelled
        }
      }
    }
  """;

  final String getMyRequests = """
    query getMyRequests(\$request_type: Int!, \$order_by: String) {
      myRequests(request_type: \$request_type, order_by: \$order_by  ) {
        id
        packages {
          id
          name
        }
        order_date
        amount
        status
        cancelled
        completed
        customer_vehicle_image {
          url
        }
        payment_method
      }
    }
  """;

  final String customerSubscriptions = """
   query customerSubscriptions {
      mySubscriptions {
        id
        invoice_number
        expiry_date
        services_remaining
        subscriptionPlan {
          id
          name
          description
        }
        serviceLogs{
          id
          date
          serviceman{
            name
            phone
            rating
            image {
              url
            }
          }
        }
        total
      }
    }
  """;

  final String getServiceIssues = """
    query getServiceIssues {
      serviceIssues{
        id
        name
      }
    }
  """;

  final String getAppUpdates = """ 
    query getAppUpdate {
      getAppUpdate {
        android_latest_version
        ios_latest_version
        android_update_link
        ios_update_link
        google_maps_key
      }
    }  
  """;

  final String checkCouponCode = """
    query verifyCode(\$code: String!, \$amount: String!, \$bookedDate: String!, \$customerLocationID: String!){
      verify_code(code: \$code, amount: \$amount, bookedDate: \$bookedDate, customerLocationID: \$customerLocationID){
        coupon_code
        current_price
        offer_price
        message_header
        message
        message_type
      }
    }
""";

  final String cancelOrder = """
    query cancelOrder(\$orderID: Int!) {
      cancelOrder(orderID: \$orderID) {
        id
        packages {
          id
          name
        }
        order_date
        amount
        status
        cancelled
        completed
        customer_vehicle_image {
          url
        }
        payment_method
      }
    }
""";

  final String getSubscriptionPlanDetail = """
    query getSubscriptionPlanDetail(\$vehicleID: Int!, \$subscriptionID: Int!) {
      getSubscriptionPlanDetail(vehicleID: \$vehicleID, subscriptionID: \$subscriptionID) {
        id
        subscription_plan_detail_id
        name
        description
        price
      }
    }
""";

  final String checkTimeSlotAvailable = """
    query checkTimeSlotAvailable(\$servicemanID: ID!, \$dateTime: String!) {
      checkTimeSlotAvailable(servicemanID: \$servicemanID, dateTime: \$dateTime) {
        is_available
        message
      }
    }
  """;
}
