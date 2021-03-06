/*********************************************************************

* Description - Apex REST service with GET and POST methods

* Author - AP

<u>Json format</u>

{

"name" : "Akash",

"phone" : "8826031286",

"website" : "www.akashmishra.co.in"

}

***********************************************************************/

@RestResource(urlMapping='/v3/accounts/*')

global with sharing class REST_AccountService_V4 {

@HttpPost

global static AccountWrapper doPost(String name, String phone, String website) {

RestRequest req = RestContext.request;

RestResponse res = RestContext.response;

AccountWrapper response = new AccountWrapper();

Account acct = new Account();

acct.Name = name;

acct.Phone = phone;

acct.Website = website;

insert acct;

response.acctList.add(acct);

response.status = 'Success';

response.message = 'Your Account was created successfully.';

return response;

}

@HttpGet

global static AccountWrapper doGet() {

RestRequest req = RestContext.request;

RestResponse res = RestContext.response;

AccountWrapper response = new AccountWrapper();

String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

if(doSearch(accountId))

{

searchAccounts(req, res, response);

}

else

{

findAccount(res, response, accountId);

}

return response;

}

// If the item to the right of the last forward slash is "accounts", the request went to

//v3/accounts?Name=Akash

// Else the request went to v3/accounts/&lt;something&gt;, which is not a search, but a specific

//entity

private static boolean doSearch(String accountId) {

if(accountId == 'accounts') {

return true;

}

return false;

}

//If the request came to /v3/accounts, then we want to execute a search

Public static void searchAccounts(RestRequest req, RestResponse res,

AccountWrapper response) {

//Use the RestRequest's params to fetch the Name parameter

String searchTerm = req.params.get('Name');

if(searchTerm == null || searchTerm == '') {

response.status = 'Error';

response.message = 'You must provide a Name for your search term.';

res.StatusCode = 400;

}

else {

String searchText = '%'+searchTerm+'%';

List<Account> searchResults =

[SELECT Id, Name, Phone, Website FROM Account WHERE Name LIKE : searchText];

if(searchResults != null && searchResults.size() > 0) {

response.acctList = searchResults;

response.status = 'Success';

response.message = searchResults.size()

+ ' Accounts were found that matched your search term.';

}

else {

response.status = 'Error';

response.message =

'No Accounts were found based on that Name, please search again.';

}

}

}



//If the request came to v3/accounts/sometext then we want

//to find a specific account

Public static void findAccount(RestResponse res, AccountWrapper response,

String accountId) {

// Provided we recevied an External Id, perform the search and return the results

if(accountId != null && accountId != '') {

List<Account> result = [SELECT Id, Name, Phone, Website FROM Account];

if(result != null && result.size() > 0) {

response.acctList.add(result[0]);

response.status = 'Success';

}

else {

response.status = 'Error';

response.message = 'This account could not be found, please try again.';

res.StatusCode = 404;

}

}

// If the request came to /v3/accounts/ (without an Account Id),

//return an error

else {

response.status = 'Error';

response.message = 'You must specify an External Id.';

res.StatusCode = 400;

}

}

global class AccountWrapper {

public List<Account> acctList;

public String status;

public String message;

public AccountWrapper(){

acctList = new List<Account>();

}

}

}