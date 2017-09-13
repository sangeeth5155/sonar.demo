trigger UpdateWishFamily_AT on Wish_Child_Form__c (Before insert,Before update, After update) {

    if(Trigger.isBefore && Trigger.isInsert){
     for(Wish_Child_Form__c dbWishchildForm : trigger.new){
           if(dbWishchildForm.Availability_Time_Period_1__c == 'null/null')
            dbWishchildForm.Availability_Time_Period_1__c = '';
            
            if(dbWishchildForm.Availability_Time_Period_2__c == 'null/null')
            dbWishchildForm.Availability_Time_Period_2__c = '';
            
            if(dbWishchildForm.Availability_Time_Period_3__c == 'null/null')
            dbWishchildForm.Availability_Time_Period_3__c = '';
     }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        Map<Id,String> wishMap = new Map<Id,String>();
        List<Contact> updateContactList = new List<Contact>();
        for(Wish_Child_Form__c dbWishchildForm : trigger.new){
            
            
            if(dbWishchildForm.Participant_require_a_wheelchair__c == 'No')
            dbWishchildForm.Requested_Participant_Name_forWheelchair__c = null;
            
            if(dbWishchildForm.Will_your_family_bring_wheelchair__c == 'No')
            dbWishchildForm.Bringing_Own_Wheel_Chair__c = null;
            
            if(dbWishchildForm.Is_the_wheelchair_collapsible__c == 'No')
            dbWishchildForm.Name_of_wheelchair_collapsible__c = null;
            
            if(dbWishchildForm.Is_the_wheelchair_power__c == 'No')
            dbWishchildForm.Pariticipant_name_havingWheelchair_Power__c = null;
            
            if(dbWishchildForm.Participant_require_oxygen_how_often__c == 'No')
            dbWishchildForm.Requested_Participant_Name_for_Oxygen__c = null;
            
            if(dbWishchildForm.Participant_dietary_restrictions__c == 'No')
            dbWishchildForm.Participant_Name_for_Dietary_Restriction__c = null;
            
            if(dbWishchildForm.Participant_have_allergies_to_food__c == 'No')
            dbWishchildForm.Participant_have_allergies_to_food_Note__c= null;
            
            if(dbWishchildForm.Medication_require_refrigeration__c == 'No')
            dbWishchildForm.Medication_require_refrigeration_name__c = null;
            
            if(dbWishchildForm.Wish_child_receive_nursing_care__c == 'No')
            dbWishchildForm.Wish_child_receive_nursing_care_Note__c= null;
            
            if(dbWishchildForm.Participant_require_medical_supplies__c == 'No')
            dbWishchildForm.Requested_Participant_Name_for_OtherNeed__c  = null;
            
            if(dbWishchildForm.Availability_Time_Period_1__c == 'null/null')
            dbWishchildForm.Availability_Time_Period_1__c = '';
            
            if(dbWishchildForm.Availability_Time_Period_2__c == 'null/null')
            dbWishchildForm.Availability_Time_Period_2__c = '';
            
            if(dbWishchildForm.Availability_Time_Period_3__c == 'null/null')
            dbWishchildForm.Availability_Time_Period_3__c = '';
            
            if(dbWishchildForm.Participant_Names__c == Null)
            dbWishchildForm.Hidden_Same_as_Family__c = false;
        }
        
    }
    
    /*if(Trigger.isAfter && Trigger.isUpdate){
        Map<Id,String> wishMap = new Map<Id,String>();
        List<Contact> updateContactList = new List<Contact>();
        for(Wish_Child_Form__c dbWishchildForm : trigger.new){
        
           if(trigger.oldMap.get(dbWishchildForm.Id).RelatedContact__c != dbWishchildForm.RelatedContact__c){
                wishMap.Put(dbWishchildForm.Case__c,dbWishchildForm.RelatedContact__c);
               
            }
         }
         
         if(wishMap.size() > 0){
         for(Case dbWishFamilyCase : [Select Id,ContactId from Case where Id IN: wishMap.KeySet()]){
              if(wishMap.containsKey(dbWishFamilyCase.Id)){
                 contact updateContact = new Contact();
                 updateContact.Id = dbWishFamilyCase.ContactId;
                 updateContact.RelatedContacts__c = wishMap.get(dbWishFamilyCase.Id); 
                 updateContactList.add(updateContact);
             }
         }
        }
        
        if(updateContactList.size() > 0)
        update updateContactList;
    }*/
}