/* Created by : MST
Description : This Class used to make callouts to LMS.
*/
public class LMSHttpRequest {
    //To create LMSRequest 
    public static HttpRequest createLMSHttpRequest(LMS_Credentials__c lMSCredential,String endPoint,String methodType){
        HttpRequest request = new HttpRequest();
        if(lMSCredential != Null && endPoint != Null && methodType != Null ){
            String endpointUrl = lMSCredential.End_Point_URL__c + endPoint;
            String userName = lMSCredential.User_Name__c;
            String password = lMSCredential.Password__c;        
            request.setEndpoint(endpointUrl);
            request.setMethod(methodType);  
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' +EncodingUtil.base64Encode(headerValue);
            request.setHeader('authorization', authorizationHeader);
        }
        return request;
    }
    // To get SSO details of the LMS User
    public static LMSSSORespose getLMSSSODetails(LMS_Credentials__c lMSCredential,String volunteerLMSId,String courseCode){
        LMSSSORespose lMSSSOResponse = new LMSSSORespose();
        if(lMSCredential != Null && volunteerLMSId != Null){ 
            String[] courseIds = courseCode.split(' ');
            String  courseParameter;          
            courseParameter = courseIds[0];            
            if(courseIds.size() > 0 ){
                for(integer i= 1; i< courseIds.size(); i++ ){
                    courseParameter = courseParameter +'%20'+courseIds[i]; 
                }
            }
            HttpRequest request = new HttpRequest();
            request = createLMSHttpRequest(lMSCredential,lMSCredential.SSOEndPoint__c+volunteerLMSId+'?course_code='+courseParameter,'GET');           
            Http http = new Http();
            HTTPResponse response;
            try{
                response = http.send(request); 
                lMSSSOResponse = LMSSSORespose.parse(response.getBody());
                System.debug('lMSSSOResponse+++++++++++'+lMSSSOResponse);
            }catch(Exception ex){
                System.debug('ex'+ex.getmessage());                
            }
        } 
        return lMSSSOResponse;
    }
    // To create or active users in LMS
    public static LMSUserResponse createOrActivateLMSUser(User currVolunteerUser,LMS_Credentials__c lMSCredential){
        LMSUserResponse currLMSUserResponse = new LMSUserResponse();
            if(lMSCredential != Null && currVolunteerUser != null){
                HttpRequest request = new HttpRequest();
                request = createLMSHttpRequest(lMSCredential,lMSCredential.UserCreaationEndpoint__c,'POST');                
                request.setHeader('Content-Type', 'application/json');
                LMSUserRequest userRequestDetails = new LMSUserRequest();
                userRequestDetails.login = currVolunteerUser.Username;
                System.debug('The FirstName ++'+currVolunteerUser.FirstName);
                userRequestDetails.first_name = currVolunteerUser.FirstName;    
                userRequestDetails.last_name = currVolunteerUser.LastName;  
                userRequestDetails.email = currVolunteerUser.Email; 
                userRequestDetails.password = currVolunteerUser.LastName;
                userRequestDetails.chapter_id= currVolunteerUser.contact.Region_Chapter__r.Chapter_Id__c;
                String requestPayLoad = JSON.serialize(userRequestDetails);
                request.setBody(requestPayLoad);                     
                Http http = new Http();
                HTTPResponse response;
                try{
                    response = http.send(request); 
                    System.debug('The response is + '+response.getBody());
                    currLMSUserResponse = LMSUserResponse.parse(response.getBody());
                    System.debug('lMSSSOResponse+++++++++++'+currLMSUserResponse);
                    /*if(currVolunteerUser.LMS_Id__c != String.valueOf(currLMSUserResponse.id) || currVolunteerUser.LMS_Login__c !=  String.valueOf(currLMSUserResponse.login) || currVolunteerUser.LMS_User_Code__c != String.valueOf(currLMSUserResponse.code) ){
                        currVolunteerUser.LMS_Id__c = String.valueOf(currLMSUserResponse.id);
                        currVolunteerUser.LMS_Login__c = String.valueOf(currLMSUserResponse.login);
                        currVolunteerUser.LMS_User_Code__c = String.valueOf(currLMSUserResponse.code);
                        Update currVolunteerUser;    
                    }*/
                    
                }catch(Exception ex){
                    System.debug('ex'+ex.getmessage());
                }
            } 
            return currLMSUserResponse;
    }
    //To create or update Enrollment in LMS
    public static LMSOrientationRegistrationResponse createOrUpdateEnrollment(LMS_Credentials__c lMSCredential,String courseId,String userLogin,String enrollmentStatus){
        LMSOrientationRegistrationResponse currLMSOrientationRegistrationResponse = new LMSOrientationRegistrationResponse();
        System.debug('The request paramenter are lMSCredential'+ lMSCredential + 'courseId+'+courseId + 'userLogin+'+userLogin+'enrollmentStatus+'+enrollmentStatus);
        if(lMSCredential != Null && courseId != Null && userLogin != Null && enrollmentStatus != Null ){
            HttpRequest request = new HttpRequest();
            request = createLMSHttpRequest(lMSCredential,lMSCredential.EnrollmentEndPoint__c,'POST');                           
            request.setHeader('Content-Type', 'application/json');
            LMSOrientationRegistrationRequest currLMSOrientationRegistrationRequest = new LMSOrientationRegistrationRequest();
            currLMSOrientationRegistrationRequest.course_code = courseId;
            currLMSOrientationRegistrationRequest.user_login = userLogin;
            currLMSOrientationRegistrationRequest.status = enrollmentStatus;
            String requestPayLoad = JSON.serialize(currLMSOrientationRegistrationRequest);
            request.setBody(requestPayLoad);                     
            Http http = new Http();
            HTTPResponse response;
            try{
                response = http.send(request); 
                System.debug('The response is + '+response.getBody());
                currLMSOrientationRegistrationResponse = LMSOrientationRegistrationResponse.parse(response.getBody());                       
            }catch(Exception ex){
                System.debug('ex'+ex.getmessage());                            
            }
        }
        return currLMSOrientationRegistrationResponse;
    }
}