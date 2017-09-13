/*Created by : MST 
Description : This is a test class for LMSCourse class, will parse the JSON String to LMSCourse Object */
@isTest
public class LMSCourse_Test {
    //parse the JSON String 
    static testmethod  void jsonTOLMSCourse(){
    String json=    ''+
    '{'+
    '"id": 1234,'+
    '"name": "WishGranting101-Arizona",'+
    '"created_on": "2015-03-12T14:50:31-05:00",'+
    '"credit_units": "1.0",'+
    '"is_active": true,'+
    '"summary": "Basicwishgrantertraining",'+
    '"duration": 12.2,'+
    '"completion_type": "pass/fail",'+
    '"type": "elearning",'+
    '"subtype": "granting"'+
    '}';    
    LMSCourse LMSCourseobj = new LMSCourse();
    Test.startTest();
    LMSCourseobj  = LMSCourse.parse(json);    
    System.assert(LMSCourseobj   != null);
    System.assertEquals(LMSCourseobj.id,1234);
    System.assertEquals(LMSCourseobj.name,'WishGranting101-Arizona');
    System.assertEquals(LMSCourseobj.created_on,'2015-03-12T14:50:31-05:00');
    System.assertEquals(LMSCourseobj.credit_units,'1.0');
    System.assertEquals(LMSCourseobj.is_active,true);
    System.assertEquals(LMSCourseobj.summary,'Basicwishgrantertraining');
    System.assertEquals(LMSCourseobj.duration,12.2);
    System.assertEquals(LMSCourseobj.completion_type,'pass/fail');
    System.assertEquals(LMSCourseobj.type,'elearning');
    System.assertEquals(LMSCourseobj.subtype,'granting');    
    Test.stopTest();
    }
}