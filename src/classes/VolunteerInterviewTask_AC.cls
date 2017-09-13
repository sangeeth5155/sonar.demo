global class VolunteerInterviewTask_AC
{
    public static String auth{get;set;}
    public static String accessToken;
    public static IntegrationUserSettings__c integrationSetting  = IntegrationUserSettings__c.getValues('Integration User');
    
    Public Static String AuthorizeWebServiceCallout()
    {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        Map<String, Object> responseMap = new Map<String, Object>();
        
        auth = 'grant_type=password&client_id='+integrationSetting.grant_type_password_client_id__c+'&client_secret='+integrationSetting.client_secret__c+'&username='+integrationSetting.username__c+'&password='+integrationSetting.password__c;
        req.setEndpoint(integrationSetting.URL__c+'/services/oauth2/token?'+auth);
        //req.setBody(auth);
        req.setMethod('POST');
        try {
        
            if((!Test.isRunningTest()))
                res = http.send(req);
                
            responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getbody());
            return string.valueof(responseMap.get('access_token'));
        }
        catch(Exception e) {
            System.debug('Authorization Error ---------- '+ e.getMessage());
            return NULL;
        }
    }


   global static string getClassOfferingRecList(String contactId){
      
        if(!Test.isRunningTest()){        
            accessToken = AuthorizeWebServiceCallout();
        }
        
        if(accessToken != NULL){
            
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setEndpoint(integrationSetting.Rest_URL__c+'/services/apexrest/orientation/'+contactId);
            req.setMethod('GET');
            req.setHeader('Authorization','OAuth '+accessToken);
            
            try {
                res = http.send(req);
                system.debug('RRRRes : ' + res.getBody());
                return res.getBody();
            } catch(Exception e) {
                System.debug('---Callout error-------'+ e.getMessage());
                return 'Error while retriving records :'+e.getMessage();
            }
        } else {
            return 'No Access Token Retrived';
        }
    }  
    
    
    global static string getUploadReviewTask(String contactId){
      SYstem.debug('RestMet>>>>>>>>>>>');
        if(!Test.isRunningTest()){        
            accessToken = AuthorizeWebServiceCallout();
        }
        
        if(accessToken != NULL){
            
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setEndpoint(integrationSetting.Rest_URL__c+'/services/apexrest/uploadTask/'+contactId);
            req.setMethod('GET');
            req.setHeader('Authorization','OAuth '+accessToken);
            
            try {
                res = http.send(req);
                system.debug('RRRRes : ' + res.getBody());
                return res.getBody();
            } catch(Exception e) {
                System.debug('---Callout error-------'+ e.getMessage());
                return 'Error while retriving records :'+e.getMessage();
            }
        } else {
            return 'No Access Token Retrived';
        }
    }  
}