/*****************************************************************************
Created by: Vennila Paramasivam
Author : MST Solutions
CreateDate : 06/01/2016
Description : Creating Wish Child Details from Wish Determination Case detail page.
******************************************************************************/

public Class WishChildForm_AC{
    public Contact currWishChildContact{get;set;}
    public WishChildFormUtil wcfUtil{get;set;}
    public Case currCase{get;set;}
    public Wish_Child_Form__c currWishChild{get;set;}
    public Id currentPageId;
    public Boolean isChildPart = false;
    public Boolean isParticipants {get;set;}
    public string queryString {get;set;}   
    public Map<string,string> wrapperClsMap {get;set;}  
    public Map<id,Wish_Child_Form__c> clonedMap{get;set;}
    public Map<id,Wish_Child_Form__c> objMap{get;set;}
    public List<String> ethnicityList{get;set;}
    Public boolean isSignNowPopup{get;set;}
    public boolean firstSign{get;set;}
    public boolean secondSign{get;set;}
    public List<String> currentWCNamesList{get;set;}
    public String currentWCName{get;set;}
    public List<string> tempName = new List<string>();
    public List<String>currentOwnWheelChairList =new List<String>();
    Public List<String>currentWCCollapsibleList = new List<String>();
    Public List<String>currentWCPowerList = new List<String>();
    Public List<String>currentOxygenNamesList = new List<String>();
    Public List<String>currrentDietaryNameList = new List<String>();
    Public List<String>currentNursingCareList = new List<String>();
    Public List<String>currentMedicationList = new List<String>();
    Public List<String>currentAllergyNamesList = new List<String>();
    Public List<String>currentOtherNeedsList = new List<String>();
    public String tshirt{get;set;}
    public boolean isWishchildFormRequired{get;set;}
    public boolean isWishfamilyFormRequired{get;set;}
    public Integer j = 0;
    public Integer k = 0;
    Constant_AC  constant = new Constant_AC();
    Public Id familyContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
    Public Id wichChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
    Public String driverInfo = '';
    public Set<String> relationShipSet = new Set<String>();
    public WishChildForm_AC(Apexpages.StandardController controller){
        currentPageId =  ApexPages.currentPage().getParameters().get('id');
        isChildPart = false ;
        isParticipants  = false;    
        if(wcfUtil == null)   
            wcfUtil = new WishChildFormUtil();
        ethnicityList = new List<String>();
        //tempName = new List<String>();
        currentPageId =  ApexPages.currentPage().getParameters().get('id');
        if(currentPageId != null){
            List<ProcessInstanceWorkitem> approvalIns = [SELECT Id,ActorId,OriginalActorId,ProcessInstanceId,ProcessInstance.TargetObjectId,ProcessInstance.Status,ProcessInstance.ProcessDefinition.Name FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: currentPageId AND ProcessInstance.Status =: 'Pending' AND ProcessInstance.ProcessDefinition.Name =: 'Wish Paperwork Packet'
                                                         AND (ActorId !=: UserInfo.getUserId() AND OriginalActorId !=: UserInfo.getUserId())];
            
            this.currCase = (Case)controller.getRecord();
            currWishChild = new Wish_Child_Form__c();  
            this.currCase = [SELECT id,Hidden_Email_List__c,ContactId,Contact.FirstName,Contact.LastName, Contact.Middle_Name__c,
                             Contact.Diagnosis__c , Contact.Email, Contact.MobilePhone, Contact.Gender__C,
                             Contact.BirthDate, Contact.T_Shirt_Size__c, Contact.MailingStreet,
                             Contact.MailingCity, Contact.MailingState, Contact.MailingPostalCode
                             FROM Case WHERE Id = :this.currCase.id limit 1];
            List<CaseTeamMember> caseTeamMemberList = [SELECT id,Member.Name FROM CaseTeamMember WHERE ParentId =: this.currCase.id AND TeamRole.Name = 'Wish Granter' limit 2];
            if(caseTeamMemberList.size() > 0){
                wcfUtil.caseTeamMemberNo1 = caseTeamMemberList[0].Member.Name;
                if(caseTeamMemberList.size() > 1)
                    wcfUtil.caseTeamMemberNo2 = caseTeamMemberList[1].Member.Name;
            }
            //build wish child list
            if(this.currCase.Id != null){
                String caseId = this.currCase.id;
                String wishChildQuery = 'SELECT ';
                for(Schema.FieldSetMember f : wcfUtil.getWishChildFields()) {
                    wishChildQuery+= f.getFieldPath() + ', ';
                }
                wishChildQuery = WishchildQuery.removeEnd(', ');
                wishChildQuery+= ' from Wish_Child_Form__c' + ' WHERE Case__c = :'+'caseId'+ ' lIMIT 1';
                wcfUtil.wishChildList = Database.Query(wishChildQuery);
            }  
            //Build wishChild for SignNow List
            for(Wish_Child_Form__c wishChildForm : [SELECT Id,Name,Case__c,Hidden_Same_as_Family__c,T_Shirt_Size__c,Race_Ethnicity__c,Signers__c,Hidden_Contact_Name__c,Hidden_Wish_Fmaily_Contact_Email__c,Hidden_Wish_Fmaily_Contact_Name__c FROM Wish_Child_Form__c WHERE
                                                    Case__c =: currentPageId]){
                                                        if(wishChildForm.Hidden_Wish_Fmaily_Contact_Name__c != null) {  
                                                            for(String keys : wishChildForm.Hidden_Wish_Fmaily_Contact_Name__c.split('#')){
                                                                wcfUtil.SignNowList.add(keys.trim());                     
                                                                wcfUtil.listofSenderName.add(keys.trim());
                                                            }  
                                                        }
                                                        //setting same as family from table
                                                        if( wishChildForm.Hidden_Same_as_Family__c ){
                                                            wcfUtil.sameParentGuardian = true;
                                                        }else{
                                                            wcfUtil.sameParentGuardian = false;
                                                        }
                                                        if(wishChildForm.Race_Ethnicity__c != Null){
                                                            for(String mwa: wishChildForm.Race_Ethnicity__c .split(';'))
                                                            {
                                                                ethnicityList.add(mwa);
                                                            }
                                                        }
                                                        tshirt = wishChildForm.T_Shirt_Size__c;
                                                    }
            system.debug('wishchildlistsizeoutsideif=0'+wcfUtil.wishChildList.size());
            if(wcfUtil.wishChildList.size() == 0){ 
                system.debug('wishchildlistsizeinsideif=0');         
                init(); 
            }
            else{
                currWishChild = wcfUtil.wishChildList[0]; 
                if(currWishChild.Case_Team_Member1__c != null)
                    wcfUtil.caseTeamMemberNo1 =  currWishChild.Case_Team_Member1__c;
                if(currWishChild.Case_Team_Member2__c != null)
                    wcfUtil.caseTeamMemberNo2 = currWishChild.Case_Team_Member2__c;  
                // Wish Family Parser--------------------------------------------- 
                if(currWishChild.Wish_Family_Contact__c != null){
                    String jsonString = currWishChild.Wish_Family_Contact__c;
                    JsonString = jsonString.replace('&quot;', '"');
                    List<WishChildFormUtil.WrapperClass> wrapFamilyList = (List<WishChildFormUtil.WrapperClass>) System.JSON.deserialize(jsonString, List<WishChildFormUtil.WrapperClass>.class);
                    for(WishChildFormUtil.WrapperClass  currRec : wrapFamilyList){
                        WishChildFormUtil.WrapperClass wrapCls;
                        if(wrapCls == null ){ 
                            wrapCls = new WishChildFormUtil.WrapperClass();
                        }
                        System.debug(wrapCls.sameParentGuardianFlag);
                        wrapCls.FirstName = (currRec.FirstName!=Null)?currRec.FirstName.trim():'';
                        wrapCls.MiddleName = (currRec.MiddleName!=Null)?currRec.MiddleName.trim():'';
                        wrapCls.lastName = (currRec.lastName!=Null)?currRec.lastName.trim():'';
                        wrapCls.Relationship = (currRec.Relationship!=Null)?currRec.Relationship:'';
                        wrapCls.homeTelephone =  (currRec.homeTelephone!=Null)?currRec.homeTelephone:'';
                        wrapCls.workTelephone =  (currRec.workTelephone!=Null)?currRec.workTelephone:'';
                        wrapCls.mobileTelephone = (currRec.mobileTelephone!=Null)?currRec.mobileTelephone:'';
                        wrapCls.Email =  (currRec.Email!=Null)?currRec.Email:'';
                        wrapCls.City = (currRec.City!=Null)?currRec.City:'';
                        wrapCls.Street= (currRec.Street!=Null)?currRec.Street:'';
                        wrapCls.State= (currRec.State!=Null)?currRec.State:'';
                        wrapCls.PostalCode= (currRec.PostalCode!=Null)?currRec.PostalCode:'';
                        wrapCls.sameParentGuardianFlag = false;                         
                        wcfUtil.emailMap.put((wrapCls.FirstName+' '+wrapCls.LastName),wrapCls.Email);
                        wrapCls.dob=  (currRec.dob);
                        wrapCls.relId = currRec.relId;
                        wcfUtil.wishFamilyWrapList.add(wrapCls);
                    }
                }
                if(currWishChild.Driver_Details__c != null){
                    Integer i = 0;
                    String jsonString = currWishChild.Driver_Details__c;
                    JsonString = jsonString.replace('&quot;', '"');
                    List<WishChildFormUtil.DriverWrapper> wrapDriverList = (List<WishChildFormUtil.DriverWrapper>) System.JSON.deserialize(jsonString, List<WishChildFormUtil.DriverWrapper>.class);
                    System.debug('WishChildFormUtil.wrapDriverList: '+wrapDriverList);
                    for(WishChildFormUtil.DriverWrapper currRec : wrapDriverList){
                        WishChildFormUtil.DriverWrapper wrapCls = new WishChildFormUtil.DriverWrapper();
                        wrapCls.driverName  = (currRec.driverName!=Null)?currRec.driverName :'';
                        wrapCls.licenseNum  = (currRec.licenseNum !=Null)?currRec.licenseNum :'';
                        wrapCls.state  = (currRec.state !=Null)?currRec.state :'';
                        wrapCls.expirationDate  = (currRec.expirationDate!=Null)?Date.valueOf(currRec.expirationDate):Null;
                        wrapCls.type =  (currRec.type!=Null)?currRec.type:'';
                        if(driverInfo == '' && i == 0){
                            system.debug('@@@@@ wrapCls.expirationDate @@@@@@@@@'+wrapCls.expirationDate);
                            if(string.valueof(wrapCls.expirationDate) != null ){
                                String S = String.valueof(wrapCls.expirationDate);
                                String s1 = S.remove(' 00:00:00');
                                driverInfo = wrapCls.driverName+' '+'|'+' '+wrapCls.licenseNum+' '+'|'+' '+wrapCls.state +' '+'|'+' '+ s1 +' '+'|'+' '+wrapCls.type;      
                            }
                        } 
                        if(driverInfo != '' && i > 0){
                            if(string.valueof(wrapCls.expirationDate) != null){
                                String S = String.valueof(wrapCls.expirationDate);
                                String s1 = S.remove(' 00:00:00');
                                driverInfo +=  '<br/>'+wrapCls.driverName+' '+'|'+' '+wrapCls.licenseNum+' '+'|'+' '+wrapCls.state +' '+'|'+' '+s1+' '+'|'+' '+wrapCls.type;      
                            }
                        }
                        i++;
                        wcfUtil.driverWrapperCls.add(wrapCls);
                    }
                }
                if(currWishChild.Availability_Time_Period_1__c != null){
                    List<String> currString =  (currWishChild.Availability_Time_Period_1__c).split('/');
                    if(currString.size() > 0)
                        wcfUtil.availableMonth1 = currString[0];
                    if(CurrString.size() > 1)
                        wcfUtil.availableYear1 = currString[1];
                }
                if( currWishChild.Availability_Time_Period_2__c != null){
                    List<String> currString =  (currWishChild.Availability_Time_Period_2__c).split('/');
                    if(currString.size() > 0)
                        wcfUtil.availableMonth2 = currString[0];
                    if(CurrString.size() > 1)
                        wcfUtil.availableYear2 = currString[1];
                }
                if( currWishChild.Availability_Time_Period_3__c != null){
                    List<String> currString =  (currWishChild.Availability_Time_Period_3__c).split('/');
                    if(currString.size() > 0)
                        wcfUtil.availableMonth3 = currString[0];
                    if(CurrString.size() > 1)
                        wcfUtil.availableYear3 = currString[1];
                }  
                if(currWishChild.Participant_Name_for_Dietary_Restriction__c!= null){
                    String name = '';
                    for(String s : (currWishChild.Participant_Name_for_Dietary_Restriction__c).split(';')){
                        if(name == '')
                            name = s;
                        else
                            name+=','+' '+s;
                    }
                    name =  name.removeEnd(';');
                    wcfUtil.righttDietaryNameList.add(name);
                    wcfUtil.currrentDietaryName = name;
                    wcfUtil.dietaryNamesSet.add(name);
                }
                if(currWishChild.Requested_Participant_Name_for_OtherNeed__c!= null){
                    String name = '';
                    for(String s : (currWishChild.Requested_Participant_Name_for_OtherNeed__c).split(';')){
                        if(name == '')
                            name = s;
                        else
                            name+=','+' '+s;
                    }
                    name =  name.removeEnd(';');
                    wcfUtil.righttOtherNeedsList.add(name);
                    wcfUtil.currentOtherNeeds = name;
                    wcfUtil.OtherNeedsSet.add(name);
                }
                if(currWishChild.Requested_Participant_Name_for_Oxygen__c!= null){
                    String name = '';
                    for(String s : (currWishChild.Requested_Participant_Name_for_Oxygen__c).split(';')){
                        if(name == '')
                            name = s;
                        else
                            name+=','+' '+s;
                    }      
                    name =  name.removeEnd(';');
                    wcfUtil.rightOxygenNamesList.add(name);
                    wcfUtil.currentOxygenNames = name;
                    wcfUtil.OxygenNamesSet.add(name) ;           
                }
                if(currWishChild.Requested_Participant_Name_for_Allergies__c!= Null){
                    String name = '';
                    for(String s : (currWishChild.Requested_Participant_Name_for_Allergies__c).split(';')){
                        if(name == '')
                            name = s;
                        else
                            name+=','+' '+s;
                    }     
                    name =  name.removeEnd(';');
                    wcfUtil.rightAllergyNamesList.add(name);
                    wcfUtil.currentAllergyNames = name;
                    wcfUtil.AllergyNamesSet.add(name);             
                }                  
                if(currWishChild.Bringing_Own_Wheel_Chair__c!= Null){
                    string name = '';
                    for(String s : (currWishChild.Bringing_Own_Wheel_Chair__c).split(';')){
                        if(name == '')
                            name = s;
                        else
                            name+=','+' '+s;
                    }         
                    name =  name.removeEnd(';');
                    wcfUtil.rightOwnWheelChairList.add(name);
                    wcfUtil.currentOwnWheelChair = name;
                    wcfUtil.ownWheelChairNamesSet.add(name);         
                }                 
                if(currWishChild.Name_of_wheelchair_collapsible__c!= Null){
                    string name = '';
                    for(String s : (currWishChild.Name_of_wheelchair_collapsible__c).split(';')){
                        if(name == '')
                            name = s;
                        else
                            name+=','+' '+s;
                    }        
                    name =  name.removeEnd(';');
                    wcfUtil.rightWCCollapsibleList.add(name);
                    wcfUtil.currentWCCollapsible = name;
                    wcfUtil.WCCollapsiblesSet.add(name);          
                }
                if(currWishChild.Pariticipant_name_havingWheelchair_Power__c!= Null){
                    string name = '';
                    for(String s : (currWishChild.Pariticipant_name_havingWheelchair_Power__c).split(';')){
                        if(name == '')
                            name = s;
                        else
                            name+=','+' '+s;
                    }    
                    name =  name.removeEnd(';');
                    wcfUtil.rightWCPowerList.add(name);
                    wcfUtil.currentWCPower = name;
                    wcfUtil.WCPowerNamesSet.add(name);              
                }
                if(currWishChild.Medication_require_refrigeration_name__c!= Null) {
                    string name = '';
                    for(String s : (currWishChild.Medication_require_refrigeration_name__c).split(';')){
                        if(name == '')
                            name = s;
                        else
                            name+=','+' '+s;
                    }          
                    name =  name.removeEnd(';');
                    wcfUtil.rightMedicationList.add(name);
                    wcfUtil.currentMedication = name ;
                    wcfUtil.MedicationNamesSet.add(name);        
                }
                if(currWishChild.Names_for_receiving_nursing_care__c!= Null){
                    string name = '';
                    for(String s : (currWishChild.Names_for_receiving_nursing_care__c).split(';')){
                        if(name == '')
                            name = s;
                        else
                            name+=','+' '+s;
                    }           
                    name =  name.removeEnd(';');
                    wcfUtil.rightNursingCareList.add(name);
                    wcfUtil.currentNursingCare = name;
                    wcfUtil.nursingCaresSet.add(name);       
                }
                // Wish Participants Parser---------------------------------------------  
                if(currWishChild.Participant_Contacts__c != null){  
                    String jsonString = currWishChild.Participant_Contacts__c;
                    JsonString = jsonString.replace('&quot;', '"');
                    List<WishChildFormUtil.WrapperClass> wrapParticipantsList = (List<WishChildFormUtil.WrapperClass>) System.JSON.deserialize(jsonString, List<WishChildFormUtil.WrapperClass>.class);
                    List<Case> childAsPartList = [SELECT Contact.FirstName,Contact.LastName,Contact.Middle_Name__c,Contact.Email, Contact.MobilePhone,Contact.BirthDate, Contact.T_Shirt_Size__c FROM Case WHERE Id =: this.currCase.id limit 1 ] ;        
                    Integer count = 0;
                    system.debug('count'+count);
                    for( Case childCase : childAsPartList){    
                        isChildPart = true;
                        WishChildFormUtil.WrapperClass childParticipantsWrap;
                        if(childParticipantsWrap == null){
                            childParticipantsWrap  = new WishChildFormUtil.WrapperClass();
                        }
                        childParticipantsWrap.firstName = childCase.Contact.FirstName.trim();
                        childParticipantsWrap.LastName = childCase.Contact.LastName.trim();
                        childParticipantsWrap.MiddleName = childCase.Contact.Middle_Name__c;               
                        childParticipantsWrap.Email = childCase.Contact.Email;  
                        if(childParticipantsWrap.Email == Null)
                            childParticipantsWrap.Email = currWishChild.Email__c;
                        childParticipantsWrap.dob = childCase.Contact.BirthDate;  
                        childParticipantsWrap.tshirtSize = currWishChild.T_Shirt_Size__c; 
                        childParticipantsWrap.isChildParticipants = isChildPart ; 
                        childParticipantsWrap.sameParentGuardianFlag = false;
                        childParticipantsWrap.Relationship = 'Self';
                        wrapParticipantsList.add(childParticipantsWrap);     
                        System.debug('New childParticipantsWrap');
                        if(count != 1 && wrapParticipantsList.get(wrapParticipantsList.size() - 1).FirstName == childCase.Contact.FirstName 
                           && wrapParticipantsList.get(wrapParticipantsList.size() - 1).LastName == childCase.Contact.LastName 
                           && wrapParticipantsList.get(wrapParticipantsList.size() - 1).MiddleName == childCase.Contact.Middle_Name__c 
                           && wrapParticipantsList.get(wrapParticipantsList.size() - 1).Email == childCase.Contact.Email 
                           && wrapParticipantsList.get(wrapParticipantsList.size() - 1).dob == childCase.Contact.BirthDate)
                        {  
                            wrapParticipantsList.remove(wrapParticipantsList.size() - 1);   
                        }
                        count = count + 1;
                    }              
                    ParticipantsMapping(wrapParticipantsList,false);  
                }                 
            }
            if(wcfUtil.wishFamilyWrapList.size() == 0)
                wcfUtil.wishFamilyWrapList.add(new WishChildFormUtil.WrapperClass());
            if(wcfUtil.wishParticipantList.size() == 0)           
                wcfUtil.wishParticipantList.add(new WishChildFormUtil.WrapperClass()); 
            if(wcfUtil.driverWrapperCls.size() == 0)
                wcfUtil.driverWrapperCls.add(new WishChildFormUtil.DriverWrapper());  
            If(approvalIns.size() > 0){           
                wcfUtil.approvalError = true;
            }
            if(currWishChild.FirstName__c == Null || currWishChild.LastName__c == Null || currWishChild.BirthDate__c == Null || currWishChild.Gender__c == Null || 
               currWishChild.T_Shirt_Size__c == Null || currWishChild.Street__c ==  Null || currWishChild.City__c == Null || currWishChild.State__c == Null ||
               currWishChild.Zip_Code__c ==  Null){
                   isWishchildFormRequired = true;
               }
            if(currWishChild.Emergency_Relationship__c == Null || currWishChild.Emergency_First_Name__c == Null || currWishChild.Emergency_Last_Name__c == Null || currWishChild.Emergency_Mobilephone__c == Null || currWishChild.Wish_Family_Contact__c == Null  
               || currWishChild.Participant_Contacts__c == Null || currWishChild.Already_wish_granted_by_MAW_Other_Org__c == Null || currWishChild.IsWishFamily__c == true || currWishChild.IsParticipant__c == true){
                   isWishfamilyFormRequired = true;
               }
            if(currWishChild.Hidden_Contact_Name__c != Null && currWishChild.Hidden_Wish_Fmaily_Contact_Name__c != Null){
                Set<String> nameset = new Set<String>();
                Set<String> namesetOne = new Set<String>();
                for(String processName : currWishChild.Hidden_Contact_Name__c .split('#')){
                    nameset.add(processName);
                }
                system.debug('### SIZE ###'+nameset);
                for(String processName : currWishChild.Hidden_Wish_Fmaily_Contact_Name__c.split('#')){
                    namesetOne.add(processName);
                }
                system.debug('### SIZE ###'+namesetOne);
                if(nameset.size() == namesetOne.size())
                    wcfUtil.displayError = true;
            }
        }      
    }
    
    public void init(){
        system.debug('init method called');
        currWishChild.FirstName__c =  currCase.Contact.FirstName;
        currWishChild.LastName__c  =  currCase.Contact.LastName;
        currWishChild.Middle_Name__c =  CurrCase.Contact.Middle_Name__c;
        currWishChild.BirthDate__c = currCase.Contact.BirthDate;
        currWishChild.Diagnosis__c = currCase.Contact.Diagnosis__c;
        currWishChild.Gender__c = currCase.Contact.Gender__c;
        currWishChild.mobilePhone__c = currCase.Contact.MobilePhone;
        currWishChild.Email__c = currCase.Contact.Email;
        if(currWishChild.Email__c == Null)
            currWishChild.Email__c = currWishChild.Email__c;
        currWishChild.T_Shirt_Size__c = currWishChild.T_Shirt_Size__c;
        currWishChild.Street__c = currCase.Contact.MailingStreet;
        currWishChild.State__c = currCase.Contact.MailingState;
        currWishChild.city__c = currCase.Contact.MailingCity;
        currWishChild.Zip_code__c = currCase.Contact.MailingPostalCode;
        currWishChild.Bringing_Own_Wheel_Chair__c = currWishChild.Bringing_Own_Wheel_Chair__c;
        for(npe4__Relationship__c currRel : [SELECT id,npe4__RelatedContact__c,npe4__RelatedContact__r.FirstName, npe4__RelatedContact__r.LastName,
                                             npe4__RelatedContact__r.Email,Hidden_isparentFirst__c,npe4__RelatedContact__r.Phone, npe4__RelatedContact__r.Middle_Name__c,npe4__RelatedContact__r.Mailingcity,npe4__RelatedContact__r.Mailingstreet,
                                             npe4__RelatedContact__r.MailingState,npe4__RelatedContact__r.MailingPostalCode,npe4__Type__c FROM npe4__Relationship__c WHERE npe4__Contact__c  = :currCase.ContactId AND npe4__RelatedContact__r.RecordTypeId =: familyContactRecordTypeId
                                             AND Hidden_isparentFirst__c = true])
        {
                WishChildFormUtil.WrapperClass wrapCls = new WishChildFormUtil.WrapperClass();
                wrapCls.FirstName = currRel.npe4__RelatedContact__r.FirstName;
                wrapCls.MiddleName = currRel.npe4__RelatedContact__r.Middle_Name__c;
                wrapCls.lastName = currRel.npe4__RelatedContact__r.LastName;
                wrapCls.mobileTelephone = currRel.npe4__RelatedContact__r.Phone;
                wrapCls.Email =  currRel.npe4__RelatedContact__r.Email;
                wrapCls.City = currRel.npe4__RelatedContact__r.Mailingcity; 
                wrapCls.Street = currRel.npe4__RelatedContact__r.MailingStreet;
                wrapCls.State = currRel.npe4__RelatedContact__r.MailingState;
                wrapCls.PostalCode = currRel.npe4__RelatedContact__r.MailingPostalCode;
                wrapCls.Relationship = currRel.npe4__Type__c;
                wrapCls.homeTelephone =  null;
                wrapCls.workTelephone =  null;
                wrapCls.sameParentGuardianFlag = false;
                wrapCls.relId = currRel.npe4__RelatedContact__c;
                wcfUtil.wishFamilyWrapList.add(wrapCls); 
        }   
        if(wcfUtil.wishFamilyWrapList.size() > 0){
            String JSONString = JSON.serialize(wcfUtil.wishFamilyWrapList);
            currWishChild.Wish_Family_Contact__c = JSONString;  
        }              
        List<WishChildFormUtil.WrapperClass> wrapParticipantsList = new  List<WishChildFormUtil.WrapperClass>();
        List<Case> childAsPartList = new List<Case>();
        childAsPartList = [SELECT Contact.FirstName,Contact.LastName,Contact.Middle_Name__c,Contact.Email, Contact.MobilePhone,Contact.BirthDate,Contact.RecordTypeId, Contact.T_Shirt_Size__c FROM Case WHERE Id = :currCase.id AND Contact.RecordTypeId =: wichChildRecordTypeId Limit 1] ;        
        Integer count = 0;
        system.debug('countfirst'+count);
        system.debug('childAsPartList'+childAsPartList.size());
        for( Case childCase:childAsPartList){
            if(count == 0){
                system.debug('countfirst'+count);
                isChildPart = true;
                WishChildFormUtil.WrapperClass childParticipantsWrap = new WishChildFormUtil.WrapperClass();
                childParticipantsWrap.firstName = childCase.Contact.FirstName.trim();
                childParticipantsWrap.LastName = childCase.Contact.LastName.trim();
                childParticipantsWrap.MiddleName = childCase.Contact.Middle_Name__c;               
                childParticipantsWrap.Email = childCase.Contact.Email;   
                childParticipantsWrap.dob = childCase.Contact.BirthDate;   
                childParticipantsWrap.tshirtSize = tshirt;
                System.debug('###### Tshirt 2 #######'+childParticipantsWrap.tshirtSize) ;
                childParticipantsWrap.isChildParticipants = isChildPart ;
                childParticipantsWrap.sameParentGuardianFlag = false;
                childParticipantsWrap.Relationship = 'Self';
                System.debug('isChildPart 4'+isChildPart);
                wrapParticipantsList.add(childParticipantsWrap);
            }
            count++;
            system.debug('countincrement'+count);
        }
        if(wrapParticipantsList.size() > 0)   
        {
            ParticipantsMapping(wrapParticipantsList,false);
            isParticipants = true;
        }
    }
    //This method is used to save the contact information
    public void SaveContact(){
        currWishChild.Case__c = currCase.id;
        Constant_AC  constant = new Constant_Ac(); 
        Set<String> nameset = new Set<String>();   
        Set<String> namesetOne = new Set<String>();   
        List<Wish_Child_Form__c> wishchildList = [Select Id,Case__c,CreatedDate From Wish_Child_Form__c Where case__c =:currCase.id ORDER BY CreatedDate ASC Limit 1];
        
        Id wishDeterminationId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        List<Case> currWishDeterminationCaseId = [SELECT ID FROM CASE WHERE  ParentId = :currWishChild.Case__c AND RecordTypeId = :wishDeterminationId];
        
        if(currWishDeterminationCaseId.size() > 0)
            currWishChild.Wish_Determination_Case_Id__c = currWishDeterminationCaseId[0].id;
        
        try{
            System.debug('wcfUtil.wishFamilyWrapList - '+wcfUtil.wishFamilyWrapList);
            System.debug('@@@@@@@@@ Size - '+wcfUtil.wishFamilyWrapList.size());
            if(wcfUtil.wishFamilyWrapList.size() > 0){
            System.debug('@@@@@@@@@ Size 12- '+wcfUtil.wishFamilyWrapList.size());
                String FamilyContactEmail = '';
                String FamilyContactName = '';
                String RelatedContact = '';
                boolean isFamily = false;
                if(currWishChild.Wish_Family_Contact__c == Null)
                    currWishChild.Wish_Family_Contact__c = '';
                String JSONString = JSON.serialize(wcfUtil.wishFamilyWrapList);
                currWishChild.Wish_Family_Contact__c = JSONString;
                 system.debug('@@@@ IsFamily 3333 @@@@'+isFamily);
                for(WishChildFormUtil.WrapperClass currRec : wcfUtil.wishFamilyWrapList){
                 system.debug('@@@@ IsFamily 33445 @@@@'+isFamily);
                  if(String.isEmpty(currRec.FirstName) || String.isEmpty(currRec.LastName) || String.isEmpty(currRec.Email) ||  String.isEmpty(currRec.Relationship)|| String.isEmpty(currRec.City)|| String.isEmpty(currRec.Street)|| String.isEmpty(currRec.State) || 
                    String.isEmpty(currRec.PostalCode)|| currRec.dob == null|| (String.isEmpty(currRec.homeTelephone)  && String.isEmpty(currRec.workTelephone) && String.isEmpty(currRec.mobileTelephone)))
                    {  
                        isFamily = true;
                        system.debug('@@@@ IsFamily @@@@'+isFamily);
                    }
                   
                    if(currRec.FirstName != Null && currRec.LastName != Null && currRec.LastName!= Null){
                        String name = currRec.FirstName+'-'+currRec.LastName+'-'+currRec.Email;
                        String nameone = currRec.FirstName+'-'+currRec.LastName;
                        namesetOne.add(nameone); 
                        nameset.add(name);
                        if(FamilyContactEmail != Null && FamilyContactEmail != '' && FamilyContactName != Null && FamilyContactName != ''){
                            if(currRec.dob != Null){
                                Date dt = Date.Valueof(currRec.dob);
                                Integer days = dt.daysBetween(Date.Today());
                                Integer age = Integer.valueOf(days/365);
                                if(age >=  18){
                                    FamilyContactEmail +='#'+currRec.FirstName.trim()+' '+currRec.LastName.trim()+'-'+currRec.Email;
                                }
                            }
                        }
                        else{
                            if(currRec.dob != Null){
                                Date dt = Date.Valueof(currRec.dob);
                                Integer days = dt.daysBetween(Date.Today());
                                Integer age = Integer.valueOf(days/365);
                                if(age >=  18){
                                    FamilyContactEmail = currRec.FirstName.trim()+' '+currRec.LastName.trim()+'-'+currRec.Email;
                                }
                            }
                         }
                        if(FamilyContactName != Null && FamilyContactName != ''){
                            if(currRec.dob != Null){
                                Date dt = Date.Valueof(currRec.dob);
                                Integer days = dt.daysBetween(Date.Today());
                                Integer age = Integer.valueOf(days/365);
                                if(age >=  18){
                                    FamilyContactName = FamilyContactName+'#'+ currRec.FirstName.trim()+' '+currRec.LastName.trim();
                                }
                            }
                        }
                        else{
                            if(currRec.dob != Null){
                                Date dt = Date.Valueof(currRec.dob);
                                Integer days = dt.daysBetween(Date.Today());
                                Integer age = Integer.valueOf(days/365);
                                if(age >=  18){
                                    FamilyContactName = currRec.FirstName.trim()+' '+currRec.LastName.trim();
                                }
                            }
                        }
                        if(RelatedContact != Null && RelatedContact != '' ){
                            if(currRec.Relationship != 'Other')
                                RelatedContact =  RelatedContact+','+' '+ currRec.FirstName.trim()+' '+currRec.LastName.trim();
                        }
                        else{
                            if(currRec.Relationship != 'Other')
                                RelatedContact = currRec.FirstName.trim()+' '+currRec.LastName.trim();
                        }
                    }
                } 
                
                if(isFamily == false){
                    isFamily = false;
                }                    
                currWishChild.Hidden_Wish_Fmaily_Contact_Email__c = FamilyContactEmail;
                currWishChild.Hidden_Wish_Fmaily_Contact_Name__c = FamilyContactName;
                currWishChild.RelatedContact__c = RelatedContact;
                currWishChild.IsWishFamily__c = isFamily;
                }
            if(ethnicityList.size() > 0)
            {
                String ect = '';
                for(String str : ethnicityList){
                    if(str != null){
                        ect+=str+';';
                    }
                }
                ect = ect.removeEnd(';');                
                currWishChild.Race_Ethnicity__c = ect;
            }
            if(wcfUtil.isInformation == True){
                currWishChild.Availability_Time_Period_1__c = wcfUtil.availableMonth1+'/'+wcfUtil.availableYear1;
                currWishChild.Availability_Time_Period_2__c = wcfUtil.availableMonth2+'/'+wcfUtil.availableYear2;
                currWishChild.Availability_Time_Period_3__c = wcfUtil.availableMonth3+'/'+wcfUtil.availableYear3;
                currWishChild.Requested_Participant_Name_forWheelchair__c = selectedNamesss(tempName);
                //currWishChild.Participant_Name_for_Dietary_Restriction__c =selectedNamesss(currrentDietaryList);
                currWishChild.Participant_Name_for_Dietary_Restriction__c = selectedNamesss(currrentDietaryNameList);
                currWishChild.Requested_Participant_Name_for_OtherNeed__c = selectedNamesss(currentOtherNeedsList);
                currWishChild.Requested_Participant_Name_for_Oxygen__c = selectedNamesss(currentOxygenNamesList);
                currWishChild.Requested_Participant_Name_for_Allergies__c = selectedNamesss(currentAllergyNamesList);
                currWishChild.Bringing_Own_Wheel_Chair__c = selectedNamesss(currentOwnWheelChairList);
                currWishChild.Name_of_wheelchair_collapsible__c= selectedNamesss(currentWCCollapsibleList);
                currWishChild.Pariticipant_name_havingWheelchair_Power__c= selectedNamesss(currentWCPowerList);
                currWishChild.Medication_require_refrigeration_name__c= selectedNamesss(currentMedicationList);
                currWishChild.Names_for_receiving_nursing_care__c= selectedNamesss(currentNursingCareList);
            }
            if(wcfUtil.wishParticipantList.size() > 0){
                currWishChild.Participant_Contacts__c= '';
                currWishChild.Participant_Name__c = '';
                currWishChild.Participant_Details__c = '';
                String JSONString = JSON.serialize(wcfUtil.wishParticipantList);                   
                currWishChild.Participant_Contacts__c= JSONString;
                currWishChild.Participant_Names__c = '';
                boolean isFamily = false;
                Integer age;
                System.debug('SAVE METHOD - '+wcfUtil.wishParticipantList);
                for(WishChildFormUtil.WrapperClass currRec : wcfUtil.wishParticipantList){
                    if(currRec.dob != Null){
                        Date dt = Date.Valueof(currRec.dob);
                        Integer days = dt.daysBetween(Date.Today());
                        age = Integer.valueOf(days/365);
                    }
                    if(currRec.FirstName != Null && currRec.LastName != Null && currRec.relationship != 'Self' )
                    {
                        currWishChild.Participant_Names__c +=+','+' '+currRec.FirstName.trim()+' '+currRec.LastName.trim();
                    }
                    if(String.isEmpty(currRec.FirstName) || String.isEmpty(currRec.LastName) || currRec.dob == null || String.isEmpty(currRec.residingWishMedical)|| String.isEmpty(currRec.medicalNeeds)  || String.isEmpty(currRec.relationship) && currRec.relationship != 'Self' ){
                        isFamily = true;
                    } 
                    if(age >= 18 && String.isEmpty(currRec.Email)){
                       // isFamily = true;
                    }
                    if(currRec.FirstName != Null && currRec.LastName != Null && currRec.Email != Null && age >= 18 && currRec.relationship != 'Self'){
                        String participantName = currRec.FirstName+'-'+currRec.LastName+'-'+currRec.Email;
                        if(!nameset.contains(participantName))
                            currWishChild.Participant_Details__c +=  currRec.FirstName+' '+currRec.LastName+'-'+currRec.Email+'-'+age+'#';
                    }
                    if(currRec.FirstName != Null && currRec.LastName != Null && age >= 18 && currRec.relationship != 'Self'){
                        String name = currRec.FirstName+'-'+currRec.LastName;
                        if(!namesetOne.contains(name))
                            currWishChild.Participant_Name__c +=currRec.FirstName.trim()+' '+currRec.LastName.trim()+'-'+age+'#';
                    }
                    if(currRec.dob != Null){
                        Date dt = Date.Valueof(currRec.dob);
                        Integer days = dt.daysBetween(Date.Today());
                        age = Integer.valueOf(days/365);
                    }  
                }
                
                if(isFamily == false){
                     isFamily = false;
                }
                if(currWishChild.Participant_Names__c != Null)
                    currWishChild.Participant_Names__c = currWishChild.Participant_Names__c.removeEnd('#');
                if(currWishChild.Participant_Details__c  != Null)
                    currWishChild.Participant_Details__c = currWishChild.Participant_Details__c.removeEnd('#');
                currWishChild.Participant_Details__c = currWishChild.Participant_Details__c.removeEnd('-');
                currWishChild.Participant_Name__c = currWishChild.Participant_Name__c.removeEnd('#');
                currWishChild.IsParticipant__c = isFamily; 
            }
            if(wcfUtil.driverWrapperCls.size() > 0 && wcfUtil.isInformation == True){
                currWishChild.Driver_Details__c = '';
                String JSONString = JSON.serialize(wcfUtil.driverWrapperCls);
                currWishChild.Driver_Details__c = JSONString;
                String driverInfo = '';
                Integer i = 0;
                String driverName = '';
                for(WishChildFormUtil.DriverWrapper currRec : wcfUtil.driverWrapperCls){
                   if(currRec.driverName != '')
                    {  
                       If(driverName == ''){
                        driverName = currRec.driverName;
                        }
                        else{
                        driverName = currRec.driverName+','+' '+driverName ;
                        }
                       if(driverInfo == ''){
                       if(string.valueof(currRec.expirationDate) != null ){
                         String S = String.valueof(currRec.expirationDate);
                         String s1 = S.remove(' 00:00:00');
                         driverInfo = currRec.driverName+' '+'|'+' '+currRec.licenseNum+' '+'|'+' '+currRec.state +' '+'|'+' '+ s1 +' '+'|'+' '+currRec.type;      
                      }
                     
                      }
                      
                       else{
                       
                         if(string.valueof(currRec.expirationDate) != null ){
                         String S = String.valueof(currRec.expirationDate);
                         String s1 = S.remove(' 00:00:00');
                         driverInfo =driverInfo +'<br/>'+currRec.driverName+' '+'|'+' '+currRec.licenseNum+' '+'|'+' '+currRec.state +' '+'|'+' '+ s1 +' '+'|'+' '+currRec.type;      
                      }
                      
                      }
                   }   
                } 
                 CurrWishChild.Driver_name__c = driverName; 
                 currWishChild.Driver_Information__c = driverInfo;
            }  
           
           if(wcfUtil.driverWrapperCls.size() == 0 && wcfUtil.isInformation == True){
              currWishChild.Driver_Information__c = null;
              currWishChild.Driver_Details__c = null;
            } 
             currWishChild.Case_Team_Member1__c = wcfUtil.caseTeamMemberNo1;
             currWishChild.Case_Team_Member2__c = wcfUtil.caseTeamMemberNo2;
             
             if(wishchildList.size() == 0)
                insert currWishChild;
             if(wishchildList.size() == 1)
                update currWishChild;
            
        }
        catch(DMLException e){        
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
        }     
    }
    
    public void SaveandWishChildExit(){
        try
        { 
            String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
            if(pageName == 'WishChildForm_VF'){
                saveContact();
            }
            if(pageName == 'WishFamilyForm_VF'){
                saveContact();
            }
            if(pageName == 'WishInformationForm_VF'){
                WishInfoSave();
            }
        }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
    }
    
    //This method used to navigate to the wishfamily form from child form
    public PageReference WCFNext(){ 
        try
        {
            saveContact();
            PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
        }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;
    }
    
    //This method is used to naviagte to the wish information form from the family form 
    public PageReference WCFtoWIF(){
        try
        {
            saveContact();
            PageReference reference=new PageReference('/apex/WishInformationForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
        }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;
    }
   
    //This method used to save the contact information and naviagte to the wishfamily form  
    public PageReference WCFtoWFF(){
        PageReference reference;
        try
        {
            saveContact();
            reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            //return reference;
        }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
            //return null;
        }
        return reference;
    }
    
    //Naviage to the wish information form 
    public PageReference WishFamilytoWishInfo(){
        PageReference reference;
        try
        {
            saveContact();
            reference=new PageReference('/apex/WishInformationForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
         }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
        return reference;
    }
    
    // Navigate to the wishchild form from information form   
    public PageReference WishInfotoWishChild(){
        PageReference reference;
        try
        {
            wcfUtil.isInformation = True;
            saveContact();
            reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
        }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
        return reference;
    }
    
    //Navigate to the wishfamily form  
    public PageReference WishInfotoWishFamily(){
        PageReference reference;
        try
        {
            wcfUtil.isInformation = True;
            saveContact();
            reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
         }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
        return reference;
    }
    
    //Navigate to the wishchild form   
    public PageReference NavigatetoWishChildForm(){
        PageReference reference;
        try
        {
            wcfUtil.isInformation = True;
            saveContact();
            reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id + '&required=true');
            reference.setRedirect(true);     
        }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
        return reference;
    }
    
    //Navigate to the wishfamily form  
    public PageReference NavigatetoWishFamily(){
        PageReference reference;
        try
        {
            wcfUtil.isInformation = True;
            SaveContact();  
            reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id + '&required=true');
            reference.setRedirect(true);     
         }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
        return reference;
    }
    
    // Back to Case Detail page.
    public PageReference cancelfunction(){
        system.debug('####DDDDD#######3'+currCase.id);
        PageReference reference=new PageReference('/'+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    //Cancel with out saving the contact 
    public pageReference cancel(){
        PageReference reference=new PageReference('/apex/WishInformationForm_VF?id='+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    //Save and exit from the form 
    public PageReference SavewithExit(){
        try{
            if(wcfUtil.sameParentGuardian)
                currWishChild.Hidden_Same_as_Family__c = true; 
            else
                currWishChild.Hidden_Same_as_Family__c = false;
            saveContact();
            PageReference reference=new PageReference('/'+currCase.id);
            reference.setRedirect(true);     
            return reference;
        }      
        catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
            return null;
        }  
        return null; 
    }
    
    //Used to remove the existing family details  
    public void removeFamily(){
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        //Remove the contact from the table    
        wcfUtil.wishFamilyWrapList.remove(indexVal);            
    }   
    
    public void removeParticipants(){
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('Participant'));
        //Remove the contact from the table    
        wcfUtil.wishParticipantList.remove(indexVal);            
    } 
    
    public void removeDriver(){
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('driver'));
        //Remove the contact from the table    
        wcfUtil.driverWrapperCls.remove(indexVal);            
    }    
   
    //Exit without saving the family details
    public PageReference ExitWithOutSave(){
        PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    //With out saving exit from the wish information form  
    Public pageReference withOutSavefromWCFtoWIF(){
        //SaveContact();
        PageReference reference=new PageReference('/apex/WishInformationForm_VF?id='+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    //With out saving wishchild details    
    Public pageReference withOutSavetoChild(){
        PageReference reference=new PageReference('/apex/WishChildForm_VF?id='+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    Public pageReference withOutSaveWCCF(){
        system.debug('withOutSaveWCCF method');
        PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    public PageReference ExitwithApprovalError(){
        PageReference reference=new PageReference('/'+currentPageId);
        reference.setRedirect(true);     
        return reference;
    }
    
    //Used to add the new family record    
    public void addFamily(){
        System.debug('Function called+++++++++++');
        (wcfUtil.wishFamilyWrapList).add(new WishChildFormUtil.WrapperClass());
    }
    
    public void addDriver(){
        // if(wcfUtil.driverWrapperCls.size() < wcfUtil.wishParticipantList.size())
        wcfUtil.driverWrapperCls.add(new WishChildFormUtil.DriverWrapper());
    }
   
    //used to add new participants detail 
    public void addParticipants(){ 
        wcfUtil.wishParticipantList.add(new WishChildFormUtil.WrapperClass());
    }
    
    public pageReference BackToWCF()
    {
        SaveContact();
        System.debug('AFTER SAVE');
        if(wcfUtil.sameParentGuardian)
            currWishChild.Hidden_Same_as_Family__c = true; 
        else
            currWishChild.Hidden_Same_as_Family__c = false;
        //UPDATE currWishChild;
        PageReference reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    //used to use same value from the parent details with out re-entering  
    public pageReference CheckSameasParent()
    {
        PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+currCase.id+'&part='+isParticipants);
        reference.setRedirect(true);     
        return reference;
    }
    
    //Save and exit from the family form    
    public PageReference SaveandwishFamilyExit()
    {
        try{
            if(wcfUtil.sameParentGuardian)
                currWishChild.Hidden_Same_as_Family__c = true;
            else 
                currWishChild.Hidden_Same_as_Family__c = false;         
            saveContact();
            PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+currCase.id+'&part='+isParticipants);
            reference.setRedirect(true);  
            return reference;
        }      
        catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
            return null;
        }      
        return null;   
    }
    
    public PageReference WFFNext(){ 
        try
        {
            if(wcfUtil.sameParentGuardian)
                currWishChild.Hidden_Same_as_Family__c = true;
            else 
                currWishChild.Hidden_Same_as_Family__c = false;  
            saveContact();
            PageReference reference=new PageReference('/apex/WishInformationForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
        }      
        catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null; 
    }
    
    //Add Wish family as Wish participants
    public void SameAsFamily()
    {
        if(wcfUtil.sameParentGuardian){
            currWishChild.Hidden_Same_as_Family__c = true; 
            ParticipantsMapping(wcfUtil.wishFamilyWrapList,true);
        }
        else{
            RemovesameParentGuardian();
        }  
    }
    
    //Remove Wish family From Wish participants
    public void RemovesameParentGuardian()
    { 
        Integer j = 0;
        while (j < wcfUtil.wishParticipantList.size()){
            if(wcfUtil.wishParticipantList.get(j).sameParentGuardianFlag){
                wcfUtil.wishParticipantList.remove(j);  
            }
            else {
                j++;        
            }
        }
    }
    
    public void ParticipantsMapping(List<WishChildFormUtil.WrapperClass> participantsList,Boolean isChecked){
        for(WishChildFormUtil.WrapperClass  currRec : participantsList){
            WishChildFormUtil.WrapperClass wrapCls;
            if(wrapCls == null){
                wrapCls = new WishChildFormUtil.WrapperClass();
            }
            wrapCls.FirstName = (currRec.FirstName!=Null)?currRec.FirstName:'';
            wrapCls.MiddleName = (currRec.MiddleName!=Null)?currRec.MiddleName:'';
            wrapCls.lastName = (currRec.lastName!=Null)?currRec.lastName:'';
            wrapCls.Relationship = (currRec.Relationship!=Null)?currRec.Relationship:'';
            wrapCls.dob =  (currRec.dob !=Null)?Date.valueOf(currRec.dob):currRec.dob;
            wrapCls.medicalNeeds =  currRec.medicalNeeds;
            wrapCls.residingWishMedical =currRec.residingWishMedical;
            wrapCls.Email =  (currRec.Email!=Null)?currRec.Email:'';
            if( wrapCls.Relationship != 'Self'){
                wrapCls.tshirtSize = (currRec.tshirtSize!=Null)?currRec.tshirtSize:'';
            }
            else{
                wrapCls.tshirtSize = tshirt;
            }
            wrapCls.sameParentGuardianFlag = (isChecked == true) ? isChecked : currRec.sameParentGuardianFlag;
            wrapCls.isChildParticipants = isChildPart;
            if(wrapCls.Relationship == 'self' && wcfUtil.wishParticipantList.size()==0){
                wcfUtil.wishParticipantList.add(wrapCls); 
                // relationShipSet.add('Self');
            }
            else if(wrapCls.Relationship != 'self' && wcfUtil.wishParticipantList.size()>0)
            {
                wcfUtil.wishParticipantList.add(wrapCls);
            }
            /*  else if(wrapCls.Relationship == 'self'){
                wcfUtil.wishParticipantList.add(wrapCls); 
            }*/
            System.debug(isChecked+'--+--'+wcfUtil.wishParticipantList);                       
            String Name = wrapCls.FirstName+' '+wrapCls.lastName;
            wcfUtil.driverNameList.add((new SelectOption(Name,Name)));
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftDietaryNameList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftWCNamesList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
            
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftOxygenNamesList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
            
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftAllergyNamesList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
            
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftOtherNeedsList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
            
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftOwnWheelChairList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
            
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftWCCollapsibleList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
            
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftWCPowerList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
            
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftMedicationList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
            
            if(wrapCls.FirstName != Null && wrapCls.lastName != Null)
                wcfUtil.leftNursingCareList.add(wrapCls.FirstName+' ' +wrapCls.lastName);
        }
    }
    
    public PageReference SaveandRedirectChildForm(){
        if(wcfUtil.sameParentGuardian)
            currWishChild.Hidden_Same_as_Family__c = true;
        else 
            currWishChild.Hidden_Same_as_Family__c = false; 
        saveContact();
        PageReference reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    public PageReference SaveAndRedirectFamilyForm(){
        if(wcfUtil.sameParentGuardian)
            currWishChild.Hidden_Same_as_Family__c = true;
        else 
            currWishChild.Hidden_Same_as_Family__c = false; 
        saveContact();
        PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    //navigate to the wishfamily form   
    public PageReference SaveAndRedirectInformationForm(){
        if(wcfUtil.sameParentGuardian)
            currWishChild.Hidden_Same_as_Family__c = true;
        else 
            currWishChild.Hidden_Same_as_Family__c = false; 
        WishInfoSave();
        PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    //Save information detail and navigate to child form    
    public PageReference SaveFromInformationToChildForm()
    {
        if(wcfUtil.sameParentGuardian)
            currWishChild.Hidden_Same_as_Family__c = true;
        else 
            currWishChild.Hidden_Same_as_Family__c = false; 
        WishInfoSave();
        PageReference reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    //Used to get sign  
    public void confirmSignNow()
    {
        wcfUtil.isInformation = True;
        SaveContact();        
        for(Wish_Child_Form__c wishChildForm : [SELECT Id,Name,Case__c,Hidden_Same_as_Family__c,Race_Ethnicity__c,Hidden_Contact_Name__c,Hidden_Wish_Fmaily_Contact_Email__c,Hidden_Wish_Fmaily_Contact_Name__c FROM Wish_Child_Form__c WHERE
                                                Case__c =: this.currCase.Id])
        {
            if(wishChildForm.Hidden_Wish_Fmaily_Contact_Name__c != null) {  
                for(String keys : wishChildForm.Hidden_Wish_Fmaily_Contact_Name__c.split('#'))
                {
                    wcfUtil.SignNowList.add(keys.trim());                     
                }                  
            }
        }
    }
    
   public PageReference SignNowmultiEmail(){
        Map<String,String> nameMap = new Map<String,String>();
        Set<String> signerSet = new Set<String>();
        for(Wish_Child_Form__c wishChildForm : [SELECT Id,Name,Case__c,Hidden_Same_as_Family__c,Race_Ethnicity__c,Hidden_Contact_Name__c,Hidden_Wish_Fmaily_Contact_Email__c,Hidden_Wish_Fmaily_Contact_Name__c FROM Wish_Child_Form__c WHERE
                                                Case__c =: this.currCase.Id])
        {
            
            if(wishChildForm.Hidden_Wish_Fmaily_Contact_Name__c != null)
            {  
                for(String keys : wishChildForm.Hidden_Wish_Fmaily_Contact_Name__c.split('#'))
                {
                    wcfUtil.SignNowList.add(keys.trim());     
                }                  
            }
        }
        wcfUtil.multiPickoptions = new List<SelectOption>();
        if(wcfUtil.emailMap.size() > 0)
        {
            Map<String,String> processedNameMap = new Map<String,String>();
            for(Wish_Child_Form__c wishChildForm : [SELECT Id,Name,Case__c,Hidden_Contact_Name__c,Hidden_Wish_Fmaily_Contact_Email__c,Hidden_Wish_Fmaily_Contact_Name__c FROM Wish_Child_Form__c WHERE
                                                    Case__c =: currCase.id])
            {
                                                        if(wishChildForm.Hidden_Contact_Name__c != Null) {                                     
                                                            for(String keys : wishChildForm.Hidden_Contact_Name__c.split('#')){
                                                                nameMap.put(keys.trim(),'abc');
                                                            } 
                                                        }
                                                        if(wishChildForm.Hidden_Wish_Fmaily_Contact_Name__c != Null){
                                                            for(String processSignerString : wishChildForm.Hidden_Wish_Fmaily_Contact_Name__c.split('#')){
                                                                String removeSpace = processSignerString.trim();
                                                                signerSet.add(removeSpace); 
                                                            }
                                                            
                                                        }
                                                    }
            for(Wish_Child_Form__c wishChildForm : [SELECT Id,Name,Case__c,Hidden_Contact_Name__c,Hidden_Wish_Fmaily_Contact_Email__c,Hidden_Wish_Fmaily_Contact_Name__c FROM Wish_Child_Form__c WHERE
                                                    Case__c =: currCase.id])
            { 
                                                        if(wishChildForm.Hidden_Wish_Fmaily_Contact_Email__c != Null){
                                                            for(String key : wishChildForm.Hidden_Wish_Fmaily_Contact_Email__c.split('#')){
                                                                String keys = key.split('-')[0];
                                                                String value = key.split('-')[1];
                                                                processedNameMap.put(keys.trim(),value);
                                                            } 
                                                        }
                                                    }
            if(processedNameMap.size() > 0)
            {
                for(String name : processedNameMap.KeySet())
                {
                    if(!nameMap.containsKey(name)){
                        wcfUtil.selectedMailMap.put(name,processedNameMap.get(name));
                    }
                }
            }
        }
        if(wcfUtil.selectedMailMap.size() > 0)
        {
            String account;
            String userName;
            String password;
            String integratorKey;
            String endPointURL;
            Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
            for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
                userName = credentialIns.name;
                account = credentialIns.account__c;
                password = credentialIns.Password__c;
                integratorKey  = credentialIns.IntegratorKey__c;
                endPointURL = credentialIns.end_Point__c;
            }
            String endpoint = endPointURL+'/accounts/'+account+'/envelopes';
            String authorizationHeader = '<DocuSignCredentials><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
            String status;
            String email;
            String recipients = '';
            Integer i = 1;
            String boundary = 'AAA';
            Pagereference PDF = Page.SignNowPDF;
            PDF.getParameters().put('Id',currCase.id);
            try {
                wcfUtil.documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
            }catch(Exception e) {
            }
            Wish_Child_Form__c dbcase = [SELECT Id,Envelop_Id__c,Case__c,SignerMapKeyPair__c,Hidden_Envelop_Id_1__c,Hidden_Envelop_Id_2__c,
                                         Hidden_SignerMap_Key_1__c,Hidden_SignerMap_Key_2__c,Hidden_Envelop_Id_3__c,Hidden_SignerMap_Key_3__c FROM Wish_Child_Form__c WHERE Case__c =:currCase.id];
            Set<String> processSet = new Set<String>();
            if(dbcase.SignerMapKeyPair__c != Null && dbcase.Envelop_Id__c != Null && dbcase.Hidden_Envelop_Id_1__c == Null &&
               dbcase.Hidden_SignerMap_Key_1__c == Null ){
                   for(String processName : dbcase.SignerMapKeyPair__c.split('#')){
                       String keys = processName.split('-')[0];
                       String value = processName.split('-')[1];
                       String name = Keys.trim();
                       processSet.add(name);
                   }
                   for(String signNowName : signerSet){
                       if(!processSet.contains(signNowName)){
                           j = 1;
                       }
                       system.debug('J Value 1'+ j);
                       system.debug('K Value 1'+ k);
                   }
               }
            if(dbcase.Hidden_Envelop_Id_1__c != Null && dbcase.Hidden_SignerMap_Key_1__c != Null)
            {
                set<String> processSetOne = new Set<String>();
                for(String processName : dbcase.Hidden_SignerMap_Key_1__c .split('#')){
                    String keys = processName.split('-')[0];
                    String value = processName.split('-')[1];
                    String name = Keys.trim();
                    processSetOne.add(name);
                }
                for(String processName : dbcase.SignerMapKeyPair__c.split('#'))
                {
                    String keys = processName.split('-')[0];
                    String value = processName.split('-')[1];
                    String name = Keys.trim();
                    processSet.add(name);
                }
                for(String signNowName : signerSet)
                {
                    if(!processSet.contains(signNowName)){
                        if(!processSetOne.contains(signNowName)){
                            j = 2;
                            k = 1;
                        }
                    }
                    system.debug('J Value 2'+ j);
                    system.debug('K Value 2'+ k);
                }
            }
            if(dbcase.Hidden_Envelop_Id_2__c != Null && dbcase.Hidden_SignerMap_Key_2__c != Null)
            {
                Set<String> processSetOne = new Set<String>();
                Set<String> processSetTwo = new Set<String>();
                for(String processName : dbcase.Hidden_SignerMap_Key_2__c .split('#'))
                {
                    String keys = processName.split('-')[0];
                    String value = processName.split('-')[1];
                    String name = Keys.trim();
                    processSetTwo.add(name);
                }
                for(String processName : dbcase.Hidden_SignerMap_Key_1__c .split('#'))
                {
                    String keys = processName.split('-')[0];
                    String value = processName.split('-')[1];
                    String name = Keys.trim();
                    processSetOne.add(name);
                }
                for(String processName : dbcase.SignerMapKeyPair__c.split('#'))
                {
                    String keys = processName.split('-')[0];
                    String value = processName.split('-')[1];
                    String name = Keys.trim();
                    processSet.add(name);
                }
                for(String signNowName : signerSet)
                {
                    if(!processSet.contains(signNowName))
                    {
                        if(!processSetOne.contains(signNowName))
                        {
                            if(!processSetTwo.contains(signNowName))
                            {
                                j = 3;
                                k = 2;
                            }
                        }
                    }
                    system.debug('J Value 3'+ j);
                    system.debug('K Value 3'+ k);
                }
            }
            if((dbcase.Envelop_Id__c  == Null && dbcase.SignerMapKeyPair__c == Null && j == 0) || (dbcase.Hidden_Envelop_Id_1__c == Null && dbcase.Hidden_SignerMap_Key_1__c == Null && j == 1 && k == 0) || 
               (dbcase.Hidden_Envelop_Id_2__c == Null && dbcase.Hidden_SignerMap_Key_2__c  == Null && j == 2 && k == 1) || (dbcase.Hidden_Envelop_Id_3__c == Null && dbcase.Hidden_SignerMap_Key_3__c == Null && j == 3 && k == 2)){
                   system.debug('J VALE'+ j);
                   system.debug('K VALE'+ k);
                   for(String currString : wcfUtil.selectedMailMap.keySet()){
                       String Name = currString;
                       email = wcfUtil.sendEmailMap.get(currString);
                       if(recipients != '')
                           recipients = recipients + ',';
                       recipients = recipients + '{'+
                           '      "email": "NotSent@NoEmail.com",'+
                           '      "name": "'+Name+'",'+
                           '      "recipientId":"'+i+'",'+
                           '      "clientUserId":"'+i+'",'+
                           '      "tabs": {'+
                           '                "signHereTabs": [{'+
                           '                     "anchorString":"~s'+i+'",'+
                           '                    "anchorXOffset": "0",'+
                           '                   "anchorYOffset": "0",'+
                           '                    "anchorIgnoreIfNotPresent": "false",'+
                           '                    "anchorUnits": "inches"'+
                           '                }],'+
                           '                  "dateSignedTabs": [{'+
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
                       if(!wcfUtil.signersKeyPairMap.containsKey(Name))
                           wcfUtil.signersKeyPairMap.put(Name,String.valueof(i));
                       i++;
                   }
                   //forming payload with the document and recipients.
                   String body =  '{'+
                       '  "status":"sent",'+
                       '  "enableWetSign": "false",'+
                       '  "emailBlurb":"Wish Paperwork Packet",'+
                       '  "emailSubject": "Wish Paperwork Packet",'+
                       '  "enforceSignerVisibility":"True",'+
                       '  "documents": [{'+
                       '      "name": "document.pdf",'+
                       '      "documentId":"1",'+
                       '      "order":"1",'+
                       '      "documentBase64":"'+wcfUtil.documentPDF+'"'+
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
                   system.debug('@@@@@JSONBODY@@@@@'+jsonBody);
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
                           if((String) results.get('envelopeId') != '')
                               wcfUtil.envelopeId = (String) results.get('envelopeId');
                           if((String) results.get('status') == 'Sent'){
                               status = 'Agreement sent to email.';
                               dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                               dsfs.dsfs__DocuSign_Envelope_ID__c = (String) results.get('envelopeId');
                               dsfs.dsfs__Case__c= currCase.id;
                               Insert dsfs;
                           }else
                               status = (String) results.get('errorCode');
                       }
                   }catch(Exception e){
                   }
               }
            else{
                if(dbcase.Envelop_Id__c != Null && dbcase.Hidden_Envelop_Id_1__c  == Null && dbcase.Hidden_Envelop_Id_2__c == Null && j == 0){
                    wcfUtil.envelopeId = dbcase.Envelop_Id__c;
                    for(String key : dbcase.SignerMapKeyPair__c.split('#')){
                        String keys = key.split('-')[0];
                        String value = key.split('-')[1];
                        wcfUtil.signersKeyPairMap.put(keys.trim(),value.trim());
                    } 
                }
                if(dbcase.Envelop_Id__c != Null && dbcase.Hidden_Envelop_Id_1__c  != Null && dbcase.Hidden_Envelop_Id_2__c == Null ){
                    wcfUtil.envelopeId = dbcase.Hidden_Envelop_Id_1__c;
                    for(String key : dbcase.Hidden_SignerMap_Key_1__c.split('#')){
                        String keys = key.split('-')[0];
                        String value = key.split('-')[1];
                        wcfUtil.signersKeyPairMap.put(keys.trim(),value.trim());
                    } 
                }
                if(dbcase.Envelop_Id__c != Null && dbcase.Hidden_Envelop_Id_1__c  != Null && dbcase.Hidden_Envelop_Id_2__c != Null ){
                    wcfUtil.envelopeId = dbcase.Hidden_Envelop_Id_2__c;
                    for(String key : dbcase.Hidden_SignerMap_Key_2__c.split('#')){
                        String keys = key.split('-')[0];
                        String value = key.split('-')[1];
                        wcfUtil.signersKeyPairMap.put(keys.trim(),value.trim());
                    }
                }
                
                if(dbcase.Envelop_Id__c != Null && dbcase.Hidden_Envelop_Id_1__c  != Null && dbcase.Hidden_Envelop_Id_2__c != Null && dbcase.Hidden_Envelop_Id_3__c != Null){
                    wcfUtil.envelopeId = dbcase.Hidden_Envelop_Id_3__c;
                    for(String key : dbcase.Hidden_SignerMap_Key_3__c.split('#')){
                        String keys = key.split('-')[0];
                        String value = key.split('-')[1];
                        wcfUtil.signersKeyPairMap.put(keys.trim(),value.trim());
                    }
                }
            }
            //wcfUtil.displaySignNowPopup = true;
            for(String currString : wcfUtil.selectedMailMap.keySet()){           
                wcfUtil.multiPickoptions.add(new SelectOption(currString,currString ));
            }
        }     
        else{
            wcfUtil.displayError = true;
        }
        return null;
    }
    
    //Used to submit the form and get sign 
    public Pagereference SubmitAndSign(){
        String account;
        String UserName;
        String Password;
        String IntegratorKey;
        String endPointURL;
        String currentSigner;
        Id wishPaperPocketId;
        //List<Contact> relationShipList = new List<Contact>();
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        Wish_Child_Form__c dbcase = [SELECT Id,Envelop_Id__c,SignerMapKeyPair__c,Hidden_Envelop_Id_1__c,Hidden_Envelop_Id_2__c,
                                     Hidden_SignerMap_Key_1__c,Hidden_SignerMap_Key_2__c,Case__c,Hidden_Envelop_Id_3__c,Hidden_SignerMap_Key_3__c FROM Wish_Child_Form__c WHERE Case__c =:currCase.id];
        for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
            UserName = credentialIns.name;
            account  = credentialIns.account__c;
            Password = credentialIns.Password__c;
            IntegratorKey  = credentialIns.IntegratorKey__c;
            endPointURL = credentialIns.end_Point__c;
        }
        string endpoint = endPointURL+'/accounts/'+account+'/envelopes';
        String authorizationHeader = '<DocuSignCredentials><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
        string endpoint2 = endPointURL+'/accounts/'+account+'/envelopes/'+wcfUtil.envelopeId+'/views/recipient';
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
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        jsonPayload = '{'+
            '    "userName": "'+wcfUtil.SignNowName+'",'+
            '    "email": "NotSent@NoEmail.com",'+
            '    "recipientId": "'+wcfUtil.signersKeyPairMap.get(wcfUtil.SignNowName)+'",'+
            '    "clientUserId": "'+wcfUtil.signersKeyPairMap.get(wcfUtil.SignNowName)+'",'+
            '    "authenticationMethod": "None",'+
            '   "returnUrl": "'+baseUrl +'/apex/WishInformationForm_VF?Id='+currCase.id+'"'+   
            '}'; 
        request.setBody(jsonPayload);
        response = httprequest.send(request);  
        system.debug(response.getBody());
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        //signersKeyPairMap.remove(SignNowName);
        String sign;
        for(String name : wcfUtil.signersKeyPairMap.KeySet()){
            if(sign == '' || sign == Null)
                sign= name +' - '+ wcfUtil.signersKeyPairMap.get(name);
            else
                sign = sign +'#'+ name +' - '+ wcfUtil.signersKeyPairMap.get(name);
        }
        if(dbcase.SignerMapKeyPair__c == Null && dbcase.Envelop_Id__c == Null &&
           dbcase.Hidden_SignerMap_Key_1__c == Null && dbcase.Hidden_Envelop_Id_1__c == Null && dbcase.Hidden_Envelop_Id_2__c == Null && dbcase.Hidden_SignerMap_Key_2__c == Null){
               Wish_Child_Form__c newCase = new Wish_Child_Form__c();
               newCase.Id = dbcase.id;
               newCase.SignerMapKeyPair__c = sign;
               newCase.Envelop_Id__c = wcfUtil.envelopeId;
               
               update newCase;
           }
        if(dbcase.SignerMapKeyPair__c != Null && dbcase.Envelop_Id__c != Null && dbcase.Hidden_SignerMap_Key_1__c == Null && dbcase.Hidden_Envelop_Id_1__c == Null
           && dbcase.Hidden_Envelop_Id_2__c == Null && dbcase.Hidden_SignerMap_Key_2__c == Null && j == 1 && k == 0){
               Wish_Child_Form__c newCase = new Wish_Child_Form__c();
               newCase.Id = dbcase.id;
               newCase.Hidden_SignerMap_Key_1__c = sign;
               newCase.Hidden_Envelop_Id_1__c = wcfUtil.envelopeId;
               
               update newCase;
           }
        if(dbcase.SignerMapKeyPair__c != Null && dbcase.Envelop_Id__c != Null && dbcase.Hidden_Envelop_Id_2__c == Null && dbcase.Hidden_SignerMap_Key_2__c == Null &&
           dbcase.Hidden_SignerMap_Key_1__c != Null && dbcase.Hidden_Envelop_Id_1__c != Null && j == 2 && k == 1){
               Wish_Child_Form__c newCase = new Wish_Child_Form__c();
               newCase.Id = dbcase.id;
               newCase.Hidden_SignerMap_Key_2__c = sign;
               newCase.Hidden_Envelop_Id_2__c = wcfUtil.envelopeId;
               
               update newCase;
           }
        if(dbcase.SignerMapKeyPair__c != Null && dbcase.Envelop_Id__c != Null && dbcase.Hidden_Envelop_Id_2__c != Null && dbcase.Hidden_SignerMap_Key_2__c != Null &&
           dbcase.Hidden_SignerMap_Key_1__c != Null && dbcase.Hidden_Envelop_Id_1__c != Null && dbcase.Hidden_Envelop_Id_3__c != Null && dbcase.Hidden_SignerMap_Key_3__c != Null && j == 3 && k == 2){
               Wish_Child_Form__c newCase = new Wish_Child_Form__c();
               newCase.Id = dbcase.id;
               newCase.Hidden_SignerMap_Key_3__c = sign;
               newCase.Hidden_Envelop_Id_3__c = wcfUtil.envelopeId;
               
               update newCase;
           }
        /*for(Wish_Child_Form__c wishChildForm : [SELECT Id,Name,Case__c,Hidden_Contact_Name__c,Signers__c,Hidden_Wish_Fmaily_Contact_Email__c,Hidden_Wish_Fmaily_Contact_Name__c FROM Wish_Child_Form__c WHERE
              Case__c =: currCase.id])
          {
                currentSigner = wishChildForm.Signers__c;
                Wish_Child_Form__c  updateWishChild = new Wish_Child_Form__c ();
                updateWishChild.Id = wishChildForm.Id;
                wishPaperPocketId = wishChildForm.Id;
                if(wishChildForm.Hidden_Contact_Name__c != Null){
                    updateWishChild.Hidden_Contact_Name__c = wishChildForm.Hidden_Contact_Name__c+'#'+ wcfUtil.SignNowName;}
                else{
                    updateWishChild.Hidden_Contact_Name__c = wcfUtil.SignNowName;}
                if(wishChildForm.Signers__c == Null){
                    updateWishChild.Signers__c =wcfUtil.SignNowName;
                }
                else{
                    updateWishChild.Signers__c = wishChildForm.Signers__c +'#'+wcfUtil.SignNowName;
                }
                    
                update updateWishChild ;
         }*/
        
        PageReference reference=new PageReference((String) results.get('url'));
        reference.setRedirect(true);
        return reference;
    }
    
    //Navigate to the wish family form 
    public pageReference BackToWFF() {
        WishInfoSave();
        PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
        reference.setRedirect(true);     
        return reference;
    } 
    
    //This method used to save information form details  
    public PageReference WishInfoSave(){
        try
        {
            wcfUtil.isInformation = True;
            saveContact();
            PageReference  reference=new PageReference('/apex/WishInformationForm_VF?id='+currcase.Id+'&part='+isParticipants);
            reference.setRedirect(true);     
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.CONFIRM,'You Have Successfully Saved Your Information');
            ApexPages.addMessage(myMsg);
            return reference;
        }
        Catch(DMLException e)
        {
        }
        return null;
    }
    
    //This method used to submit the record for approval  
    public pagereference submitforApproval(){
        boolean isApproval;
        PageReference reference;
        List<ProcessInstance> approvalIns =  [SELECT TargetObjectId,Status,ProcessDefinitionId,ProcessDefinition.Name FROM ProcessInstance WHERE TargetObjectId =: currCase.id AND Status =: 'Pending' ];
        If(approvalIns.size() > 0){
            isApproval = true;
        }
        else{
            wcfUtil.isInformation = True;
            saveContact();
            case updateParentCase = new Case();
            updateParentCase.Id = currCase.id;
            updateParentCase.Wish_Family_Form_Submitted__c = true;
            
            update updateParentCase ;
            
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request for approval.');
            req.setObjectId(currCase.id);
            req.setProcessDefinitionNameOrId('Wish_Child_Form_Approval_Process');
            req.setSkipEntryCriteria(true);
            Approval.ProcessResult result = Approval.process(req);
        }
        reference=new PageReference('/'+currCase.id);
        reference.setRedirect(true);     
        return reference;  
    }
    
    //This method used to generate the form details as PDF  
    public pagereference generatePDF(){
        PageReference reference=new PageReference('/apex/WishFormDownloadPDF?Id='+currCase.id+'&force_download=true');
        reference.setRedirect(true);     
        return reference;
    }
    
    //This method used to send docusign to get signature
    public pageReference multiEmail(){
        wcfUtil.isInformation = True;
        saveContact();
        if(currWishChild.Emergency_Relationship__c != Null && currWishChild.Emergency_First_Name__c != Null && currWishChild.Emergency_Last_Name__c != Null && currWishChild.Emergency_Mobilephone__c != Null && currWishChild.Hidden_Wish_Fmaily_Contact_Email__c != Null && currWishChild.Wish_Family_Contact__c != Null)
        {
            if(wcfUtil.emailMap.size() > 0){
                wcfUtil.multiPickoptions = new List<SelectOption>();
                Set<String> nameSet = new Set<String>();
                Map<String,String> processedNameMap = new Map<String,String>();
                for(Wish_Child_Form__c wishChildForm : [SELECT Id,Name,Case__c,Hidden_Contact_Name__c,Hidden_Wish_Fmaily_Contact_Email__c,Hidden_Wish_Fmaily_Contact_Name__c FROM Wish_Child_Form__c WHERE
                                                        Case__c =: currCase.id]){
                                                            if(wishChildForm.Hidden_Contact_Name__c != Null) {                                     
                                                                for(String keys : wishChildForm.Hidden_Contact_Name__c.split('#')){
                                                                    nameSet.add(keys.trim());
                                                                } 
                                                            }
                                                        }
                
                Wish_Child_Form__c wishChildForm = [SELECT Id,Name,Case__c,Hidden_Contact_Name__c,Hidden_Wish_Fmaily_Contact_Email__c,Hidden_Wish_Fmaily_Contact_Name__c FROM Wish_Child_Form__c WHERE
                                                    Case__c =: currCase.id];
                for(String key : wishChildForm.Hidden_Wish_Fmaily_Contact_Email__c.split('#')){
                    String keys = key.split('-')[0];
                    String value = key.split('-')[1];
                    processedNameMap.put(keys.trim(),value);
                } 
               if(processedNameMap.size() > 0){
                    for(String name : processedNameMap.KeySet()){
                        if(!nameSet.contains(name)){
                            if(wcfUtil.selectedMailMap.containsKey(name)){
                                wcfUtil.selectedMailMap.put(name,processedNameMap.get(name));
                            }
                            else
                                wcfUtil.selectedMailMap.put(name,processedNameMap.get(name));
                        }
                    }
                }
                for(String currString : wcfUtil.selectedMailMap.keySet()){
                    wcfUtil.multiPickoptions.add(new SelectOption(currString,currString ));
                }
                if(wcfUtil.selectedMailMap.size() > 0){
                    wcfUtil.displayPopup = true;
                }         
            }
            else{
                wcfUtil.displayError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'All participants have already signed the form.'));
            }
        }
        return null;
    }
    
    //This method used to send pdf to an email  
    public pageReference sendpdftoEmail (){
        wcfUtil.displayPopup = false;
        Set<String> senderNameSet = new Set<String>();
        for(String processEmailList :wcfUtil.emailList ){
            if(senderNameSet.contains(processEmailList )){
                processEmailList = processEmailList+' ';
                senderNameSet.add(processEmailList);
            }
            senderNameSet.add(processEmailList);
        }
        for(String currString : wcfUtil.selectedMailMap.keySet()){
            if(senderNameset.Contains(currString)){
                wcfUtil.sendEmailMap.put(currString,wcfUtil.selectedMailMap.get(currString));
                
            }
        }
        if((!wcfUtil.sendEmailMap.isEmpty()) && wcfUtil.sendEmailMap.size() > 0 ){
            for(String currString : wcfUtil.sendEmailMap.KeySet()){
                if(wcfUtil.querySignature==null)
                    wcfUtil.querySignature = currString;
                else
                    wcfUtil.querySignature = wcfUtil.querySignature + '#' +currString;
            }
        }
        /*for(Wish_Child_Form__c dbCase : [SELECT Id,Hidden_Contact_Name__c From Wish_Child_Form__c WHERE Id =: currWishChild.Id]){
                Wish_Child_Form__c newCase = new Wish_Child_Form__c();
                newCase.Id = dbCase.Id;
                if(dbCase.Hidden_Contact_Name__c  == Null)
                newCase.Hidden_Contact_Name__c = wcfUtil.querySignature;
                else
                newCase.Hidden_Contact_Name__c = dbCase.Hidden_Contact_Name__c+'#'+wcfUtil.querySignature;
                try{
                update newCase;
                }
                catch(Exception e){
                }
          }*/
        if(wcfUtil.sendEmailMap.size() > 0){    
            callouttoDocusing(wcfUtil.sendEmailMap,CurrCase.id,wcfUtil.wishChildId );
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'An email has been sent successfully'));
        }
        PageReference acctPage = new PageReference ('/apex/WishInformationForm_VF?id='+currCase.id+'&part='+isParticipants);
        acctPage.setRedirect(true);
        
        return acctPage;  
    }
    
    @Future(callout=true)
    public static void callouttoDocusing(map<String,String> sendEmailMap,String caseId,Id wishChildId ){
        
        List<Contact> relationShipList = new List<Contact>();
        Pagereference PDF = Page.SendPDF;
        String documentPDF;
        PDF.setRedirect(false);
        PDF.getParameters().put('Id',caseId);
        If(!Test.isrunningtest())
            documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
        system.debug(PDF+'base64 value '+documentPDF);
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
        //Fetching related contacts that has email address and forming recipients with signature location.
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
            '  "emailBlurb":"Wish Paperwork Packet",'+
            '  "emailSubject": "Wish Paperwork Packet",'+
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
        system.debug('@@@@@JSONBODY@@@@@'+jsonBody);
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
            if(recipients != '')
            {
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
            
            /* for(Wish_Child_Form__c wishChildForm : [SELECT Id,Name,Case__c,Hidden_Contact_Name__c,Hidden_Wish_Fmaily_Contact_Email__c,Hidden_Wish_Fmaily_Contact_Name__c FROM Wish_Child_Form__c WHERE
                Case__c =: caseId]){
                    Wish_Child_Form__c  updateWishChild = new Wish_Child_Form__c ();
                    updateWishChild.Id = wishChildForm.Id;
                    if(wishChildForm.Hidden_Contact_Name__c != Null){
                    updateWishChild.Hidden_Contact_Name__c=wishChildForm.Hidden_Contact_Name__c+'#'+ ContactName;}
                    else{
                    updateWishChild.Hidden_Contact_Name__c = ContactName;}
                    if(wishChildForm.Signers__c == Null){
                    updateWishChild.Signers__c = ContactName;}
                    else{
                    updateWishChild.Signers__c = wishChildForm.Signers__c +'#'+ContactName;
                    }
                    update updateWishChild ;
                }*/
        }
        catch(Exception e){
        }    
    }
    //This method used to save information form details  
    public void WishInfoWithSave(){
        try
        {
            wcfUtil.isInformation = True;
            saveContact();
        } 
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
    }
    //used to download pdf   
    public void forceDownloadPDF(){
        if(ApexPages.currentPage().getParameters().get('force_download') != null && ApexPages.currentPage().getParameters().get('force_download') == 'true') 
        {
            string fileName = 'WishFamilyForm '+date.today()+'.pdf';
            if(apexPages.currentPage().getParameters().get('filename') != null)
            {
                fileName = apexPages.currentPage().getParameters().get('filename') +'.pdf';
            }
            Apexpages.currentPage().getHeaders().put('content-disposition', 'attachemnt; filename='+fileName);
        }   
    }
    
    public pageReference DisplayApprovalProcess(){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,' This record is already in approval process'));
        return null;
    } 
    
    public List<SelectOption> getRaceEthnicity(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Wish_Child_Form__c.Race_Ethnicity__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', '')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      
            options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
        }  
        return options;
    }  
    
    public List<SelectOption> getDoesParticipantReqWheelchair(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','')); 
        for(String name : wcfUtil.leftWCNamesList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    }  
    
    public List<SelectOption>getWillYourFamilyBringWheelChair(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','')); 
        for(String name : wcfUtil.leftOwnWheelChairList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    public List<SelectOption>getWheelChairColapsable(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftWCCollapsibleList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    public List<SelectOption>getwheelChairPower(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftWCPowerList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    public List<SelectOption>getparticipantRequireOxygan(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftOxygenNamesList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    public List<SelectOption>getparticipantHaveSpecialRestrictaion(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftDietaryNameList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    public List<SelectOption>getparticipantHaveSpecialallergies(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftNursingCareList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    public List<SelectOption>getmedicationRequireRefeigeration(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftMedicationList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    public List<SelectOption>getcurrentlyReceiveNursingCare(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftAllergyNamesList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    public List<SelectOption>getanyOtherMedicalSupplies(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftOtherNeedsList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    Public pageReference withOutNavigate(){
        pageReference reference;
        String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        
        if(pageName == 'WishChildForm_VF'){
            reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);  
        }
        if(pageName == 'WishFamilyForm_VF'){
            reference=new PageReference('/apex/WishFamilyForm_VF?id='+currCase.id+'&part='+isParticipants);
            reference.setRedirect(true); 
        }
        if(pageName == 'WishInformationForm_VF'){
            reference=new PageReference('/apex/WishInformationForm_VF?id='+currCase.id+'&part='+isParticipants);
            reference.setRedirect(true);  
        }
        return reference;
    }
    
    public pageReference RetrunToWish(){
        pageReference reference;
        try
        { 
            String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
            if(pageName == 'WishChildForm_VF'){
                saveContact();
            }
            if(pageName == 'WishFamilyForm_VF'){
                saveContact();
            }
            if(pageName == 'WishInformationForm_VF'){
                WishInfoSave();
            }
        }
        Catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() +' >> '+ e.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
        reference=new PageReference('/'+currCase.id);
        reference.setRedirect(true);  
        return reference;
    }
    
    Public String selectedNamesss(List<String> selectedNames)
    {
        Boolean start=True;
        String currString = '';
        String returnName;
        String returnSecondName;
        if(selectedNames != Null) {           
            for(String Str : selectedNames) {
                if(currString == '')
                    currString = str;
                else
                    currString +=','+str;
            }
        }
        return currString ;
    }
    
    public list<String> getTempName(){
        
        if(currWishChild.Requested_Participant_Name_forWheelchair__c != null){
            tempName = (currWishChild.Requested_Participant_Name_forWheelchair__c).split(',');                                  
        }
        return tempName;
    }
    
    public void setTempName(list<string> val){
        this.tempName = val;
    }
    
    public list<String> getCurrentOwnWheelChairList(){
        
        if(currWishChild.Bringing_Own_Wheel_Chair__c != null){
            currentOwnWheelChairList = (currWishChild.Bringing_Own_Wheel_Chair__c).split(',');
        }
        return currentOwnWheelChairList;
    }
    
    public void setCurrentOwnWheelChairList(list<string> val){
        this.currentOwnWheelChairList= val;
    }
    
    Public list<String> getCurrentWCCollapsibleList(){
        if(currWishChild.Name_of_wheelchair_collapsible__c != Null){
            currentWCCollapsibleList = (currWishChild.Name_of_wheelchair_collapsible__c).split(',');
        }
        return currentWCCollapsibleList;
    }
    
    public void setCurrentWCCollapsibleList(list<string> val){
        this.currentWCCollapsibleList = val;
    }
    
    Public list<String> getCurrentWCPowerList(){
        if(currWishChild.Pariticipant_name_havingWheelchair_Power__c != Null){
            currentWCPowerList = (currWishChild.Pariticipant_name_havingWheelchair_Power__c).split(',');
        }
        return currentWCPowerList;
    }
    
    public void setCurrentWCPowerList(list<string> val){
        this.currentWCPowerList = val;
    }
    
    Public list<String> getCurrentOxygenNamesList(){
        if( currWishChild.Requested_Participant_Name_for_Oxygen__c != Null){
            currentOxygenNamesList = ( currWishChild.Requested_Participant_Name_for_Oxygen__c).split(',');
        }
        return currentOxygenNamesList;
    }
    
    public void setCurrentOxygenNamesList(list<string> val){
        this.currentOxygenNamesList = val;
    }
    
    Public list<String> getCurrrentDietaryNameList(){
        if(currWishChild.Participant_Name_for_Dietary_Restriction__c != Null){
            currrentDietaryNameList = (currWishChild.Participant_Name_for_Dietary_Restriction__c).split(',');
        }
        return currrentDietaryNameList;
    }
    
    public void setCurrrentDietaryNameList(list<string> val){
        this.currrentDietaryNameList= val;
    }
    
    Public list<String> getCurrentNursingCareList(){
        if(currWishChild.Names_for_receiving_nursing_care__c != Null){
            currentNursingCareList = (currWishChild.Names_for_receiving_nursing_care__c).split(',');
        }
        return currentNursingCareList;
    }
    
    public void setCurrentNursingCareList(list<string> val){
        this.currentNursingCareList = val;
    }
    
    Public list<String> getCurrentMedicationList(){
        if(currWishChild.Medication_require_refrigeration_name__c != Null){
            currentMedicationList = (currWishChild.Medication_require_refrigeration_name__c).split(',');
        }
        return currentMedicationList;
    }
    
    public void setCurrentMedicationList(list<string> val){
        this.currentMedicationList = val;
    }
    
    Public list<String> getCurrentAllergyNamesList(){
        if(currWishChild.Requested_Participant_Name_for_Allergies__c  != Null){
            currentAllergyNamesList = (currWishChild.Requested_Participant_Name_for_Allergies__c).split(',');
        }
        return currentAllergyNamesList;
    }
    
    public void setCurrentAllergyNamesList(list<string> val){
        this.currentAllergyNamesList = val;
    }
    
    Public list<String> getCurrentOtherNeedsList(){
        if(currWishChild.Requested_Participant_Name_for_OtherNeed__c  != Null){
            currentOtherNeedsList = (currWishChild.Requested_Participant_Name_for_OtherNeed__c ).split(',');
        }
        return currentOtherNeedsList;
    }
    
    public void setCurrentOtherNeedsList(list<string> val){
        this.CurrentOtherNeedsList = val;
    }
}