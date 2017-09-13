@isTest
public class LMSOrientationUpdateRequest_Test {
    static testmethod  void jsonTOLMSOrientationUpdateRequest(){
     String json=    '{'+
            '                "user_login": "user@test.com",'+
            '                "course_code": "wish101",'+
            '                "status": "dropped"'+
            ' }'+
            '';    
    LMSOrientationUpdateRequest lMSOrientationUpdateRequestobj = new LMSOrientationUpdateRequest();
    Test.startTest();
    lMSOrientationUpdateRequestobj  = LMSOrientationUpdateRequest.parse(json);    
    System.assert(lMSOrientationUpdateRequestobj  != null);
    System.assertEquals(lMSOrientationUpdateRequestobj .user_login,'user@test.com');
    System.assertEquals(lMSOrientationUpdateRequestobj .course_code,'wish101');
    System.assertEquals(lMSOrientationUpdateRequestobj .status,'dropped');
    Test.stopTest();
    }
}