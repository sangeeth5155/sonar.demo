global class batch_UpdateVolunteerLastEngage implements Database.Batchable<AggregateResult>{ 

  
     
    
     global Iterable<AggregateResult> start(Database.BatchableContext bc){ 
     
         list<AggregateResult> nonWishEventList = [SELECT Max(Event_date__c) eventDate,Volunteer_Name__c FROM Volunteer_Opportunity__c
                                 where Event_date__c < :Date.Today() AND recordtype.name = 'Non Wish & Event' 
                                 group by Volunteer_Name__c];
        
         return nonWishEventList;                      
                                
     }
     
    
     global void execute(Database.BatchableContext bc, list<AggregateResult> nonWishEventList){
     
            
             List<Contact> updateContactList = new List<Contact>();
              
             Map<String, Date> eventDateMap = new Map<String,Date>();
             
             for(AggregateResult getRec :nonWishEventList)  
             {
                 String currVol = String.valueof(getRec.get('Volunteer_Name__c'));
                 Date eventDate = Date.ValueOf(getRec.get('eventDate'));
                 eventDateMap.put(currVol,eventDate);
             }
               
             for(Contact currCon : [SELECT Id,Date_of_last_engagement__c  FROM Contact WHERE Id IN :eventDateMap.keySet()])
             {
                 if(currCon.Date_of_last_engagement__c == Null || eventDateMap.get(currCon.id) > currCon.Date_of_last_engagement__c )
                 {
                      Contact currContact = new Contact();
                      currContact.id = currcon.id;
                      currContact.Date_of_last_engagement__c = eventDateMap.get(currCon.id);
                      updateContactList.add(currContact);
                 }
             }
             
             if(updateContactList.size() > 0)
                 update updateContactList;
             
             
     }


  global void finish(Database.BatchableContext bc){
  }


}