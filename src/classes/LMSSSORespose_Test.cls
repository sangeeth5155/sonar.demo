/* Created by : MST
Description : This class test class for LMSSSORespose.
*/
@isTest
public class LMSSSORespose_Test {
    // To parse the JSON to LMSSSORespose.
    static testmethod  void jsonTOLMSSSORespose(){
       String json=    ' {'+
    '"account_id": 810,'+
    '"id": 2369897,'+
    '"user_id": 2563608,'+
    '"token": "wNiX17x7YsrmJREVJuNkWdbW",'+
    '"created_on": "2016-08-04T19:30:29-04:00",'+
    '"login_url": "https://wish.exceedlms-staging.com/authentication/token_sign_on?user_id=2563608&token=wNiX17x7YsrmJREVJuNkWdbW",'+
    '"enrollment_url": "https://wish.exceedlms-staging.com/authentication/token_sign_on?user_id=2563608&token=wNiX17x7YsrmJREVJuNkWdbW"'+    
    '}'; 
    LMSSSORespose lMSSSOResposeobj = new LMSSSORespose();
    Test.startTest();
    lMSSSOResposeobj = LMSSSORespose.parse(json);    
    System.assert(lMSSSOResposeobj != null);
    System.assertEquals(lMSSSOResposeobj.account_id,810);
    System.assertEquals(lMSSSOResposeobj.id,2369897);
    System.assertEquals(lMSSSOResposeobj.user_id,2563608);
    System.assertEquals(lMSSSOResposeobj.token,'wNiX17x7YsrmJREVJuNkWdbW');
    System.assertEquals(lMSSSOResposeobj.created_on,'2016-08-04T19:30:29-04:00');   
    System.assertEquals(lMSSSOResposeobj.login_url,'https://wish.exceedlms-staging.com/authentication/token_sign_on?user_id=2563608&token=wNiX17x7YsrmJREVJuNkWdbW');
    System.assertEquals(lMSSSOResposeobj.enrollment_url,'https://wish.exceedlms-staging.com/authentication/token_sign_on?user_id=2563608&token=wNiX17x7YsrmJREVJuNkWdbW');
    Test.stopTest();
    }
}