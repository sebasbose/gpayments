# gpayments

4Geeks Payments Gateway Dart Integration for Flutter

## Getting Started
This is a project that enables the integration of the [4Geeks Payments](https://4geeks.io/payments/) Gateway with Flutter.

This is a work-in-progress project, if you find anykind of errors or incompatibilities, please don't hesitate to report it and create an issue, I will take care of it asap.

## Installation
GPayments for Flutter is currently not available in the Pub.Dev repository due to it's early development stage. I plan to release it later on. In order to install this package you'll need to download it and install it manually in the 'packages' folder of your project.

## Usage
Start by importing the package
```
#import 'package:gpayments/gpayments.dart'
```

Then initialize the main method to generate an authentication token
```
final gpaymentsToken = await GPayments.config(
  clientId: "client-id", 
  clientSecret: "client-secret"
);
```

Now you can use the `gpaymentsToken` to create a charge
```
GPayments.createChargeWithCreditCard(
  token: gpaymentsToken, 
  amount: 12000, 
  description: 'test product sale charge', 
  entityDescription: 'test product', 
  currency: 'crc', 
  cardNumber: 4242424242424242, 
  securityCode: 123, 
  expMonth: 12, 
  expYear: 2023
);
```

## API
In order to use GPayments you must have a [4Geeks Payments](https://4geeks.io/payments/) account. Remember that this service currently is only available in Costa Rica; nevertheless, you'll be able to proccess Visa or MasterCard credit cards from anywhere in the world. In the case of AmericanExpress credit cards, you'll only be able to process payments in US Dollars.

### Initialize GPayments
To begin, initialize GPayments and generate a token. You'll use this token whenever you perform a request to the 4Geeks Payments API.
```
final gpaymentsToken = await GPayments.config(
  clientId: "client-id", 
  clientSecret: "client-secret"
);
```
Note: don't forget to register as a business at [4Geeks Payments](https://4geeks.io/payments/), you can use the sandbox credentials for testing. Also, remember to import the package in your Dart file.

### Fetch your account's information
In order to fetch your accounts information you can use the following code snippet.
```
GPayments.fetchAccountData(
  token: gpaymentsToken
);
```

### Update your account's information
If you want to edit your accounts information you can use the following method.
```
GPayments.updateAccountData(
  token: gpaymentsToken,
  data: {
    "bank_name": "Bac"
  }
);
```

### Create new customer
If you want to create a new customer in order to store their token in your database for further transactions you can call the following method.
```
GPayments.createCustomer(
  token: gpaymentsToken,
  name: 'Michael Jordan',
  email: 'mjordan@nba.com',
  currency: 'crc',
  cardNumber: 4242424242424242,
  securityCode: 123,
  expMonth: 12,
  expYear: 2023
);
```

### Update existing customer's information
The same steps apply in case you are willing to edit an existing customer's information, but in this case you'll need to provide the customer's Id.
```
GPayments.updateCustomer(
  token: gpaymentsToken,
  customerId: "gjDKFJDJR456kgkgkfsFDKSLAFJGJKL75L",
  data: {
    "name": "Michael Jackson"
  }
);
```

### Fetch customer's information
You can either fetch all the customer Ids...
```
GPayments.fetchAllCustomers(
  token: gpaymentsToken
);
```
... or provide an specific Customer Id to fetch that customer's data.
```
GPayments.fetchCustomerId(
  token: gpaymentsToken,
  customerId: "gjDKFJDJR456kgkgkfsFDKSLAFJGJKL75L",
);
```

### Removing an existing customer
In case you want to remove an existing customer's data, you can use this method.
```
GPayments.removeCustomer(
  token: gpaymentsToken,
  customerId: "gjDKFJDJR456kgkgkfsFDKSLAFJGJKL75L",
);
```

### Creating subscription plans
If you want to create a subscription plan for your clients to subscribe to, you use the following method.
```
GPayments.createPlan(
  token: gpaymentsToken,
  planId: 'plan-1',
  name: 'Test Plan',
  amount: 300000,
  currency: 'crc',
  trialPeriod: 0,
  interval: 'month',
  intervalCount: 1,
  entityDescription: 'Test Credit Card'
)
```

### Fetch plan's information
You can either fetch all the plan ids...
```
GPayments.fetchAllPlans(
  token: gpaymentsToken
);
```
... or provide an specific plan id to fetch that plan's data.
```
GPayments.fetchPlanId(
  token: gpaymentsToken,
  planId: "gjfkAS34WEDjrks454DFG44fdk",
);
```

### Removing an existing plan
In case you want to remove an existing plan, you can use this method.
```
GPayments.removePlan(
  token: gpaymentsToken,
  planId: "gjfkAS34WEDjrks454DFG44fdk",
);
```

### Subscribing to a plan
To subscribe a customer to one of your offered plans you can use the following method.
```
GPayments.subscribePlan(
  token: gpaymentsToken,
  planId: "gjfkAS34WEDjrks454DFG44fdk",
  customerId: "gjDKFJDJR456kgkgkfsFDKSLAFJGJKL75L",
);
```

### Fetch existing subscriptions
You can either fetch all the subscription ids...
```
GPayments.fetchAllSubscriptions(
  token: gpaymentsToken
);
```
... or provide an specific subscription id to fetch that subscription's data.
```
GPayments.fetchPlanId(
  token: gpaymentsToken,
  subscriptionId: "gjfkAS34WEDjrks454DFG44fdk",
);
```

### Unsubscribing from a plan
To unsubscribe a customer from a plan you can use the following method.
```
GPayments.unsubscribePlan(
  token: gpaymentsToken,
  subscriptionId: "gjfkAS34WEDjrks454DFG44fdk",
);
```

### Create a charge
If you want to charge your customer's a specific amount in a specific supported currency you have two options: you can either charge their credit card or use a pre-existing token created for that customer's credit card. Both ways are detailed below.

#### Charging a credit card
```
GPayments.createChargeWithCreditCard(
  token: gpaymentsToken,
  amount: 35.99,
  description: 'Test Product #1',
  entityDescription: 'Product #1',
  currency: 'usd',
  cardNumber: 4242424242424242,
  securityCode: 123,
  expMonth: 12,
  expYear: 2023
);
```

#### Charging a customer's registered Id
```
GPayments.createChargeWithCreditCard(
  token: gpaymentsToken,
  customerId: "gjDKFJDJR456kgkgkfsFDKSLAFJGJKL75L",
  amount: 35.99,
  description: 'Test Product #1',
  entityDescription: 'Product #1',
  currency: 'usd',
);
```

### Fetch performed charges logs
Finally, you can fetch all the performed charges ids...
```
GPayments.fetchAllCharges(
  token: gpaymentsToken
);
```
... or provide an specific charge id to fetch that charge's data.
```
GPayments.fetchChargeWithId(
  token: gpaymentsToken,
  chargeId: "3lkk98JKGJDF56Lkkasdef67",
);
```

## License
This library is distributed using the MIT License Guidelines. The 4Geeks Payments API is developed by the 4Geeks Team, this library was developed by Sebastián Bolaños on behalf of the VOZZEX team. Enjoy :)
