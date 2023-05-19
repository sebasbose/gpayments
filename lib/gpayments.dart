library gpayments;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GPayments {

  // TODO: Integrate the pending methods from GPayments API

  final apiUrl = "https://api.payments.4geeks.io";

  /// Generate authentication token
  static Future<dynamic> _getToken(String clientId, String clientSecret, String apiUrl) async {

    final response = await http.post(
      Uri.parse("$apiUrl/authentication/token/"), 
      headers: {"content-type": "application/json"}, 
      body: json.encode({
        "client_id": clientId,
        "client_secret": clientSecret,
        "grant_type": "client_credentials",
      })
    );

    final responseBody = response.body;
    final Map<String, dynamic> responseJson = json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Body: $responseBody");
    // print("Response Json: $responseJson");
    // print("Access Token: ${responseJson["access_token"]}");

    return responseJson["access_token"];
  }

  /// Initialize 4GeeksPayments, must include a Client ID and a Client Secret
  static Future<String> config({required String clientId, required String clientSecret}) async {

    final token = await _getToken(clientId, clientSecret, GPayments().apiUrl);

    // print("Token: $token");
    return token;
  }


  /* CHARGES */
  /// Create a charge with credit card
  static Future<dynamic> createChargeWithCreditCard({required String token, required int amount, required String description, required String entityDescription, required String currency, required int cardNumber, required int securityCode, required int expMonth, required int expYear}) async {

    final response = await http.post(
      Uri.parse("${GPayments().apiUrl}/v1/charges/simple/create/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
      body: json.encode({
        "amount": amount,
        "description": description,
        "entity_description": entityDescription,
        "currency": currency,
        "credit_card_number": cardNumber,
        "credit_card_security_code_number": securityCode,
        "exp_month": expMonth,
        "exp_year": expYear,
      })
    );
    
    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Create a charge with customer Id
  static Future<dynamic> createChargeWithId({required String token, required String customerId, required int amount, required String description, required String entityDescription, required String currency}) async {
    
    final response = await http.post(
      Uri.parse("${GPayments().apiUrl}/v1/charges/create/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
      body: json.encode({
        "customer_key": customerId,
        "amount": amount,
        "description": description,
        "entity_description": entityDescription,
        "currency": currency,
      })
    );
    
    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Fetch a specific charge logs with Id
  static Future<dynamic> fetchChargeWithId({required String token, required String logId}) async {

    final response = await http.get(
      Uri.parse("${GPayments().apiUrl}/v1/charges/logs/$logId/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Fetch all charges logs
  static Future<dynamic> fetchAllCharges({required String token}) async {

    final response = await http.get(
      Uri.parse("${GPayments().apiUrl}/v1/charges/logs/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }


  /* ACCOUNT */
  /// Fetch account data
  static Future<String> fetchAccountData({required String token}) async {
    final response = await http.get(
      Uri.parse("${GPayments().apiUrl}/v1/accounts/me/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Update account data
  static void updateAccountData({required String token, dynamic data}) async {
    final request = await http.put(
      Uri.parse("${GPayments().apiUrl}/v1/accounts/me/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
      body: json.encode(data)
    );

    print(request.body);
  }


  /* CUSTOMERS */
  /// Create a new customer
  static Future<dynamic> createCustomer({required String token, required String name, required String email, required String currency, required int cardNumber, required int securityCode, required int expMonth, required int expYear}) async {
    final response = await http.post(
      Uri.parse("${GPayments().apiUrl}/v1/accounts/customers/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
      body: json.encode({
        "name": name,
        "email": email,
        "currency": currency,
        "credit_card_number": cardNumber,
        "credit_card_security_code_number": securityCode,
        "exp_month": expMonth,
        "exp_year": expYear,
      })
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    return responseJson;
  }

  /// Update customer's data
  static void updateCustomer({required String token, required String customerId, dynamic data}) async {
    final request = await http.patch(
      Uri.parse("${GPayments().apiUrl}/v1/accounts/customer/$customerId/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
      body: json.encode(data)
    );

    print(request.body);
  }

  /// Fetch customer's data with Id
  static Future<dynamic> fetchCustomerId({required String token, required String customerId}) async {
    final response = await http.get(
      Uri.parse("${GPayments().apiUrl}/v1/accounts/customer/$customerId/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Fetch all existing customers
  static Future<dynamic> fetchAllCustomers({required String token}) async {
    final response = await http.get(
      Uri.parse("${GPayments().apiUrl}/v1/accounts/customer/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Remove customer's data with Id
  static Future<dynamic> removeCustomer({required String token, required String customerId}) async {
    final response = await http.delete(
      Uri.parse("${GPayments().apiUrl}/v1/accounts/customer/$customerId/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    return response.body;
  }


  /* PLANS */
  /// Create a new plan
  static Future<dynamic> createPlan({required String token, required String planId, required String name, required int amount, required String currency, required int trialPeriod, required String interval, required int intervalCount, required String entityDescription}) async {

    final response = await http.post(
      Uri.parse("${GPayments().apiUrl}/v1/plans/create/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
      body: json.encode({
        "id_name": planId,
        "name": name,
        "amount": amount,
        "currency": currency,
        "trial_period_days": trialPeriod,
        "interval": interval,
        "interval_count": intervalCount,
        "credit_card_description": entityDescription,
      })
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    return responseJson;
  }

  /// Fetch plan's data with Id
  static Future<dynamic> fetchPlanId({required String token, required String planId}) async {
    final response = await http.get(
      Uri.parse("${GPayments().apiUrl}/v1/plans/mine/$planId/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Fetch all existing plans
  static Future<dynamic> fetchAllPlans({required String token}) async {
    final response = await http.get(
      Uri.parse("${GPayments().apiUrl}/v1/plans/mine/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Remove plan's data with Id
  static Future<dynamic> removePlan({required String token, required String planId}) async {
    final response = await http.delete(
      Uri.parse("${GPayments().apiUrl}/v1/plans/mine/$planId/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    return response.body;
  }


  /* SUBSCRIPTIONS */
  /// Subscribe to an existing plan
  static Future<dynamic> subscribePlan({required String token, required String planId, required String customerId}) async {

    final response = await http.post(
      Uri.parse("${GPayments().apiUrl}/v1/plans/subscribe/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
      body: json.encode({
        "plan_id_name": planId,
        "customer_key": customerId,
      })
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    return responseJson;
  }

  /// Fetch subscription's data with Id
  static Future<dynamic> fetchSubscriptionId({required String token, required String subscriptionId}) async {
    final response = await http.get(
      Uri.parse("${GPayments().apiUrl}/v1/plans/subscription/$subscriptionId/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Fetch subscription's data with Id
  static Future<dynamic> fetchAllSubscriptions({required String token}) async {
    final response = await http.get(
      Uri.parse("${GPayments().apiUrl}/v1/plans/subscriptions/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    // print("Status Code: ${response.statusCode}");
    // print("Response Json: $responseJson");

    return responseJson;
  }

  /// Unsubscribe from an existing plan
  static Future<dynamic> unsubscribePlan({required String token, required String subscriptionId}) async {
    final response = await http.delete(
      Uri.parse("${GPayments().apiUrl}/v1/plans/un-subscribe/$subscriptionId/"),
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    return response.body;
  }
}