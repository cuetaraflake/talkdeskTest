public class SendAccount {
//store this values in a metadata 
String clientId ='3MVG9dZJodJWITSujahMTH95xV5DGFKVuS_.clmAlRAuhcur7qEkIzp8mTxOM5dMt6QdcCiWpM9.x3creLQlJ';

String clientsecret='8055917194229800864';

String username='emrsl@talkdesk.com';

String password='talkdesk123ROxOJDQ5fpRN237PXl8nUi8w';

String accesstoken_url='https://login.salesforce.com/services/oauth2/token';

String authurl='https://login.salesforce.com/services/oauth2/authorize';

public class deserializeResponse {

public String id;

public String access_token;

}

public String ReturnAccessToken(SendAccount Acc){

String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;

Http h= new Http();

HttpRequest req= new HttpRequest();

req.setBody(reqbody);

req.setMethod('POST');

req.setEndpoint('https://orgbtalkdesk-dev-ed.my.salesforce.com/services/oauth2/token');
HttpResponse res=h.send(req);



deserializeResponse resp1=
(deserializeResponse)JSON.deserialize(res.getBody(),deserializeResponse.class);


return resp1.access_token;

}

@future(callout=true)

public static void createAccount(String Accname, String Phone,String org,String Number_Of_Opps,Integer Number_of_Contacts){

SendAccount acc1= new SendAccount();

String accessToken=acc1.ReturnAccessToken(acc1);



if(accessToken!=null){


String endPoint='https://orgbtalkdesk-dev-ed.my.salesforce.com/services/data/v32.0/sobjects/Account'; 

// I failed to send the roll up field created by me to see the total of number of the Opps also the failed to send the field populated by a trigger to get the number os contacts.
// Its done but I failed when I try to send it over the Json string - I was wasting time where and I decided to keep with the exercice
String jsonstr='{"Name":"'+ Accname +'","Phone":"'+ Phone +'","org__c":"'+ org +'","Number_Of_Opps__c":"'+ Number_Of_Opps +'","Number_of_Contacts__c":"'+ Number_of_Contacts +'"}';



Http h2= new Http();

HttpRequest req2= new HttpRequest();

req2.setHeader('Authorization','Bearer ' + accessToken);

req2.setHeader('Content-Type','application/json');

req2.setHeader('accept','application/json');

req2.setBody(jsonstr);

req2.setMethod('POST');

req2.setEndpoint(endPoint);

HttpResponse res2=h2.send(req2);

deserializeResponse deresp=(deserializeResponse)System.JSON.deserialize(res2.getBody(),deserializeResponse.class);


}

}

}