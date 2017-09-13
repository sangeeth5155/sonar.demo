/* Created by : MST
Description : This Class is test class for LMSHttpRequest.
*/
@isTest
public class LMSHttpRequest_Test{
    // To validate createHttpRequest method
    static testmethod void createHttpRequest(){
        LMS_Credentials__c currLMSCredential = testClassUtil.createLMSCredentials();
        Test.startTest();
        HttpRequest request = LMSHttpRequest.createLMSHttpRequest(currLMSCredential,'/Test','GET');
        system.assert(request != Null);
        Test.stopTest();
    }
    // To validate getLMSSSODetails method
    static testmethod void getLMSSSODetails(){  
        LMS_Credentials__c currLMSCredential;   
        LMSCourseSyncMockImpl currLMSCourseSyncMockImpl = new LMSCourseSyncMockImpl();
        String payload;
        HttpResponse response = new HttpResponse();
        response.setStatus('OK');
        response.setStatusCode(200);
        LMSSSORespose currLMSSSORespose =  new LMSSSORespose();
        currLMSSSORespose.account_id = 810;
        currLMSSSORespose.id = 2369897;
        currLMSSSORespose.user_id = 2563608;
        currLMSSSORespose.token = 'wNiX17x7YsrmJREVJuNkWdbW';
        currLMSSSORespose.created_on = '2016-08-04T19:30:29-04:00';
        currLMSSSORespose.login_url = 'https://wish.exceedlms-staging.com/authentication/token_sign_on?user_id=2563608&token=wNiX17x7YsrmJREVJuNkWdbW';
        currLMSSSORespose.enrollment_url = 'https://wish.exceedlms-staging.com/student/home/show_enrollment/50174739';     
        payload = JSON.serialize(currLMSSSORespose);  
        response.setBody(payload);
        currLMSCourseSyncMockImpl.addResponse(response);
        Test.setMock(HttpCalloutMock.class, currLMSCourseSyncMockImpl);
        testClassUtil.createUser();
        testClassUtil.createUser();
        List<User> currUserLst = [SELECT ID FROM USER WHERE ID != : Userinfo.getUserId() AND IsActive = True];
        system.runAs(currUserLst[0]){       
            currLMSCredential = testClassUtil.createLMSCredentials();           
        } 
        Test.startTest();
        system.runAs(currUserLst[1]){
            try{                
                currLMSSSORespose = LMSHttpRequest.getLMSSSODetails(currLMSCredential, '12345','test test'); 
                system.assert(currLMSSSORespose != Null);
                system.assertEquals(currLMSSSORespose.account_id,810);
                system.assertEquals(currLMSSSORespose.id,2369897);
                system.assertEquals(currLMSSSORespose.user_id,2563608);
                system.assertEquals(currLMSSSORespose.token,'wNiX17x7YsrmJREVJuNkWdbW');
                system.assertEquals(currLMSSSORespose.created_on,'2016-08-04T19:30:29-04:00');
                system.assertEquals(currLMSSSORespose.login_url,'https://wish.exceedlms-staging.com/authentication/token_sign_on?user_id=2563608&token=wNiX17x7YsrmJREVJuNkWdbW');
                system.assertEquals(currLMSSSORespose.enrollment_url,'https://wish.exceedlms-staging.com/student/home/show_enrollment/50174739');
            }catch(Exception ex){
                system.debug(ex.getMessage());
            }
        }   
        Test.stopTest();
    }
    // To validate createOrActivateLMSUser method
    static testmethod void createOrActivateLMSUser(){   
        LMS_Credentials__c currLMSCredential;   
        LMSCourseSyncMockImpl currLMSCourseSyncMockImpl = new LMSCourseSyncMockImpl();
        String payload;
        HttpResponse response = new HttpResponse();
        response.setStatus('OK');
        response.setStatusCode(200);
        LMSUserResponse currLLMSUserResponse =  new LMSUserResponse();      
        currLLMSUserResponse.id = 2369897;
        currLLMSUserResponse.login = 'test@test.com';
        currLLMSUserResponse.code = '12342345';
        currLLMSUserResponse.first_name = 'test';
        currLLMSUserResponse.last_name = 'test';
        currLLMSUserResponse.email = 'testupdate@test.com'; 
        currLLMSUserResponse.is_active = true;
        currLLMSUserResponse.last_login_at = '2016-08-04T19:20:05.407-04:00';   
        payload = JSON.serialize(currLLMSUserResponse);  
        response.setBody(payload);
        currLMSCourseSyncMockImpl.addResponse(response);
        Test.setMock(HttpCalloutMock.class, currLMSCourseSyncMockImpl);
        testClassUtil.createUser();
        testClassUtil.createUser();
        List<User> currUserLst = [SELECT ID,firstname,lastname,Email,Username FROM USER WHERE ID != : Userinfo.getUserId() and isactive = true];
        system.runAs(currUserLst[0]){       
            currLMSCredential = testClassUtil.createLMSCredentials();           
        } 
        Test.startTest();
        system.runAs(currUserLst[1]){
            try{
            System.debug('The value is +'+currUserLst[0].firstname+currUserLst[0].lastname+currUserLst[0].Email+currUserLst[0].lastname);               
                currLLMSUserResponse = LMSHttpRequest.createOrActivateLMSUser(currUserLst[0],currLMSCredential); 
                System.assertEquals(currLLMSUserResponse.id,2369897);
                System.assertEquals(currLLMSUserResponse.login , 'test@test.com');
                System.assertEquals(currLLMSUserResponse.code , '12342345');
                System.assertEquals(currLLMSUserResponse.first_name , 'test');
                System.assertEquals(currLLMSUserResponse.last_name ,'test');
                System.assertEquals(currLLMSUserResponse.email ,'testupdate@test.com'); 
                System.assertEquals(currLLMSUserResponse.is_active, true);
                System.assertEquals(currLLMSUserResponse.last_login_at, '2016-08-04T19:20:05.407-04:00');
            }catch(Exception ex){
                system.debug(ex.getMessage());
            }
        }   
        Test.stopTest();
    }
    // To validate createOrUpdateEnrollment method
    static testmethod void createOrUpdateEnrollment(){  
        LMS_Credentials__c currLMSCredential;   
        LMSCourseSyncMockImpl currLMSCourseSyncMockImpl = new LMSCourseSyncMockImpl();
        String payload;
        HttpResponse response = new HttpResponse();
        response.setStatus('OK');
        response.setStatusCode(200);
        LMSOrientationRegistrationResponse currLMSOrientationRegistrationResponse =  new LMSOrientationRegistrationResponse();      
        currLMSOrientationRegistrationResponse.id = 2369897;
        currLMSOrientationRegistrationResponse.user_id = 2369897;
        currLMSOrientationRegistrationResponse.account_id = 2369897;
        currLMSOrientationRegistrationResponse.course_id = 2369897;
        currLMSOrientationRegistrationResponse.enrolled_on = '2016-08-04T19:20:05.407-04:00';
        currLMSOrientationRegistrationResponse.due_on = '2016-08-04T19:20:05.407-04:00';    
        currLMSOrientationRegistrationResponse.started_on = 'true';
        currLMSOrientationRegistrationResponse.completed_on = '2016-08-04T19:20:05.407-04:00';   
        currLMSOrientationRegistrationResponse.expires_on = '2016-08-04T19:20:05.407-04:00';
        currLMSOrientationRegistrationResponse.status = 'test';
        currLMSOrientationRegistrationResponse.progress = 'test';   
        currLMSOrientationRegistrationResponse.score = '10';
        currLMSOrientationRegistrationResponse.currtime = 10;  
        currLMSOrientationRegistrationResponse.expires_on = 'test';
        currLMSOrientationRegistrationResponse.updated_on = '2016-08-04T19:20:05.407-04:00';
        currLMSOrientationRegistrationResponse.code = 'test@test.com';  
        currLMSOrientationRegistrationResponse.completed_activities_count = '10';
        currLMSOrientationRegistrationResponse.attachments_count = '10';
        currLMSOrientationRegistrationResponse.updated_by = 'test';  
        currLMSOrientationRegistrationResponse.accepted_invite = true;
        currLMSOrientationRegistrationResponse.pre_assessment_score = 'test';
        currLMSOrientationRegistrationResponse.pre_assessment_status = 'test';  
        currLMSOrientationRegistrationResponse.created_by = 'test';
        currLMSOrientationRegistrationResponse.graded_by_instructor_id = 'test';
        currLMSOrientationRegistrationResponse.created_on = 'test';
        currLMSOrientationRegistrationResponse.curriculum_activities_version = 'test';
        currLMSOrientationRegistrationResponse.user_code = 'test';  
        payload = JSON.serialize(currLMSOrientationRegistrationResponse);  
        response.setBody(payload);
        currLMSCourseSyncMockImpl.addResponse(response);
        Test.setMock(HttpCalloutMock.class, currLMSCourseSyncMockImpl);
        testClassUtil.createUser();
        testClassUtil.createUser();
        List<User> currUserLst = [SELECT ID FROM USER WHERE ID != : Userinfo.getUserId() AND IsActive = True];
        system.runAs(currUserLst[0]){       
            currLMSCredential = testClassUtil.createLMSCredentials();           
        } 
        Test.startTest();
        system.runAs(currUserLst[1]){
            try{
            System.debug('The value is +'+currUserLst[0]);              
            currLMSOrientationRegistrationResponse = LMSHttpRequest.createOrUpdateEnrollment(currLMSCredential,'Test','Test','Test'); 
            System.assertEquals(currLMSOrientationRegistrationResponse.id,2369897);
            System.assertEquals(currLMSOrientationRegistrationResponse.user_id,2369897);
            System.assertEquals(currLMSOrientationRegistrationResponse.account_id,2369897);
            System.assertEquals(currLMSOrientationRegistrationResponse.course_id,2369897);
            System.assertEquals(currLMSOrientationRegistrationResponse.enrolled_on,'2016-08-04T19:20:05.407-04:00');
            System.assertEquals(currLMSOrientationRegistrationResponse.due_on,'2016-08-04T19:20:05.407-04:00'); 
            System.assertEquals(currLMSOrientationRegistrationResponse.started_on,'true');
            System.assertEquals(currLMSOrientationRegistrationResponse.completed_on,'2016-08-04T19:20:05.407-04:00');   
            System.assertEquals(currLMSOrientationRegistrationResponse.expires_on,'test');
            System.assertEquals(currLMSOrientationRegistrationResponse.status,'test');
            System.assertEquals(currLMSOrientationRegistrationResponse.progress,'test');    
            System.assertEquals(currLMSOrientationRegistrationResponse.score,'10');
            System.assertEquals(currLMSOrientationRegistrationResponse.currtime,10);  
            System.assertEquals(currLMSOrientationRegistrationResponse.expires_on,'test');
            System.assertEquals(currLMSOrientationRegistrationResponse.updated_on,'2016-08-04T19:20:05.407-04:00');
            System.assertEquals(currLMSOrientationRegistrationResponse.code,'test@test.com');
            System.assertEquals(currLMSOrientationRegistrationResponse.completed_activities_count,'10');
            System.assertEquals(currLMSOrientationRegistrationResponse.attachments_count,'10');
            System.assertEquals(currLMSOrientationRegistrationResponse.updated_by,'test');  
            System.assertEquals(currLMSOrientationRegistrationResponse.accepted_invite,true);
            System.assertEquals(currLMSOrientationRegistrationResponse.pre_assessment_score,'test');
            System.assertEquals(currLMSOrientationRegistrationResponse.pre_assessment_status,'test');   
            System.assertEquals(currLMSOrientationRegistrationResponse.created_by,'test');
            System.assertEquals(currLMSOrientationRegistrationResponse.graded_by_instructor_id,'test');
            System.assertEquals(currLMSOrientationRegistrationResponse.created_on,'test');
            System.assertEquals(currLMSOrientationRegistrationResponse.curriculum_activities_version,'test');
            System.assertEquals(currLMSOrientationRegistrationResponse.user_code,'test');
            }catch(Exception ex){
                system.debug(ex.getMessage());
            }
        }   
        Test.stopTest();
    }
}