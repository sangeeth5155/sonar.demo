/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj & Vennila
Date        : 5/23/2016
Location    : This class referred in the Application_VF page.
Description : This Application VF and Controller used to capture the volunteer details from the portal and Update
their corresponding volunteer details inside the salesforce.
In this page, volunteer role is displaying the values based on the  volunteer chapter roles. If the volunteer selects 
the roles and hit [Save] button, It would update the value in Volunteer Role field as well as creating 
Volunteer Role custom record.
If the user enters all the mandatory fields on the form and hit [Save] button, It will display [Submit & Sign] button
on the detailed mode. else [Submit & Sign] won't display. 
If the user hits [Submit & Sign] button, It will redirect user to docusign page for capturing volunteer sign. Once sign completed,
It will create Conflict of Interst and Docusign status record with atttachment.
*******************************************************************************************************************/

public class Application_AC{
    Public contact currentVolunteer{get;set;}
    public boolean saveMode{get;set;}
    public boolean editMode{get;set;}
    public boolean showSubmitButton{get;set;}
    public Id contactId; 
    public Id currAccountId;
    public String dynamicName{get;set;}
    public String applicationDynamicContent{get;set;}
    public boolean submitDisable{get;set;}
    Constant_AC  constant = new Constant_AC();
    public Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
    public Id boardMemberContactRecTyped = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.boardMemberRT).getRecordTypeId();
    public boolean isSigned{get;set;}
    public set<String> chaptersNameSet = new Set<String>();
    public boolean showSubmitandSign{get;set;}
    public list<string> volRoles{get;set;}
    public list<String> professionalSkillsList{get;set;}
    public list<String> langToRead{get;set;}
    public list<String> langToWrite{get;set;}
    public list<String> langToSpeak{get;set;}
    public list<String> langToUndetstand{get;set;}
    public list<String> languagesList{get;set;}
    public list<String> howKnowAbtMAWA{get;set;}
    public List<roleWrapper> roleDiscriptionList{get;set;}
    public boolean displayPopup {get; set;}   
    public Set<String> roleNameSet{get;set;}
    public boolean bgTabPermission{get;set;}
    public boolean trainingTabVisible{get;set;}
    public Boolean displaySignNowPopup{get;set;}
    public String contactName{get;set;}
    
    /*It will fetch the current volunteer details and display this information into Application_VF page. */ 
    public Application_AC(){
        List<User> userIns =  [SELECT Id, ContactId FROM User WHERE Id =: userInfo.getUserId()];
        contactId  = userIns[0].contactId;
        showSubmitandSign  = false;
        displaySignNowPopup = false;
        String myId = ApexPages.currentPage().getParameters().get('event');
        Boolean showEdit = false;
        volRoles = new List<String>();
        langToRead = new List<String>();
        langToSpeak = new List<String>();
        langToWrite = new List<String>();
        langToUndetstand = new List<String>();
        languagesList  = new List<String>();
        howKnowAbtMAWA = new List<String>();
        professionalSkillsList = new List<String>();
        String signingStatus = '';
        
        if(ApexPages.currentPage().getParameters().get('showeditMode') != Null)
                showEdit = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showeditMode'));
                
        if(ApexPages.currentPage().getParameters().get('event') != Null)
                signingStatus = ApexPages.currentPage().getParameters().get('event');
                
           // Based on the parameter value, It would display Background tab.
        if(ApexPages.currentPage().getParameters().get('bgRequired') != Null)
                bgTabPermission = Boolean.valueOf(ApexPages.currentPage().getParameters().get('bgRequired'));
          if(ApexPages.currentPage().getParameters().get('trainingRequired') != Null)
                trainingTabVisible = Boolean.valueOf(ApexPages.currentPage().getParameters().get('trainingRequired'));
        if(userIns[0].contactId == NULL) {
            currentVolunteer= new Contact();
            currentVolunteer.RecordTypeId = volunteerRecordTypeId;
        }
        else{
            
            system.debug('@@@@@ Hi @@@@@'+volunteerRecordTypeId);
            system.debug('@@@@@ Hi @@@@@'+contactId);
            
            system.debug('++++++++++' + [select id, recordTypeId from contact where id =: contactId]);
            currentVolunteer= [SELECT id,Title, Salutation,RecordTypeId,FirstName,Middle_Name__c,LastName,State_Employer__c,Preferred_Name__c,Birth_Month__c,Birth_Day__c,HomePhone,Alternate_Phone_Type__c,Preferred_Phone_Types__c,MobilePhone,
                    OtherPhone,Email,I_m_on_LinkedIn__c,How_did_you_hear_about_Make_A_Wish__c,MailingStreet,MailingCity,mailingstatecode,MailingCountrycode,MailingPostalCode,
                   Employer__c,Position__c,Street_Employer__c,City_Employer__c,Zip_Employer__c,May_We_Contact_You_at_Work__c,Interested_involved_with_Make_A_Wish__c,
                   Emergency_Contact__c,Emergency_Contact_Phone__c,Professional_Skills__c,Language__c,Language_Notes__c,Read__c,Write__c,Speak__c,Understand__c,
                   Volunteer_Role__c,is_Application__c,work_phone__c,MailingState,Emergency_Contact_Relationship__c,county__c,Professional_Skills_Other_Notes__c,
                   How_did_you_know_MAWA_Other_Notes__c FROM Contact WHERE (RecordTypeId =: volunteerRecordTypeId OR RecordTypeId =:boardMemberContactRecTyped) AND Id =:contactId];
            
            currentVolunteer.mailingState = currentVolunteer.MailingState;
            currentVolunteer.Emergency_Contact_Relationship__c = currentVolunteer.Emergency_Contact_Relationship__c;
            currentVolunteer.State_Employer__c = currentVolunteer.State_Employer__c;
            currentVolunteer.I_m_on_LinkedIn__c = currentVolunteer.I_m_on_LinkedIn__c;
            currentVolunteer.May_We_Contact_You_at_Work__c = currentVolunteer.May_We_Contact_You_at_Work__c;
            currentVolunteer.Interested_involved_with_Make_A_Wish__c = currentVolunteer.Interested_involved_with_Make_A_Wish__c;
            currentVolunteer.Salutation = currentVolunteer.Salutation;
            currentVolunteer.Birth_Month__c = currentVolunteer.Birth_Month__c;
            if(currentVolunteer.Birth_Day__c  != Null)
            currentVolunteer.Birth_Day__c = currentVolunteer.Birth_Day__c;
            contactName = currentVolunteer.Name;
         /*   if(currentVolunteer.Preferred_Phone_Types__c == 'Home' && currentVolunteer.Alternate_Phone_Type__c == 'Mobile'){
                currentVolunteer.HomePhone =   currentVolunteer.HomePhone;
                currentVolunteer.MobilePhone  = currentVolunteer.MobilePhone ;
                
            }
            if(currentVolunteer.Preferred_Phone_Types__c == 'Mobile' && currentVolunteer.Alternate_Phone_Type__c == 'Home'){
                String mobileNo = currentVolunteer.MobilePhone;
                currentVolunteer.MobilePhone = currentVolunteer.HomePhone;
                currentVolunteer.HomePhone = mobileNo;
              
            }
            
            
            if(currentVolunteer.Preferred_Phone_Types__c == 'Home' && currentVolunteer.Alternate_Phone_Type__c == 'Home'){
                currentVolunteer.HomePhone = currentVolunteer.HomePhone;
                currentVolunteer.MobilePhone = currentVolunteer.OtherPhone;
             
                
            }
            
             if(currentVolunteer.Preferred_Phone_Types__c == 'Mobile' && currentVolunteer.Alternate_Phone_Type__c == 'Mobile'){
                currentVolunteer.HomePhone = currentVolunteer.OtherPhone;
                currentVolunteer.MobilePhone = currentVolunteer.MobilePhone;
                
            } */
            
            
            if(currentVolunteer.volunteer_role__c != Null)
            {
                for(String role : currentVolunteer.volunteer_role__c.split(';'))
                {
                    volRoles.add(role);
                    
                }
            }
            
            if(currentVolunteer.read__c!= Null)
            {
                for(String read: currentVolunteer.read__c.split(';'))
                {
                    langToRead.add(read);
                }
            }
            else
            {
            
                langToRead.add('English');

            }
            if(currentVolunteer.Speak__c!= Null)
            {
                for(String speak: currentVolunteer.Speak__c.split(';'))
                {
                    langToSpeak.add(speak);
                }
            }
            else
            {
                langToSpeak.add('English');
            }
            
            if(currentVolunteer.Write__c != Null)
            {
                for(String write : currentVolunteer.Write__c.split(';'))
                {
                    langToWrite.add(write);
                }
            }
            else
            {
               langToWrite.add('English');
            }
          
            if(currentVolunteer.Understand__c != Null)
            {
                for(String understand : currentVolunteer.Understand__c.split(';'))
                {
                    langToUndetstand.add(understand);
                }
            }
            else
            {
                langToUndetstand.add('English');
            }
            
            if(currentVolunteer.Language__c != Null)
            {
                for(String lang: currentVolunteer.Language__c.split(';'))
                {
                    languagesList.add(lang);
                }
            }
            else
            {
                 languagesList.add('English');
            }
            if(currentVolunteer.How_did_you_hear_about_Make_A_Wish__c!= Null)
            {
                for(String mwa: currentVolunteer.How_did_you_hear_about_Make_A_Wish__c.split(';'))
                {
                    howKnowAbtMAWA.add(mwa);
                }
            }
            if(currentVolunteer.Professional_Skills__c!= Null)
            {
                for(String mwa: currentVolunteer.Professional_Skills__c.split(';'))
                {
                    professionalSkillsList.add(mwa);
                }
            }
            
            
           
        } 
        
        if(signingStatus == 'signing_complete' || currentVolunteer.is_Application__c == 'Complete' || currentVolunteer.is_Application__c == 'Approved')
        {
           isSigned=True;
           editMode = True;
        }
        
        else if(currentVolunteer.is_Application__c == 'Submit' || currentVolunteer.is_Application__c == 'Fully Submit' || currentVolunteer.is_Application__c == 'Partial Submit' || currentVolunteer.is_Application__c == 'Rejected')
        {
          isSigned = false;
          editMode = false;
          saveMode = True;
        }
          
        if(currentVolunteer.is_Application__c == '' || currentVolunteer.is_Application__c == Null || showEdit ==True){
            saveMode = true;
        }
        for(npe5__Affiliation__c currContactAffiliation : [SELECT Id,npe5__Primary__c, npe5__Organization__c, npe5__Contact__c FROM npe5__Affiliation__c WHERE npe5__Contact__c =: contactId]){
            
           if(currContactAffiliation.npe5__Primary__c == true)
           { 
              currAccountId = currContactAffiliation.npe5__Organization__c;
           }
           chaptersNameSet.add(currContactAffiliation.npe5__Organization__c);
        }
        
        If(currAccountId != Null){
            String nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.nationalRT).getRecordTypeId();
            List<Dynamic_Content__c> dynamicContent = [SELECT Id,Application_Overview__c,Chapter_Name__c FROM Dynamic_Content__c WHERE Active__c = True AND RecordTypeId = :nationalRT];
            if(dynamicContent.size() > 0){
                applicationDynamicContent = dynamicContent[0].Application_Overview__c;
            }
        }
    }
    
    /* this saveRec() method is used to update the current volunteer contact information.*/
    public PageReference saveRec()
    {  
         System.debug('currentVolunteer.birth_day++++++++++++++++++++++++++++++++ ' + currentVolunteer.birth_day__c);
         if(howKnowAbtMAWA != Null)
            {
               
                String howDidYouKnowMAWA ='';
                for(String s : (howKnowAbtMAWA))
                {
                  howDidYouKnowMAWA+=s+';';
                }
                currentVolunteer.How_did_you_hear_about_Make_A_Wish__c = howDidYouKnowMAWA.removeEnd(';');
            }
               
            if(languagesList != Null)
            {
              
                String language ='';
                for(String s : (languagesList))
                {
                  language+=s+';';
                }
                currentVolunteer.Language__c  = language.removeEnd(';');
            }
            
            if(langToRead!= Null)
            {
                String read ='';
                for(String s : langToRead)
                {
                  read+=s+';';
                }
                currentVolunteer.read__c= read.removeEnd(';');
            }
            if(langToWrite != Null)
            {
                String write ='';
                for(String s : langToWrite)
                {
                  write+=s+';';
                }
                currentVolunteer.write__c = write.removeEnd(';');
            }
            if(langToSpeak!= Null)
            {
               
                String speak='';
                for(String s : langToSpeak)
                {
                  speak+=s+';';
                }
                currentVolunteer.speak__c= speak.removeEnd(';');
            }
            if(langToUndetstand!= Null)
            {
              
                String understand='';
                for(String s : (langToUndetstand))
                {
                  understand+=s+';';
                }
                currentVolunteer.Understand__c= understand.removeEnd(';');
            }
            if(professionalSkillsList != Null)
            {
              
                String skill ='';
                for(String s : (professionalSkillsList))
                {
                  skill+=s+';';
                }
                currentVolunteer.Professional_Skills__c= skill.removeEnd(';');
            }
            if(volRoles!= Null)
            {
                String roles='';
                for(String s : (volRoles))
                {
                  roles+=s+';';
                }
                currentVolunteer.volunteer_role__c= roles.removeEnd(';');
            }
            if(currentVolunteer.Preferred_Phone_Types__c == Null || currentVolunteer.Preferred_Phone_Types__c == ''){
                currentVolunteer.Preferred_Phone_Types__c='Mobile';
            }
            
        PageReference pr ;
       
        try{
        
            if(currentVolunteer.LastName == Null || currentVolunteer.Email == Null || currentVolunteer.Title == Null || currentVolunteer.FirstName == Null || currentVolunteer.Birth_Month__c == Null
               || currentVolunteer.Birth_Day__c == Null || currentVolunteer.Preferred_Phone_Types__c == Null || currentVolunteer.HomePhone == Null || currentVolunteer.HomePhone == '' || currentVolunteer.I_m_on_LinkedIn__c == NULL || currentVolunteer.How_did_you_hear_about_Make_A_Wish__c == NULL || currentVolunteer.MailingStreet == NULL || currentVolunteer.MailingCity == NULL 
               || currentVolunteer.county__c == NULL || currentVolunteer.MailingPostalCode == NULL|| currentVolunteer.mailingstatecode == NULL || currentVolunteer.Emergency_Contact__c == NULL || currentVolunteer.Emergency_Contact_Relationship__c == NULL 
               || currentVolunteer.Emergency_Contact_Phone__c == NULL || currentVolunteer.Read__c == NULL || currentVolunteer.Write__c == NULL || currentVolunteer.Speak__c == NULL || currentVolunteer.Understand__c == NULL ||   
               currentVolunteer.Language__c == NULL || currentVolunteer.volunteer_role__c == Null){
                   
                   currentVolunteer.is_Application__c = 'Partial Submit';
               }
            
            else{
                
                currentVolunteer.is_Application__c = 'Fully Submit';
                
            }
            
          /*  if(currentVolunteer.Preferred_Phone_Types__c == 'Home' && currentVolunteer.Alternate_Phone_Type__c == 'Mobile'){
                currentVolunteer.HomePhone =   currentVolunteer.HomePhone;
                currentVolunteer.MobilePhone  = currentVolunteer.MobilePhone ;
                currentVolunteer.OtherPhone = Null;
            }
            if(currentVolunteer.Preferred_Phone_Types__c == 'Mobile' && currentVolunteer.Alternate_Phone_Type__c == 'Home'){
                String mobileNo = currentVolunteer.MobilePhone;
                currentVolunteer.MobilePhone = currentVolunteer.HomePhone;
                currentVolunteer.HomePhone = mobileNo;
                currentVolunteer.OtherPhone = Null;
            }
            
            
            if(currentVolunteer.Preferred_Phone_Types__c == 'Home' && currentVolunteer.Alternate_Phone_Type__c == 'Home'){
                currentVolunteer.HomePhone = currentVolunteer.HomePhone;
                currentVolunteer.OtherPhone = currentVolunteer.MobilePhone;
                currentVolunteer.MobilePhone = Null;
                
            }
            
             if(currentVolunteer.Preferred_Phone_Types__c == 'Mobile' && currentVolunteer.Alternate_Phone_Type__c == 'Mobile'){
                currentVolunteer.HomePhone = currentVolunteer.HomePhone;
                currentVolunteer.MobilePhone = currentVolunteer.MobilePhone;
                currentVolunteer.OtherPhone = currentVolunteer.HomePhone;
                currentVolunteer.HomePhone = Null;
            } */
            
            update currentVolunteer;
            if(!displaySignNowPopup){
                pr = new PageReference('/apex/Application_VF?showeditMode=true'+'&bgRequired='+bgTabPermission+'&trainingRequired='+trainingTabVisible);
                pr.setRedirect(true); 
                return pr;
            }
            
        }
        catch(Exception  e){
            system.debug('Error Message==>'+e);
        }
        
        return null;
    }
    
    public pageReference confirmSign(){
     List<ProcessInstance> approvalIns =  [SELECT TargetObjectId,Status,ProcessDefinitionId,ProcessDefinition.Name FROM ProcessInstance WHERE TargetObjectId =: currentVolunteer.Id AND Status =: 'Pending' ];
          If(approvalIns.size() > 0){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,' This record is already in approval process'));
             
        }
        else{
        displaySignNowPopup = true;
        saveRec();
        }
        return null;
    }
      
   /*This SubmitAndSign() method is used when the volunteer fill all the required field then it will redirect docusign page
     Once the user sign the document then it create new conflict of interest record and it will redirect to the application_VF page*/
   public Pagereference SubmitAndSign(){
      
     
       
        String account;
        String UserName;
        String Password;
        String IntegratorKey;
        String endPointURL;
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        
        for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
              UserName = credentialIns.name;
              account  = credentialIns.account__c;
              Password = credentialIns.Password__c;
              IntegratorKey  = credentialIns.IntegratorKey__c;
              endPointURL = credentialIns.end_Point__c;
        }
        string endpoint = endPointURL+'/accounts/'+account+'/envelopes';
        String authorizationHeader = '<DocuSignCredentials><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
        String boundary = 'AAA';
        
        Pagereference PDF = Page.Application_PDF_VF;
        PDF.getParameters().put('id',currentVolunteer.id);

        String documentPDF;
        
        try {
        documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
        
        }catch(Exception e) {
        // Generic exception handling code here.
        }
        system.debug('+currentVolunteer.email'+currentVolunteer.email); 
        String body =  '{'+
            '  "status":"sent",'+
            '  "enableWetSign": "false",'+
            '  "emailBlurb":"Volunteer Application Form",'+
            '  "emailSubject": "Volunteer Application Form",'+
            '  "enforceSignerVisibility":"True",'+
            '  "documents": [{'+
            '      "name": "document.pdf",'+
            '      "documentId":"1",'+
            '      "order":"1",'+
            '      "documentBase64":"'+documentPDF+'"'+
            '  }],'+
            '"recipients": {'+
            '    "signers" : [{'+
            '      "email": "'+currentVolunteer.email+'",'+
            '      "name": "'+currentVolunteer.FirstName+' '+currentVolunteer.LastName+'",'+
            '      "recipientId":"1",'+
            '      "clientUserId":"1",'+
            '      "tabs": {'+
            '                "signHereTabs": [{'+
            '                    "anchorString": "~s1",'+
            '                    "anchorXOffset": "0.1",'+
            '                    "anchorYOffset": "0.1",'+
            '                    "anchorIgnoreIfNotPresent": "false",'+
            '                    "anchorUnits": "inches"'+
            '                }],'+
            '                "dateSignedTabs": [{'+
            '                      "anchorString": "~date",'+
            '                       "anchorXOffset": "0",'+
            '                       "fontSize":      "Size14",'+
            '                       "fontColor":     "Black",'+
            '                        "anchorYOffset": "0",'+
            '                        "anchorIgnoreIfNotPresent": "false",'+
            '                        "xPosition": "100",'+
            '                        "yPosition": "72",'+
            '                        "anchorUnits": "inches"'+
            '                    }]'+
            '            }'+
            '    }]'+
            '  }'+
            '}';
        
        String header = '--'+boundary+'\nContent-Type: application/json\nContent-Disposition: form-data';
        String jsonBody = header +'\n\n'+body+'\n\n--'+boundary+'--';
        system.debug(jsonBody);
        //Callout to Docusign.
        HttpRequest req = new HttpRequest();
        req.setHeader('X-DocuSign-Authentication', authorizationHeader);
        req.setHeader('Accept','application/json');
        req.setHeader('Host','demo.docusign.net');
        req.setHeader('Content-Length','162100');
        req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
        req.setEndpoint(endpoint);
        req.setMethod('POST'); 
        req.setBody(jsonBody);
        Http http = new Http();
        HTTPResponse res;
        
        res = http.send(req);
        system.debug(res.getBody());
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        if((String) results.get('envelopeId')!=''){
            String env = (String) results.get('envelopeId');
            
            string endpoint2 = endPointURL+'/accounts/'+account+'/envelopes/'+env+'/views/recipient';
            HttpRequest request = new HttpRequest();
            request.setHeader('X-DocuSign-Authentication', authorizationHeader);
            request.setHeader('Accept','application/json');
            request.setHeader('Host','demo.docusign.net');
            request.setHeader('Content-Length','162100');
            request.setHeader('Content-Type','application/json');
            request.setMethod('POST'); 
            Http httprequest = new Http();
            HTTPResponse response;
            request.setEndpoint(endpoint2);
            string jsonPayload;
            system.debug('URL.getSalesforceBaseUrl().toExternalForm()'+URL.getSalesforceBaseUrl().toExternalForm());
            jsonPayload = '{'+
                '    "userName": "'+currentVolunteer.FirstName+' '+currentVolunteer.LastName+'",'+
                '    "email": "'+currentVolunteer.email+'",'+
                '    "recipientId": "1",'+
                '    "clientUserId": "1",'+
                '    "authenticationMethod": "None",'+
                '    "returnUrl": "'+label.Site_Url+'/Application_VF"'+
                '}';     
            request.setBody(jsonPayload);
            response = httprequest.send(request); 
            system.debug('@@@@@@@ response @@@@@@@@'+response.getBody());
            results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            system.debug('@@@@@@@ results  @@@@@@@@'+results);
            if((String) results.get('url') != '' || (String) results.get('url') != null){
            system.debug('@@@@@@@ DOCUSIGN APPLICATION @@@@@@@@'+results.get('url'));
                dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                dsfs.dsfs__DocuSign_Envelope_ID__c = env;
                dsfs.Docusign_Hidden_Contact__c = currentVolunteer.id;
                Insert dsfs;  
                system.debug('@@@@@@@ DOCUSIGN APPLICATION @@@@@@@@'+dsfs);
                if(dsfs.id != Null){
                    currentVolunteer.is_Application__c = 'Submit';
                    currentVolunteer.onboarding_status__c = 'Application';
                    if(!Test.isRunningTest())
                    update currentVolunteer;
                  
                }
                
                PageReference reference=new PageReference((String) results.get('url'));
                reference.setRedirect(true);
                return reference;
               
            }
        }
       return null;
        
    }
    
    /*The current volunteer contact can edit their details using this EditRec().*/
    public PageReference EditRec(){
        PageReference pr ;
        pr = new PageReference('/apex/Application_VF?showeditMode=True'+'&bgRequired='+bgTabPermission+'&trainingRequired='+trainingTabVisible);
        pr.setRedirect(true);
        return pr;
        
    }
    /*To display the state value of current logged in volunteer contact in community.*/
    public List<SelectOption> getStates(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.State_Picklist__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Please select state')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }  
    /*To display the date value of birth day for current logged in volunteer contact in community.*/
    public List<SelectOption> getDays(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Day', 'Day')); 
        for(integer i=0;i<=31;i++)
        {      options.add(new SelectOption(String.valueOf(i), String.valueOf(i))); 
        }  
        return options;
    }  
     /*To display the month value of birth month for current logged in volunteer contact in community.*/
    public List<SelectOption> getMonths(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Month', 'Month')); 
        options.add(new SelectOption('January', 'January')); 
        options.add(new SelectOption('February', 'February')); 
        options.add(new SelectOption('March', 'March')); 
        options.add(new SelectOption('April', 'April')); 
        options.add(new SelectOption('May', 'May')); 
        options.add(new SelectOption('June', 'June')); 
        options.add(new SelectOption('July', 'July')); 
        options.add(new SelectOption('August', 'August')); 
        options.add(new SelectOption('September', 'September')); 
        options.add(new SelectOption('October', 'October')); 
        options.add(new SelectOption('November', 'November')); 
        options.add(new SelectOption('December', 'December')); 
        return options;
    }  
    /*To display the Language values of current logged in volunteer contact in community.*/
    public List<SelectOption> getLanguages(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Language__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
    /*To display value of HowdidyouhearaboutMakeAWish for current logged in volunteer contact in community.*/
    public List<SelectOption> getHowdidyouhearaboutMakeAWish(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.How_did_you_hear_about_Make_A_Wish__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }   
    /*To display ProfessionalSKills values for current logged in volunteer contact in community.*/
    public List<SelectOption> getProfessionalSKills(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Professional_Skills__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }    
   /*To display Role values for current logged in volunteer contact in community.*/
    public List<SelectOption> getRoles(){
        List<SelectOption> options = new List<SelectOption>();
        
        for(Chapter_Role__c currRole : [SELECT ID,Role_Name__c,Role_Name__r.Name,Role_Name__r.Description__c,Role_Name__r.Exclude_from_Application__c FROM Chapter_Role__c WHERE Chapter_name__c IN: chaptersNameSet AND Role_Name__r.Exclude_from_Application__c = False])
        {
          if(currRole.Role_Name__c != Null)      
             options.add(new SelectOption(currRole.Role_Name__r.name, currRole.Role_Name__r.name)); 
               
        }  
        options.sort();
        return options;
    } 
       /*To display AlternatePhoneType values for current logged in volunteer contact in community.*/
      public List<SelectOption> getAlternatePhoneType(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Alternate_Phone_Type__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Select Type')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
     }
       /*To display PreferedPhoneType values for current logged in volunteer contact in community.*/
      public List<SelectOption> getPreferedPhoneType(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Preferred_Phone_Types__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Select Type')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
            
         }  
        return options;
      }    
       /*To display IamOnLinkedIn values for current logged in volunteer contact in community.*/
      public List<SelectOption> getIamOnLinkedIn(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.I_m_on_LinkedIn__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Select')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }   
      /*To display ContactAtWorks values for current logged in volunteer contact in community.*/
     public List<SelectOption> getContactAtWorks(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.May_We_Contact_You_at_Work__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Select')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }   
      /*To display Interested involved with Make wish values for current logged in volunteer contact in community.*/
     public List<SelectOption> getInterstedList(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Contact.Interested_involved_with_Make_A_Wish__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Select')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }   
      /*To display title values for current logged in volunteer contact in community.*/
    public List<SelectOption> getTitles(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select Title')); 
        options.add(new SelectOption('Mr.','Mr.')); 
        options.add(new SelectOption('Mrs.','Mrs.'));
        options.add(new SelectOption('Miss','Miss'));
        options.add(new SelectOption('Master','Master'));
        options.add(new SelectOption('Dr.','Dr.'));
        options.add(new SelectOption('Prof.','Prof.'));
        return options;
    }      
     /*To display Country values for current logged in volunteer contact in community.*/
    public List<SelectOption> getCountries(){
        List<SelectOption> options = new List<SelectOption>();
       
        options.add(new SelectOption('United States','United States'));
        return options;
    } 
   
   // Displaying the Role Description on the Application Page. 
     public void DisplayDescription(){
        displayPopup = true;
        roleDiscriptionList= new List<roleWrapper>();
        for(Chapter_Role__c currRole : [SELECT ID, Role_Name__r.Name,Role_Name__r.Description__c,Role_Name__r.Exclude_from_Application__c 
                                        FROM Chapter_Role__c WHERE Chapter_name__c IN :chaptersNameSet AND Role_Name__r.Exclude_from_Application__c = False 
                                        ORDER BY Role_Name__r.Name])
        {      
               
               roleWrapper wrap = new roleWrapper();
               wrap.roleName = currRole.Role_Name__r.Name;
               wrap.roleDescription = currRole.Role_Name__r.Description__c;
               roleDiscriptionList.add(wrap);
               
        }  
       
    }   
    
    // Closing the Popup message.
    public void ClosePopUp(){
        displayPopup = false;
    } 
    
    // Role Description Wrapper
    
    public class roleWrapper
    {
       public string roleName{get;set;}
       public string roleDescription{get;set;}
    }
      
    public void hidePopup()
    {
      displaySignNowPopup  = false;
    }   
}