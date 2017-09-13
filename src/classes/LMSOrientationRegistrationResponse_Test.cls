/* Created by : MST
Description : This class is the test class for LMSOrientationRegistrationResponse
*/
@isTest
public class LMSOrientationRegistrationResponse_Test {
    // To parse the JSON to LMSOrientationRegistrationResponse
    static testmethod  void jsonTOLMSOrientationRegistrationResponse(){
       String json=    '{'+
    '  "id": 50174739,'+
    '  "user_id": 2567858,'+
    '  "account_id": 810,'+
    '  "course_id": 128763,'+
    '  "enrolled_on": "2016-08-15T13:27:56.060-04:00",'+
    '  "due_on": "2016-08-15T15:17:03.215-04:00",'+
    '  "started_on": "2016-08-15T15:17:03.215-04:00",'+
    '  "completed_on": "2016-08-15T15:17:03.215-04:00",'+
    '  "expires_on": "2016-08-15T15:17:03.215-04:00",'+
    '  "status": "dropped",'+
    '  "progress": 0,'+
    '  "score": "10",'+
    '  "time": "12:30",'+
    '  "updated_on": "2016-08-15T15:17:03.455-04:00",'+
    '  "code": "0001",'+
    '  "completed_activities_count": "1",'+
    '  "attachments_count": "1",'+
    '  "is_initial_enrollment": false,'+
    '  "updated_by": "API",'+
    '  "accepted_invite": false,'+
    '  "pre_assessment_score": "10",'+
    '  "pre_assessment_status": "Completed",'+
    '  "created_by": "API",'+
    '  "graded_by_instructor_id": "001",'+
    '  "created_on": "2016-08-15T13:27:56.060-04:00",'+
    '  "curriculum_activities_version": "01",'+
    '  "user_code": "sai@vignesh.com"'+
    '}';
    LMSOrientationRegistrationResponse lMSOrientationRegistrationResponseobj = new LMSOrientationRegistrationResponse();
    Test.startTest();
    lMSOrientationRegistrationResponseobj  = LMSOrientationRegistrationResponse.parse(json);    
    System.assert(lMSOrientationRegistrationResponseobj  != null);
    System.assertEquals(lMSOrientationRegistrationResponseobj .id,50174739);
    System.assertEquals(lMSOrientationRegistrationResponseobj .user_id,2567858);
    System.assertEquals(lMSOrientationRegistrationResponseobj .account_id,810);
    Test.stopTest();
    }
}