/*******************************************************************************************************************************************
Description : Its Update the volunteer 
********************************************************************************************************************************************/

global class Batch_UpdateVolunteerStatus_AC implements Database.batchable<Sobject>{
    global static List<contact> start(Database.BatchableContext bc){
         Constant_AC  constant = new Constant_AC();
        Id boardmemberRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.boardMemberRT).getRecordTypeId();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        return [SELECT Id,Active_Board_Member__c,Active_Wish_Granter__c,Active_Non_Wish_Granter__c,B_C_Expiration_Date__c,COI_Expiration_Date__c   FROM Contact WHERE RecordtypeId =: volunteerRecordTypeId OR RecordTypeId =: boardmemberRecordTypeId];
    }
    
    global static void execute( Database.BatchableContext bc,List<contact> contactList){
        System.debug('affiliationStatusMap'+contactList);
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        Set<Id> activeConIdSet = new Set<Id>();
        Map<Id,Contact> updateContactMap = new Map<Id,Contact>();
        Set<Id> wishConId = new Set<Id>();
        Map<Id,Date> volunteerLastComDate = New Map<Id,Date>();
        Map<Id,String> affiliationStatusMap = New Map<Id,String>();
        Contact updateCon;
        boolean boardMember,wish,nonwish,singleday;
        //Id WishRT = Schema.SObjectType.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        for(Contact currRec: contactList){
            contactMap.put(currRec.Id,currRec);
        }
        for(npe5__Affiliation__c  currAff : [SELECT Id,npe5__Contact__c,npe5__Status__c   FROM npe5__Affiliation__c WHERE npe5__Contact__c IN: contactMap.KeySet()]){
           activeConIdSet.add(currAff.npe5__Contact__c);
           if(affiliationStatusMap.containsKey(currAff.npe5__Contact__c)) {
               if(currAff.npe5__Status__c == 'Active' && affiliationStatusMap.get(currAff.npe5__Contact__c) != 'Active')
                   affiliationStatusMap.put(currAff.npe5__Contact__c,currAff.npe5__Status__c );
           }
           else
               affiliationStatusMap.put(currAff.npe5__Contact__c,currAff.npe5__Status__c );
        }
        System.debug('affiliationStatusMap'+affiliationStatusMap);
        for(Volunteer_Opportunity__c currRec : [SELECT Volunteer_Name__c,Event_Date__c,Wish__r.Contact.Hidden_Granted_Date__c,RecordTypeId FROM Volunteer_Opportunity__c WHERE Volunteer_Name__c IN:activeConIdSet AND Role__C = 'Single Day Event Volunteer']){
           if(volunteerLastComDate.containsKey(currRec.Volunteer_Name__c)){
               if(volunteerLastComDate.get(currRec.Volunteer_Name__c) < currRec.Event_Date__c )
                   volunteerLastComDate.put(currRec.Volunteer_Name__c,currRec.Event_Date__c);
               else if(volunteerLastComDate.get(currRec.Volunteer_Name__c) < currRec.Wish__r.Contact.Hidden_Granted_Date__c)
                   volunteerLastComDate.put(currRec.Volunteer_Name__c,currRec.Wish__r.Contact.Hidden_Granted_Date__c);
                   
                   
               
           }
           else{
               if(currRec.Event_Date__c == Null && currRec.Wish__r.Contact.Hidden_Granted_Date__c != Null)
                  volunteerLastComDate.put(currRec.Volunteer_Name__c,currRec.Wish__r.Contact.Hidden_Granted_Date__c);
               else if(currRec.Event_Date__c != Null && currRec.Wish__r.Contact.Hidden_Granted_Date__c == Null) 
                   volunteerLastComDate.put(currRec.Volunteer_Name__c,currRec.Event_Date__c);
                   
           }
           //System.debug('volunteerLastComDate'+volunteerLastComDate.get(currRec.Volunteer_Name__c));
               
        }
        for(Volunteer_Roles__c currVolRole : [SELECT id,Role_Name__c,Status__c,Volunteer_Name__c,Chapter_Role__r.Background_Check_Required__c FROM Volunteer_Roles__c WHERE Volunteer_Name__c IN: activeConIdSet]){
            
            if(currVolRole.Role_Name__c == 'Board Member' && affiliationStatusMap.get(currVolRole.Volunteer_Name__c) == 'Active' && currVolRole.Status__c =='Trained' && contactMap.get(currVolRole.Volunteer_Name__c).B_C_Expiration_Date__c > Date.Today() && contactMap.get(currVolRole.Volunteer_Name__c).COI_Expiration_Date__c  > Date.Today()){
                 boardMember = True; 
            }
            else{
                if(updateContactMap.containsKey(currVolRole.Volunteer_Name__c))// && updateContactMap.get(currVolRole.Volunteer_Name__c).Active_Board_Member__c != True) 
                     boardMember = updateContactMap.get(currVolRole.Volunteer_Name__c).Active_Board_Member__c; 
                else
                    boardMember = False; 
            }
           /* if(!updateContactMap.containsKey(currVolRole.Volunteer_Name__c)){
                   updateCon = new Contact();
                   updateCon.Id = currVolRole.Volunteer_Name__c;

               }
               else
                   updateCon = updateContactMap.get(currVolRole.Volunteer_Name__c);
                   
               updateCon.Active_Board_Member__c = True;
               updateContactMap.put(currVolRole.Volunteer_Name__c,updateCon);*/
               
               
             if((currVolRole.Role_Name__c == 'Wish Granter' || currVolRole.Role_Name__c == 'Wish Granter Mentor') && affiliationStatusMap.get(currVolRole.Volunteer_Name__c) == 'Active' && currVolRole.Status__c =='Trained' && contactMap.get(currVolRole.Volunteer_Name__c).B_C_Expiration_Date__c > Date.Today() && contactMap.get(currVolRole.Volunteer_Name__c).COI_Expiration_Date__c  > Date.Today()){
                wish = True; 
            } 
            else{
                 if(updateContactMap.containsKey(currVolRole.Volunteer_Name__c))// && updateContactMap.get(currVolRole.Volunteer_Name__c).Active_Wish_Granter__c != True) 
                     wish = updateContactMap.get(currVolRole.Volunteer_Name__c).Active_Wish_Granter__c;
                 else
                     wish = False;  
            } 
          
           /* if(!updateContactMap.containsKey(currVolRole.Volunteer_Name__c)){
                   updateCon = new Contact();
                   updateCon.Id = currVolRole.Volunteer_Name__c;

               }
               else
                   updateCon = updateContactMap.get(currVolRole.Volunteer_Name__c);
                   
               updateCon.Active_Wish_Granter__c = True;              
               updateContactMap.put(currVolRole.Volunteer_Name__c,updateCon);*/
            
           if( currVolRole.Status__c =='Trained' && affiliationStatusMap.get(currVolRole.Volunteer_Name__c) == 'Active' &&  contactMap.get(currVolRole.Volunteer_Name__c).COI_Expiration_Date__c  > Date.Today() && ((currVolRole.Role_Name__c != 'Board Member' && currVolRole.Role_Name__c != 'Wish Granter' &&  currVolRole.Role_Name__c != 'Wish Granter Mentor') &&
                                                    ((currVolRole.Chapter_Role__r.Background_Check_Required__c == True && contactMap.get(currVolRole.Volunteer_Name__c).B_C_Expiration_Date__c > Date.Today()) || currVolRole.Chapter_Role__r.Background_Check_Required__c == False))){
             /* if(!updateContactMap.containsKey(currVolRole.Volunteer_Name__c)){
                   updateCon = new Contact();
                   updateCon.Id = currVolRole.Volunteer_Name__c;

               }
               else
                   updateCon = updateContactMap.get(currVolRole.Volunteer_Name__c);
                   
               updateCon.Active_Non_Wish_Granter__c = True;
               updateContactMap.put(currVolRole.Volunteer_Name__c,updateCon); */
               nonWish = True;
               
           }
           else{
                if(updateContactMap.containsKey(currVolRole.Volunteer_Name__c))// && updateContactMap.get(currVolRole.Volunteer_Name__c).Active_Non_Wish_Granter__c != True) 
                     nonwish = updateContactMap.get(currVolRole.Volunteer_Name__c).Active_Non_Wish_Granter__c; 
                else
                    nonWish = False; 
           }
           
           if(currVolRole.Role_Name__c == 'Single Day Event Volunteer' && affiliationStatusMap.get(currVolRole.Volunteer_Name__c) == 'Active' && volunteerLastComDate.containsKey(currVolRole.Volunteer_Name__c) && volunteerLastComDate.get(currVolRole.Volunteer_Name__c) > system.Today()-365){
               
                 /*  if(!updateContactMap.containsKey(currVolRole.Volunteer_Name__c)){
                       updateCon = new Contact();
                       updateCon.Id = currVolRole.Volunteer_Name__c;

                   }
                   else
                       updateCon = updateContactMap.get(currVolRole.Volunteer_Name__c);
                       
                   updateCon.Active_Single_Day_Event_Volunteer__c = True;
                   updateContactMap.put(currVolRole.Volunteer_Name__c,updateCon);   */  
                   singleDay = True;
            }
              else{
                   if(updateContactMap.containsKey(currVolRole.Volunteer_Name__c))             
                       singleDay = updateContactMap.get(currVolRole.Volunteer_Name__c).Active_Single_Day_Event_Volunteer__c ;
                    else
                       singleDay = False;
           }
           
             if(!updateContactMap.containsKey(currVolRole.Volunteer_Name__c)){
                       updateCon = new Contact();
                       updateCon.Id = currVolRole.Volunteer_Name__c;

             }
            else
               updateCon = updateContactMap.get(currVolRole.Volunteer_Name__c);
               
               updateCon.Active_Board_Member__c = boardmember;
               updateCon.Active_Wish_Granter__c = wish;
               updateCon.Active_Non_Wish_Granter__c = nonWish;
               updateCon.Active_Single_Day_Event_Volunteer__c = singleDay;
               updateContactMap.put(currVolRole.Volunteer_Name__c,updateCon);               
    
        }
        
                 
        
        if(updateContactMap.Size() > 0)
             Update  updateContactMap.Values();
    }
    
    global static void finish(Database.BatchableContext bc){
    }
}