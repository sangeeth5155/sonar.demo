@isTest(SeeAllData=true)
global class Mock_ResponseGenerator implements HttpCalloutMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        String account;
        String UserName;
        String Password;
        String IntegratorKey;
        
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        
        for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
              UserName = credentialIns.name;
              account  = credentialIns.account__c;
              Password = credentialIns.Password__c;
              IntegratorKey  = credentialIns.IntegratorKey__c;
              
        }
        // Optionally, only send a mock response for a specific endpoint and method.
        //System.assertEquals('https://demo.docusign.net/restapi/v2/accounts/'+account+'/envelopes', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());       
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json'); 
        // Parse JSON response to get all the field values.
        JSONParser parser = JSON.createParser(req.getBody());
        res.setBody('{"url":"https://mstdev-make-a-wish-mstdev.cs18.force.com/VolunteerLanding1_VF","status":"sent","enableWetSign":"false","emailBlurb":"Test Email Body","emailSubject":"Test Email Subject","enforceSignerVisibility":"True","documents":[{"name":"document.pdf","documentId":"1","order":"1","documentBase64":"JVBERi0xLjQKJMKJSVFT0YK"}],"recipients":{"signers":[{"email":"vennila@mstsolutions.com","name":"saravanan test","recipientId":"1","clientUserId":"1","tabs":{"signHereTabs":[{"anchorString":"~s1","anchorXOffset":"0.6","anchorYOffset":"0.1","anchorIgnoreIfNotPresent":"false","anchorUnits":"inches"}]}}]}}');
        res.setStatusCode(200);
        return res;
    }  
}