/*Created by : MST 
Description : This Webservice will be called by the buttom 'Get LMS Details' in the Class offering object for 'Virtual - Self Placed' record type. This class will make a call out the 
LMS system with the given course id to validate the  given course is avaible in the LMS. */
Global class LMSCourseSync {
    webservice static String getLMSCourseInfo(String courseID,String courseOfferingId){         
        Class_Offering__c currCourseOffering;
        LMSCourse course;        
        LMS_Credentials__c lMSCredential = LMS_Credentials__c.getValues('LMS Integration');
        if(courseID.length() == 0){
            return 'Please enter the Course ID and Try again!';        
        }
        if(lMSCredential != Null ){
            String[] courseIds = courseID.split(' ');
			String  courseParameter;          
            courseParameter = courseIds[0];            
            if(courseIds.size() > 0 ){
                for(integer i= 1; i< courseIds.size(); i++ ){
                    courseParameter = courseParameter +'%20'+courseIds[i]; 
                }
            }
            HttpRequest request = new HttpRequest();           
            request = LMSHttpRequest.createLMSHttpRequest(lMSCredential,lMSCredential.CourseEndpoint__c+courseParameter,'GET');
            Http http = new Http();
            HTTPResponse response;
            try{
                response = http.send(request); 
                system.debug('the response is ++ '+response);                
            }catch(Exception ex){
                System.debug('ex'+ex.getmessage());
                return 'Exception caused, Please retry again or contact System Adminstrator'; 
            }
            System.debug(course);
            if(response.getStatusCode() == 200){
                course = LMSCourse.parse(response.getBody());
                if(course != Null ){
                    currCourseOffering =[SELECT ID,Course_Name__c,Description__c FROM Class_Offering__c WHERE Id =:courseOfferingId];
                    boolean isupdated = false;
                    if(currCourseOffering.Course_Name__c != course.name){
                        currCourseOffering.Course_Name__c = course.name;
                        isupdated = true;    
                    }
                    if(currCourseOffering.Description__c != course.summary){
                        currCourseOffering.Description__c = course.summary;
                        isupdated = true;    
                    }
                    try{
                        if(isupdated){
                            Update currCourseOffering;
                        }
                        
                    }catch(Exception ex){
                        System.debug('ex'+ex.getmessage());
                        return 'Exception caused, Please retry again or contact System Adminstrator'; 
                    }
                } 
            }
            else{
                return 'Invalid Course ID. Please check the Course ID.';    
            }
            return 'Valid Course ID!';    
        }else {
            return 'Exception caused, Please retry again or contact System Adminstrator';     
        }
    }
    
}