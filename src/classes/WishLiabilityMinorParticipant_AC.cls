/*****************************************************************************
Created by: Kanagaraj
Author : MST Solutions
CreateDate : 11/15/2016
Description : WishLiabilityForm_AC is used to send the WishLiability Form for Parent/Guardian of Minor participant  to sign that liability form.
******************************************************************************/

public class WishLiabilityMinorParticipant_AC{
    
    public Case currentParentCase{get;set;}
    public List<Contact> addContactEmailList{get;set;}
    public boolean outPutMode{get;set;}
    public boolean inPutMode{get;set;}
    public Map<String,String> emailMap;
    public List<String> emailStringList{get;set;}
    public String Name{get;set;}
    public boolean displayReturnToWish{get;set;} 

    public WishLiabilityMinorParticipant_AC(ApexPages.StandardController controller){
        inPutMode = true;
        outPutMode = false;
        emailStringList = new List<String>();
        currentParentCase = [SELECT Id,CaseNumber,ContactId,contact.Publicity_OK__c,ChapterName__r.Name,Contact.Hidden_Minor_Participant__c,Contact.Name FROM Case WHERE Id =:  ApexPages.currentPage().getParameters().get('id')];
        if(currentParentCase.Contact.Hidden_Minor_Participant__c != Null){
            for(String processEmail : currentParentCase.Contact.Hidden_Minor_Participant__c.split(',')){
                emailStringList.add(processEmail);
                if(Name == Null)
                    Name = processEmail;
                else
                    Name = Name+','+' '+processEmail;
            }
        }
        addContactEmailList = new List<Contact>();
        addContactEmailList.add(new Contact());
    }
    
    public void AddRow(){
        inPutMode = true;
        outPutMode = false;
        Contact newCon = new Contact();
        addContactEmailList.add(newCon);
    }
    
    public pageReference SaveContact(){
        String conName = '';
        String Email = '';
        for(Contact processCon : addContactEmailList){
            conName = processCon.FirstName;
            Email = processCon.Email;
        }
        if((conName != Null ) && (Email!= Null)){
            outPutMode = true;
            inPutMode = false;
        }
        if((conName == Null ) && (Email == Null ))
            DisplayErrorMessage();
        return null;
    }
    
    public pageReference cancel(){
    system.debug('cancelcalled');
        pageReference pg = new pageReference('/'+currentParentCase.Id);
        pg.setRedirect(true);
        return pg;
    }
    
    public void SendtoEmail(){
        String emailString = ''; 
        emailMap = new Map<String,String>();
        for(Contact processCon : addContactEmailList){
            if(emailMap.containsKey(processCon.FirstName)){
                processCon.FirstName = processCon.FirstName+' ';
                emailMap.put(processCon.FirstName,processCon.Email);
                system.debug('containsName'+processCon.FirstName);
                system.debug('containsEmail'+processCon.Email);
            }
            else    
                emailMap.put(processCon.FirstName,processCon.Email);
            if(emailString == '')
                emailString = processCon.FirstName;
            else
                emailString = emailString +','+processCon.FirstName;
        }
        Contact updateWishChild = new Contact();
        updateWishChild.Id = currentParentCase.ContactId;
        updateWishChild.Hidden_Minor_Participant__c = emailString;
        update updateWishChild;
        if(currentParentCase.contact.Publicity_OK__c != Null){
        callouttoDocusing(emailMap,currentParentCase.Id,currentParentCase.contact.Publicity_OK__c);
        DisplayMessage();
        }
        else{
         DisplayMessage();
        }
        
    }
    
    @Future(callout=true)
    public static void callouttoDocusing(map<String,String>sendEmailMap,Id caseId,String publicity){
        
        List<Contact> relationShipList = new List<Contact>();
        Pagereference PDF;
        if(publicity == 'Yes')
            PDF = Page.WishLiabilityMiniorForm;
        else
            PDF = Page.WishLiabilityMiniorFormOption2;
        String documentPDF;
        PDF.setRedirect(false);
        PDF.getParameters().put('Id',caseId);
        If(!Test.isrunningtest())
            documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
        String recipients = '';
        Integer i = 1;
        String status;
        String boundary = 'AAA';
        String ContactName = '';
        List<contact> contactList = new List<contact>(); 
        List<contact> finalList = new List<contact>();
        String account;
        String UserName;
        String Password;
        String IntegratorKey;
        String endPointURL;
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
            UserName = credentialIns.name;
            account = credentialIns.account__c;
            Password = credentialIns.Password__c;
            IntegratorKey  = credentialIns.IntegratorKey__c;
            endPointURL = credentialIns.end_Point__c;
        }
        
        String endpoint = endPointURL+'/accounts/'+account+'/envelopes';
        String authorizationHeader = '<DocuSignCredentials><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
        String clientUserId = '';
        String email;
        for(String currString : sendEmailMap.KeySet()){
            String Name = currString;
            email = sendEmailMap.get(currString);
            clientUserId = '';
            if(ContactName == '')
                ContactName = Name;
            ContactName = ContactName +','+Name;
            if(recipients != '')
                recipients = recipients + ',';
            recipients = recipients + '{'+
                '      "email": "'+email+'",'+
                '      "name": "'+Name+'",'+
                '      "recipientId":"'+i+'",'+clientUserId+
                '      "tabs": {'+
                '                "signHereTabs": [{'+
                '                     "anchorString":"~s'+i+'",'+
                '                    "anchorXOffset": "0",'+
                '                    "anchorYOffset": "0",'+
                '                    "anchorIgnoreIfNotPresent": "false",'+
                '                    "anchorUnits": "inches"'+
                '                }],'+
                '                    "dateSignedTabs": [{'+
                '                      "anchorString": "~date'+i+'",'+
                '                       "anchorXOffset": "0",'+
                '                       "fontSize":      "Size14",'+
                '                       "fontColor":     "Black",'+
                '                        "anchorYOffset": "0",'+
                '                        "anchorIgnoreIfNotPresent": "false",'+
                '                        "xPosition": "100",'+
                '                         "yPosition": "72",'+
                '                         "anchorUnits": "inches"'+
                '                    }]'+
                '            }'+
                '    }';
            
            i++;
        }
        //forming payload with the document and recipients.
        String body =  '{'+
            '  "status":"sent",'+
            '  "enableWetSign": "false",'+
            '  "emailBlurb":"Please sign the attached Liability And Publicity Release Form – Minor Participants.\r\n\n Thank You,\r\n\nWish & Volunteer Center",'+
            '  "emailSubject": "Signature Required - Liability And Publicity Release Form – Minor Participants",'+
            '  "enforceSignerVisibility":"True",'+
            '  "documents": [{'+
            '      "name": "document.pdf",'+
            '      "documentId":"1",'+
            '      "order":"1",'+
            '      "documentBase64":"'+documentPDF+'"'+
            '  }],'+
            '"recipients": {'+
            '    "signers" : ['+recipients+']'+
            '  }'+
            '}';
        String viewBody = '{'+
            '"returnUrl": "https://www.docusign.com/devcenter"'+
            '}';
        String header = '--'+boundary+'\nContent-Type: application/json\nContent-Disposition: form-data';
        String jsonBody = header +'\n\n'+body+'\n\n--'+boundary+'--';
        
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
        try{
            if(recipients != ''){
                res = http.send(req);
                system.debug(res.getBody());
                //Docusign status record creation.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                
                if((String) results.get('status') == 'Sent'){
                    status = 'Agreement sent to email.';
                    dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                    dsfs.dsfs__DocuSign_Envelope_ID__c = (String) results.get('envelopeId');
                    dsfs.dsfs__Case__c= caseId;
                    Insert dsfs;
                    
                }else
                    status = (String) results.get('errorCode');
            }
        }catch(Exception e){
        }
    }
    
    public void removeContact(){
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        if(addContactEmailList[indexVal - 1].Id != null)
            addContactEmailList.remove(indexVal - 1);            
    } 
    
    public Pagereference preview(){
        Pagereference PDF;
        if(currentParentCase.contact.Publicity_OK__c == 'Yes'){
            PDF = Page.WishLiabilityMiniorForm;
            PDF.setRedirect(false);
            PDF.getParameters().put('Id',currentParentCase.Id);
        }
        if(currentParentCase.contact.Publicity_OK__c == 'No'){
            PDF = Page.WishLiabilityMiniorFormOption2;
            PDF.setRedirect(false);
            PDF.getParameters().put('Id',currentParentCase.Id);
        }
        if(currentParentCase.contact.Publicity_OK__c == Null)
            DisplayMessage();
        return  PDF;
    }  
    
    public pagereference DisplayMessage(){
        if(currentParentCase.contact.Publicity_OK__c == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The publicity liability is not selected'));
            }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'The Email has been successfully Sent.'));
            }
        return null;
    }
    public pagereference DisplayErrorMessage(){
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the name and Email'));
        return null;
    }
    
    public void ReturnToWish(){
        displayReturnToWish = true;
    }
    
      public pageReference ReturnToLiabilityForm(){
        PageReference reference=new PageReference('/apex/WishLiabilityMinorParticipant_VF?id='+currentParentCase.id);
        reference.setRedirect(true);     
        return reference;
    }
}