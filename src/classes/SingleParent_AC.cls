public class SingleParent_AC{
    
    public Case currentParentCase{get;set;}
    Public Map<Integer,String> parentNameMap = new Map<Integer,String>();
    Public Map<Integer,String> parentEmailMap = new Map<Integer,String>();
    public Integer i;
    public String name{get;set;}
    public SingleParent_AC(ApexPages.StandardController controller){
        name = '';
        currentParentCase = [SELECT Id,ContactId FROM Case WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
        i = 1;
        for(npe4__Relationship__c dbParentRec : [SELECT Id,npe4__Contact__c,npe4__RelatedContact__c,npe4__RelatedContact__r.Name,npe4__RelatedContact__r.Email,npe4__Type__c FROM npe4__Relationship__c WHERE npe4__Contact__c =: currentParentCase.ContactId
                                                  AND (npe4__Type__c = 'Father' OR npe4__Type__c = 'Mother' OR npe4__Type__c = 'Legal Guardian')]){
            if(name == '')
            name = dbParentRec.npe4__RelatedContact__r.Name;
            else
            name = name+','+' '+dbParentRec.npe4__RelatedContact__r.Name;
            if(dbParentRec.npe4__Type__c == 'Father'){
                parentEmailMap.put(i,dbParentRec.npe4__RelatedContact__r.Email);
                parentNameMap.put(i,dbParentRec.npe4__RelatedContact__r.Name);
            }
           else if(dbParentRec.npe4__Type__c == 'Mother'){
                parentEmailMap.put(i,dbParentRec.npe4__RelatedContact__r.Email);
                parentNameMap.put(i,dbParentRec.npe4__RelatedContact__r.Name);
            }
            else{
                parentEmailMap.put(i,dbParentRec.npe4__RelatedContact__r.Email);
                parentNameMap.put(i,dbParentRec.npe4__RelatedContact__r.Name);
            }
            i++;
         }
    }
    
   
    public  void CallouttoDocusign(){
       
         String account;
            String UserName;
            String Password;
            String IntegratorKey;
            String endPointURL;
            String templateID = label.SingleForm;
            system.debug('### templateId #####'+templateID);
            Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
            for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
                UserName = credentialIns.name;
                account = credentialIns.account__c;
                Password = credentialIns.Password__c;
                IntegratorKey  = credentialIns.IntegratorKey__c;
                endPointURL = credentialIns.end_Point__c;
            }
            
            String endpoint = endPointURL+'/accounts/'+account+'/envelopes';
            system.debug('### endpoint #####'+endpoint );
            String authorizationHeader = '<DocuSignCredentials><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
            HttpRequest req = new HttpRequest(); 
            req.setEndpoint(endPoint); 
            req.setMethod('POST'); 
            req.setHeader('X-DocuSign-Authentication', authorizationHeader); 
            req.setHeader('Accept','application/json'); 
            req.setHeader('Content-Length','162100'); 
            req.setHeader('Content-Type','application/json'); 
            req.setHeader('Content-Disposition','form-data'); 
            String recipient = '';
            for(Integer j=1 ;j <= parentNameMap.size() ; j++){
                recipient = recipient + '{'+ 
                '"roleName": "'+'Signer'+j+'",'+ 
                '"name": "'+parentNameMap.get(j)+'",'+ 
                '"email": "'+parentEmailMap.get(j)+'",'+ 
                '"routingOrder": "'+j+'",'+
                '"recipientId": '+j+''+ 
                '}';
                if(j < parentNameMap.size())
                recipient = recipient+',';
                 }
            system.debug('@@@@@@ recipient @@@@@@'+recipient);
            String json='{'+ 
                ' '+ 
                ' "emailSubject": "Single Parent Form",'+
                ' "emailBlurb": "MAKE A WISH AMERICA",'+ 
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
                ' "templateRoles": ['+ recipient+
                ' ],'+ 
                ' "status": "sent"'+ 
                '}'; 
                system.debug('@@@@@@ json @@@@@@'+json);
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
           
        DisplayMessage();
    }
    public pageReference cancel(){
        PageReference reference=new PageReference('/'+currentParentCase.Id);
        reference.setRedirect(true);     
        return reference;
        
    }
    
    public pagereference DisplayMessage(){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'The single parent form has been sent successfully.'));
        return null;
    }
    
    }