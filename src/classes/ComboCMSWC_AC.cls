/* This ComboCMSWC_AC class is used to send the wish clearance and child medical summary form.
This form is sent to treating medical contact. This contact is updat information 
about wish child.*/
public class ComboCMSWC_AC{
    
    public Case currentParentCase{get;set;}
    public List<SelectOption> multiPickoptions {get;set;}       
    Public String medicalProfContactName{get;set;}
    Constant_AC  constant = new Constant_AC();
    public Map<String,String> medicalProfConMap; 
    public String email{get;set;}
    public String nameconcat;
    public boolean dis{get;set;}
    public boolean displayReturnToWish{get;set;} 
    Public Id MedicalProfContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
    public ComboCMSWC_AC(ApexPages.StandardController controller){
        dis = true;
        currentParentCase = [SELECT Id,ContactId,Contact.lastname,Contact.firstname,Description,Contact.Hidden_Medical_Physician__c,Rush__c,IsRushWishClearence_ChildSummary__c,wish_involves_air_travel__c,Contact.Hidden_Medical_Physician_Email__c FROM Case WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
        nameconcat=currentParentCase.Contact.firstname+currentParentCase.Contact.lastname;
        
    }
    //This method is used to display the medical professional contact   
    public List<SelectOption> getMedicalProContact(){
        medicalProfConMap = new Map<String,String>();
        List<SelectOption> options = new List<SelectOption>();
        for(npe4__Relationship__c dbRelationShip  : [Select Id,npe4__Contact__c,npe4__RelatedContact__c,npe4__RelatedContact__r.Name,npe4__RelatedContact__r.Email,
                                                     npe4__RelatedContact__r.RecordTypeId FROM npe4__Relationship__c WHERE npe4__Contact__c =:currentParentCase.ContactId AND npe4__RelatedContact__r.RecordTypeId =:MedicalProfContactRecordTypeId]){
                                                         
                                                         options.add(new SelectOption(dbRelationShip.npe4__RelatedContact__r.Name,dbRelationShip.npe4__RelatedContact__r.Name));
                                                         medicalProfConMap.Put(dbRelationShip.npe4__RelatedContact__r.Name,dbRelationShip.npe4__RelatedContact__r.Email); 
                                                     }
        
        return options;
    }
    //This method is uesd to check the conatct email   
    public void displayEmail(){
        if(medicalProfConMap.get(medicalProfContactName) != Null){
            dis = true;
            email = medicalProfConMap.get(medicalProfContactName);
        }
        
    }
    public void ReturnToWish(){
        displayReturnToWish = true;
    }
    //This method is used to return to the same page when click the cancel button on popup message
    public pageReference ReturnToComboCMSWCForm(){
        PageReference reference=new PageReference('/apex/ComboCMSWC?id='+currentParentCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    //This method used to send the from to the contact based on the selection    
    public void SendtoDocuSign(){
        
        if(currentParentCase.wish_involves_air_travel__c == Null ||currentParentCase.Description == Null ){
            DisplayErrorMessage();
        }
        
        else if(medicalProfConMap.get(medicalProfContactName) == Null){
            DisplayErrorMessage();
        }
        else{
            case updatecase = new Case();
            updatecase.Id = currentParentCase.Id;
            updatecase.wish_involves_air_travel__c = currentParentCase.wish_involves_air_travel__c;
            updatecase.Emergency_Number__c = Null;
            updatecase.Appropriate_Comments__c = Null;
            updatecase.Please_Explain__c = Null;
            updatecase.Date_of_last_visit_treatment__c = Null;
            updatecase.Comments__c = Null;
            updatecase.Comment_1__c = Null;
            updatecase.Comment_2__c = Null;
            updatecase.Wish_Clearance_Received_Date__c = Null;
            updatecase.Child_s_Medical_Summary_received_date__c = Null;
            updatecase.Child_s_Medical_Summary_sent__c = system.today();
            updatecase.Wish_Clearance_Sent_Date__c = system.today();
            update updatecase;
            if(!Test.isRunningTest())
                CallouttoDocusign(updateCase.Id,medicalProfContactName,email);
            DisplayMessage();
        }
        // return wrapInst.status;
    }
    
    //This method used to send a collout to the docusign    
    @future(Callout = true)
    public static void CallouttoDocusign(Id caseId,String conName,String conEmail){
        Case currentParentCase = [SELECT Id,ContactId,Contact.Name,Contact.lastname,Contact.firstname,Contact.Hidden_Medical_Physician__c,wish_involves_air_travel__c,Contact.Hidden_Medical_Physician_Email__c,Rush__c  FROM Case WHERE Id =: caseId];
        
        String account;
        String UserName;
        String Password;
        String IntegratorKey;
        String endPointURL;
        String templateID;
        system.debug('### templateId #####'+templateID);
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        String  name = conName;
        String  email = conEmail;
        String  emailbody='Dear Healthcare Professional:'+'\r\n\r\n'+'Your patient has chosen a wish, please help us prepare and keep your patient safe on their wish!'+'\r\n\r\n\t'+
            '     a. Open the attached form'+'\r\n\t'+
            '     b. Fill it out to the best of your knowledge'+'\r\n\t'+
            '     c. Electronic signature'+'\r\n'+
            'If this email needs to be forwarded to the physician, nurse practitioner or physician assistant to sign, you can:'+'\r\n\r\n'+
            
            '1.Reassign it via email to that person by (this will change the signature to the new person, if you enter content into the original document, Docusign will not retain that information for the recipient)'+
            '\r\n\r\n\t'+
            
            '     a. Click the Review Document button above'+'\r\n\t'+
            '     b. Click Other Actions in the blue bar'+'\r\n\t'+
            '     c. Select Assign to Someone Else from the drop down'+'\r\n\t'+
            '     d. Enter the required information (New signer name & email)'+'\r\n\t'+
            '     e. Click Assign to Someone Else'+'\r\n\r\n'+
            
            '2. Print the document, have the appropriate person sign and fax it back (if you enter information into the original document prior to “step b”, Docusign will retain the information and it will be printed on the paper form)'+'\r\n\r\n\t'+
            
            '     a. Click the Review Document button above'+'\r\n\t'+
            '     b. Click Other Actions in blue bar'+'\r\n\t'+
            '     c. Select Print & Sign from drop down'+'\r\n\t'+
            '     d. Select radio button next to Fax'+'\r\n\t'+
            '     e. Click Continue'+'\r\n\t'+
            '     f. Click Download'+'\r\n\t'+
            '     g. Click Finish once form downloads'+'\r\n\t'+
            '     h. Then follow the directions on the cover sheet to fax it back'+'\r\n\r\n'+
            
            'Thanks to the support of you and other medical professionals around the country, we continue to come closer each year to our vision of making every eligible child’s wish come true. Thank you for taking the time to help us share the power of a wish®.'+
            '\r\n\r\n'+
            
            'Thank You,'+'\r\n\r\n'+
            'Make-A-Wish®'; 
        
        
        String subject;
        String lastInitial = currentParentCase.Contact.lastname;
        lastInitial = lastInitial.left(1);
        for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
            UserName = credentialIns.name;
            account = credentialIns.account__c;
            Password = credentialIns.Password__c;
            IntegratorKey  = credentialIns.IntegratorKey__c;
            endPointURL = credentialIns.end_Point__c;
        }
        
        if(currentParentCase.Rush__c  != true){
            templateID = label.Combo_CMS_and_WC;
            subject = 'Signature Required – Make-A-Wish Wish Clearance and Child'+'\'s'+' '+'Medical Summary Form: '+currentParentCase.Contact.firstname +' '+lastInitial+'.';
        }
        
        if(currentParentCase.Rush__c  == true){
            templateID = label.Combo_CMS_and_WC;
            subject = 'Signature Required – Make-A-Wish Rush Wish Clearance and Child'+'\'s'+' '+ 'Medical Summary Form: '+currentParentCase.Contact.firstname +' '+lastInitial+'.';
        }
        String endpoint = endPointURL+'/accounts/'+account+'/envelopes';
        system.debug('### endpoint #####'+endpoint );
        system.debug('### lastInitial  #####'+lastInitial );
        String authorizationHeader = '<DocuSignCredentials><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(endPoint); 
        req.setMethod('POST'); 
        req.setHeader('X-DocuSign-Authentication', authorizationHeader); 
        req.setHeader('Accept','application/json'); 
        req.setHeader('Content-Length','162100'); 
        req.setHeader('Content-Type','application/json'); 
        req.setHeader('Content-Disposition','form-data'); 
        String json='{'+ 
            ' '+ 
            ' "emailSubject": "'+subject+'",'+
            ' "emailBlurb": "Signature Required - Combo Document: CMS and WC",'+ 
            ' "templateId": "'+templateID+'",'+ 
            ' "envelopeIdStamping": "false",'+ 
            ' "customFields":{'+
            '    "textCustomFields":['+
            '      {'+
            '        "name":"##SFCase",'+
            '        "required":"true",'+
            '        "show":"false",'+
            '        "value":"'+currentParentCase.Id+'"'+
            '      }'+
            '    ]'+
            '  },'+
            ' "templateRoles": ['+ 
            '{'+ 
            '"roleName": "Signer 1",'+ 
            '"name": "'+name+'",'+ 
            '"email": "'+email+'",'+
            '"emailNotification": {'+
            '"emailSubject": "'+subject+'",'+
            '"emailBody": "'+emailbody+'",'+
            '"supportedLanguage": "en"'+
            '},'+
            '},'+ 
            
            ' ],'+ 
            ' "status": "sent"'+ 
            '}'; 
        req.setBody(json); 
        Http http = new Http(); 
        HTTPResponse res; 
        try{ 
            
            res = http.send(req); 
            system.debug('DocuSign Response'+ res.getBody()); 
        } 
        catch(Exception e){ 
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage())); 
        } 
        WrapperDocuSign wrapInst = WrapperDocuSign.parse(res.getBody()); 
        
        
    }
    public pageReference cancel(){
        PageReference reference=new PageReference('/'+currentParentCase.Id);
        reference.setRedirect(true);     
        return reference;
        
    }
    
    public pagereference DisplayMessage(){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Child Medical Summary and Wish Clearance form have been sent successfully.'));
        return null;
    }
    //This method used to display the error message   
    public pagereference DisplayErrorMessage(){
        if(currentParentCase.wish_involves_air_travel__c == Null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select Wish Involves Air Travel'));
        if(currentParentCase.Description == Null )
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please add a value to Description on the case page.'));
        if(medicalProfConMap.get(medicalProfContactName) == Null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The selected user does not have email address.'));
        return null;
    }
}