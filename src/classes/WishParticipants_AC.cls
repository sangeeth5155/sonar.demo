Public class WishParticipants_AC
{
   Case currCase = new Case();
   public WishParticipants_AC(Apexpages.standardController controller)
   {
     currCase = (Case)controller.getRecord();
     currCase = [SELECT id,ContactId FROM Case WHERE Id = :currCase.id limit 1];
      
   }

   public list<npe4__Relationship__c> getParticipantsConList()
   {
       
        List<npe4__Relationship__c> relationshipList = [SELECT id,npe4__RelatedContact__c,npe4__RelatedContact__r.Id, npe4__RelatedContact__r.FirstName,
                                                        npe4__RelatedContact__r.LastName,npe4__RelatedContact__r.Middle_Name__c,
                                                        npe4__RelatedContact__r.Birthdate,npe4__Type__c,
                                                        npe4__RelatedContact__r.Current_Age__c,Parent_Legal_Guardian__c,
                                                        Medical_Needs__c,Non_Comped__c FROM npe4__Relationship__c WHERE 
                                                        Wish_Participant__c = True AND npe4__Contact__c =: currCase.ContactId];
                                                        
                                                        
        //System.debug('Related Contact Id-'+relationshipList[0].npe4__RelatedContact__c); 
        return relationshipList;
   
   }
}