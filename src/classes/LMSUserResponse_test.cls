/* Created by : MST
Description : This class is the test class for LMSUserResponse.
*/
@isTest
 public class LMSUserResponse_test{
    // To parse the JSON to LMSUserResponse
   static testmethod  void jsonTOLMSUserRequest(){
       String json=        '{'+
        '                "login": "sailappa@test.com",                '+
        '                "first_name": "sailappa",'+
        '                "last_name": "pg",'+
        '                "email": "sailappar@test.com",                '+
        '                "Code": "sailappa",'+
        '                "id": 12345,'+
        '                "is_active": true,'+
        '                "last_login_at": "2016-08-04T19:20:05.407-04:00"'+
        ' }'+
        ''; 
    LMSUserResponse lMSUserResponseobj = new LMSUserResponse();
    Test.startTest();
    lMSUserResponseobj = LMSUserResponse.parse(json);    
    System.assert(lMSUserResponseobj  != null);
    System.assertEquals(lMSUserResponseobj .login,'sailappa@test.com');
    System.assertEquals(lMSUserResponseobj .first_name,'sailappa');
    System.assertEquals(lMSUserResponseobj .last_name,'pg');
    System.assertEquals(lMSUserResponseobj .email,'sailappar@test.com');     
    Test.stopTest();
    }
 }