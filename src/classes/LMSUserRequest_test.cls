/* Created by : MST
Description : This class is the test class for LMSUserRequest.
*/
@isTest
 public class LMSUserRequest_test{
    // To parse the JSON to LMSUserRequest
   static testmethod  void jsonTOLMSUserRequest(){
       String json=        '{'+
        '                "login": "sailappa@test.com",                '+
        '                "first_name": "sailappa",'+
        '                "last_name": "pg",'+
        '                "email": "sailappar@test.com",                '+
        '                "password": "sailappa"'+
        ' }'+
        ''; 
    LMSUserRequest lMSUserRequestobj = new LMSUserRequest();
    Test.startTest();
    lMSUserRequestobj = LMSUserRequest.parse(json);    
    System.assert(lMSUserRequestobj  != null);
    System.assertEquals(lMSUserRequestobj .login,'sailappa@test.com');
    System.assertEquals(lMSUserRequestobj .first_name,'sailappa');
    System.assertEquals(lMSUserRequestobj .last_name,'pg');
    System.assertEquals(lMSUserRequestobj .email,'sailappar@test.com');
    System.assertEquals(lMSUserRequestobj .password,'sailappa'); 
    Test.stopTest();
    }
 }