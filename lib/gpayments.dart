library gpayments;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GPayments {

  // TODO: Integrate the pending methods from GPayments API

  final apiUrl = "https://api.payments.4geeks.io";

  /// Generate authentication token
  static Future<dynamic> _getToken(String clientId, String clientSecret, String apiUrl) async {

    final response = await http.post(
      "$apiUrl/authentication/token/", 
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
  static Future<String> config(String clientId, String clientSecret) async {

    final token = await _getToken(clientId, clientSecret, GPayments().apiUrl);

    // print("Token: $token");
    return token;
  }


  /* CHARGES */
  /// Create a charge with credit card
  static Future<dynamic> createChargeWithCreditCard(String token, int amount, String description, String entityDescription, String currency, int cardNumber, int securityCode, int expMonth, int expYear) async {

    final response = await http.post(
      "${GPayments().apiUrl}/v1/charges/simple/create/",
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
  static Future<dynamic> createChargeWithId(String token, String customerId, int amount, String description, String entityDescription, String currency) async {
    
    final response = await http.post(
      "${GPayments().apiUrl}/v1/charges/create/",
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
  static Future<dynamic> fetchChargeWithId(String token, String logId) async {

    final response = await http.get(
      "${GPayments().apiUrl}/v1/charges/logs/$logId/",
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
  static Future<dynamic> fetchAllCharges(String token) async {

    final response = await http.get(
      "${GPayments().apiUrl}/v1/charges/logs/",
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
  static Future<String> fetchAccountData(String token) async {
    final response = await http.get(
      "${GPayments().apiUrl}/v1/accounts/me/",
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
  static void updateAccountData(String token, dynamic data) async {
    final request = await http.put(
      "${GPayments().apiUrl}/v1/accounts/me/",
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
  static Future<dynamic> createCustomer(String token, String name, String email, String currency, int cardNumber, int securityCode, int expMonth, int expYear) async {
    final response = await http.post(
      "${GPayments().apiUrl}/v1/accounts/customers/",
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
  static void updateCustomer(String token, String customerId, dynamic data) async {
    final request = await http.patch(
      "${GPayments().apiUrl}/v1/accounts/customer/$customerId/",
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
      body: json.encode(data)
    );

    print(request.body);
  }

  /// Fetch customer's data with Id
  static Future<dynamic> fetchCustomerId(String token, String customerId) async {
    final response = await http.get(
      "${GPayments().apiUrl}/v1/accounts/customer/$customerId/",
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
  static Future<dynamic> fetchAllCustomers(String token) async {
    final response = await http.get(
      "${GPayments().apiUrl}/v1/accounts/customer/",
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
  static Future<dynamic> removeCustomer(String token, String customerId) async {
    final response = await http.delete(
      "${GPayments().apiUrl}/v1/accounts/customer/$customerId/",
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    return response.body;
  }


  /* PLANS */
  /// Create a new plan
  static Future<dynamic> createPlan(String token, String planId, String name, int amount, String currency, int trial, String interval, int intervalCount, String description) async {

    final response = await http.post(
      "${GPayments().apiUrl}/v1/plans/create/",
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
      body: json.encode({
        "id_name": planId,
        "name": name,
        "amount": amount,
        "currency": currency,
        "trial_period_days": trial,
        "interval": interval,
        "interval_count": intervalCount,
        "credit_card_description": description,
      })
    );

    final responseBody = response.body;
    final responseJson = await json.decode(responseBody);

    return responseJson;
  }

  /// Fetch plan's data with Id
  static Future<dynamic> fetchPlanId(String token, String planId) async {
    final response = await http.get(
      "${GPayments().apiUrl}/v1/plans/mine/$planId/",
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
  static Future<dynamic> fetchAllPlan(String token) async {
    final response = await http.get(
      "${GPayments().apiUrl}/v1/plans/mine/",
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
  static Future<dynamic> removePlan(String token, String planId) async {
    final response = await http.delete(
      "${GPayments().apiUrl}/v1/plans/mine/$planId/",
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    return response.body;
  }


  /* SUBSCRIPTIONS */
  /// Subscribe to an existing plan
  static Future<dynamic> subscribePlan(String token, String planId, String customerId) async {

    final response = await http.post(
      "${GPayments().apiUrl}/v1/plans/subscribe/",
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
  static Future<dynamic> fetchSubscriptionId(String token, String subscriptionId) async {
    final response = await http.get(
      "${GPayments().apiUrl}/v1/plans/subscription/$subscriptionId/",
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
  static Future<dynamic> fetchAllSubscriptions(String token) async {
    final response = await http.get(
      "${GPayments().apiUrl}/v1/plans/subscriptions/",
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
  static Future<dynamic> unsubscribePlan(String token, String subscriptionId) async {
    final response = await http.delete(
      "${GPayments().apiUrl}/v1/plans/un-subscribe/$subscriptionId/",
      headers: {
        "content-type": "application/json",
        "authorization": "bearer $token"
      },
    );

    return response.body;
  }
}