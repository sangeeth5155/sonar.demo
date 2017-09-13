/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 11/15/2016
Description : DocusignRecipientTrigger_AT is used to update the publicity field from contact when the ParentGuardian are signed the docusign document.
*****************************************************************************************************/

Trigger DocusignRecipientTrigger_AT on dsfs__DocuSign_Recipient_Status__c (After update,After insert) {
    
    if(Trigger.isAfter){
        Map<String,String> nameMap = new Map<String,String>();
        Set<Id> dsfsStatusSet = new Set<Id>();
        Set<Id> WishIdSet = new Set<Id>();
        Set<Id> deliveredWishIdSet = new Set<Id>();
        Set<Id> completedWishIdSet = new Set<Id>();
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> deliveredSet = new Set<Id>();
        Set<String> deliveredNameStringSet = new Set<String>();
        List<Wish_Child_Form__c> deliverednameList = new List<Wish_Child_Form__c>();
        Set<Id> completedIdSet = new Set<Id>();
        Set<String> completedNameString = new Set<String>();
        String subject;
        Map<Id,Wish_Child_Form__c > updateWishPaperMap = new Map<Id,Wish_Child_Form__c>();
        for(dsfs__DocuSign_Recipient_Status__c  dsfs : Trigger.new){
            if(dsfs.dsfs__Parent_Status_Record__c != Null && dsfs.dsfs__Recipient_Status__c == 'Completed' ){
                dsfsStatusSet.add(dsfs.dsfs__Parent_Status_Record__c);
                nameMap.put(dsfs.Name,dsfs.dsfs__DocuSign_Recipient_Email__c);
            }
            
            if(dsfs.dsfs__Parent_Status_Record__c != Null && (dsfs.dsfs__Recipient_Status__c == 'Delivered') ){
                deliveredSet.add(dsfs.dsfs__Parent_Status_Record__c);
                deliveredNameStringSet.add(dsfs.Name);
                
            }
            
            if(dsfs.dsfs__Parent_Status_Record__c != Null && (dsfs.dsfs__Recipient_Status__c == 'Completed' && trigger.oldMap.get(dsfs.Id).dsfs__Recipient_Status__c == 'Delivered')){
                completedIdSet.add(dsfs.dsfs__Parent_Status_Record__c);
                completedNameString.add(dsfs.Name);
            }
        } 
        
        if(dsfsStatusSet.size() > 0){
            for(dsfs__DocuSign_Status__c dsfsStatusRec : [SELECT Id,dsfs__Case__c,dsfs__Subject__c,dsfs__Case__r.ContactId,dsfs__Case__r.LiabilitySignerMapKeyPair__c FROM dsfs__DocuSign_Status__c WHERE Id IN:dsfsStatusSet 
                                                          AND dsfs__Case__c != Null AND (dsfs__Subject__c =: 'Signature Required - Liability And Publicity Release Form' OR dsfs__Subject__c =: 'Signature Required - Wish Paper Packet')]){
                                                              
                                                              WishIdSet.add(dsfsStatusRec.dsfs__Case__c);
                                                              subject = dsfsStatusRec.dsfs__Subject__c;
                                                          }
        }
        
        if(deliveredSet.size() > 0){
            for(dsfs__DocuSign_Status__c dsfsStatusRec : [SELECT Id,dsfs__Case__c,dsfs__Subject__c,dsfs__Case__r.ContactId,dsfs__Case__r.LiabilitySignerMapKeyPair__c FROM dsfs__DocuSign_Status__c WHERE Id IN: deliveredSet
                                                          AND dsfs__Case__c != Null AND dsfs__Subject__c =: 'Signature Required - Liability And Publicity Release Form']){
                                                              
                                                              deliveredWishIdSet.add(dsfsStatusRec.dsfs__Case__c);
                                                              
                                                          }
            
            system.debug('@@@ deliveredWishIdSet@@@'+deliveredWishIdSet);
            
        }
        
        if(completedIdSet.size() > 0){
             for(dsfs__DocuSign_Status__c dsfsStatusRec : [SELECT Id,dsfs__Case__c,dsfs__Subject__c,dsfs__Case__r.ContactId,dsfs__Case__r.LiabilitySignerMapKeyPair__c FROM dsfs__DocuSign_Status__c WHERE Id IN: completedIdSet
                                                          AND dsfs__Case__c != Null AND dsfs__Subject__c =: 'Signature Required - Liability And Publicity Release Form']){
                                                              
                                                              completedWishIdSet.add(dsfsStatusRec.dsfs__Case__c);
                                                              
             }
        }
        
        if(completedWishIdSet.size() > 0){
             for(Wish_Child_Form__c dbWishPaperCase : [SELECT Id,Hidden_Wish_Fmaily_Contact_Name__c,Wish_Liability_Envolep__c,Delivered_Hidden_Envelop_Id__c,LiabilitySignerMapKeyPair__c,Delivered_LiabilitySignerMapKeyPair__c  From Wish_Child_Form__c WHERE Case__c =: completedWishIdSet]){
                
                for(String processString : dbWishPaperCase.Hidden_Wish_Fmaily_Contact_Name__c.split('#')){
                      if(completedNameString.contains(processString)){
                        dbWishPaperCase.Wish_Liability_Envolep__c = dbWishPaperCase.Delivered_Hidden_Envelop_Id__c ; 
                        dbWishPaperCase.Delivered_Hidden_Envelop_Id__c = null;
                        dbWishPaperCase.LiabilitySignerMapKeyPair__c = dbWishPaperCase.Delivered_LiabilitySignerMapKeyPair__c ;
                        dbWishPaperCase.Delivered_LiabilitySignerMapKeyPair__c = null;
                     }
                    
                }
                deliverednameList.add(dbWishPaperCase);
            }
            system.debug('@@@ deliverednameList @@@'+deliverednameList);
            if(deliverednameList.size() > 0)
            update deliverednameList;
        }
        
        if(deliveredWishIdSet.size() > 0){
            for(Wish_Child_Form__c dbWishPaperCase : [SELECT Id,Hidden_Wish_Fmaily_Contact_Name__c,Wish_Liability_Envolep__c,Delivered_Hidden_Envelop_Id__c,LiabilitySignerMapKeyPair__c,Delivered_LiabilitySignerMapKeyPair__c  From Wish_Child_Form__c WHERE Case__c =: deliveredWishIdSet]){
                
                for(String processString : dbWishPaperCase.Hidden_Wish_Fmaily_Contact_Name__c.split('#')){
                    if(deliveredNameStringSet.contains(processString)){
                        dbWishPaperCase.Delivered_Hidden_Envelop_Id__c = dbWishPaperCase.Wish_Liability_Envolep__c; 
                        dbWishPaperCase.Wish_Liability_Envolep__c = null;
                        dbWishPaperCase.Delivered_LiabilitySignerMapKeyPair__c = dbWishPaperCase.LiabilitySignerMapKeyPair__c;
                        dbWishPaperCase.LiabilitySignerMapKeyPair__c = null;
                    }
                    
                }
                deliverednameList.add(dbWishPaperCase);
            }
            system.debug('@@@ deliverednameList @@@'+deliverednameList);
            if(deliverednameList.size() > 0)
            update deliverednameList;
        }
        
        if(WishIdSet.Size() > 0){
            Wish_Child_Form__c newWishChildForm = new Wish_Child_Form__c ();
            for(Wish_Child_Form__c dbWishPaperCase : [SELECT Id,Hidden_Email_List__c,Hidden_Name_List__c,Hidden_Contact_Name__c,Signers__c,Case__c,Case__r.contactId From Wish_Child_Form__c WHERE Case__c =: WishIdSet]){
                
                if(subject == 'Signature Required - Liability And Publicity Release Form'){
                    
                    for(String processString : nameMap.keyset()){
                        if(dbWishPaperCase.Hidden_Name_List__c == Null && dbWishPaperCase.Hidden_Email_List__c == Null){
                            dbWishPaperCase.Hidden_Name_List__c = processString;
                            dbWishPaperCase.Hidden_Email_List__c = nameMap.get(processString);
                            dbWishPaperCase.Id = dbWishPaperCase.Id;
                            updateWishPaperMap.put(dbWishPaperCase.Id,dbWishPaperCase);
                        }
                        else{
                            dbWishPaperCase.Hidden_Name_List__c  += '#'+processString;
                            dbWishPaperCase.Hidden_Email_List__c += '#'+nameMap.get(processString);
                            dbWishPaperCase.Id = dbWishPaperCase.Id;
                            updateWishPaperMap.put(dbWishPaperCase.Id,dbWishPaperCase);
                        }
                    }
                    contactIdSet.add(dbWishPaperCase.Case__r.contactId);
                }
                
                if(subject == 'Signature Required - Wish Paper Packet'){
                    
                    for(String processString : nameMap.keyset()){
                        if(dbWishPaperCase.Hidden_Contact_Name__c == Null && dbWishPaperCase.Signers__c == Null){
                            dbWishPaperCase.Hidden_Contact_Name__c = processString;
                            dbWishPaperCase.Signers__c = processString;
                            dbWishPaperCase.Id = dbWishPaperCase.Id;
                            updateWishPaperMap.put(dbWishPaperCase.Id,dbWishPaperCase);
                        }
                        else{
                            dbWishPaperCase.Hidden_Contact_Name__c += '#'+processString;
                            dbWishPaperCase.Signers__c += '#'+processString;
                            dbWishPaperCase.Id = dbWishPaperCase.Id;
                            updateWishPaperMap.put(dbWishPaperCase.Id,dbWishPaperCase);
                        }
                    }
                }
            }
            
            update updateWishPaperMap.values();
        }
        
        If(contactIdSet.size() > 0){
            List<Contact> updateContactList = new List<Contact>();
            for(Contact dbContact : [SELECT Id,Name,Email,Publicity_OK__c FROM Contact WHERE Id IN: contactIdSet]){
                dbContact.Publicity_OK__c = 'Yes';
                updateContactList.add(dbContact);
            }
            If(updateContactList.size() > 0)
                update updateContactList;
        }
       
    } 
}