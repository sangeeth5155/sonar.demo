/**********************************************************************************************
Created by : Vennila Paramasivam
Author : MST Solutions
Created Date : 08/07/2016
Description : Whenever new Active Dynamic content is creating, It will update the existing record's
active flag as False. 
If the user tries to activate the record, if that chapter already has active record then It will prevent
to update duplicate active record.
************************************************************************************************/

Public class DynamicContentHanlder
{

      static Constant_AC constant = new Constant_AC();
      Static String nationalRT = Schema.Sobjecttype.Dynamic_Content__c.getRecordTypeInfosByName().get(constant.nationalRT).getRecordTypeId();
      
   // Updating Active flag as False for existing records.
    public static void UpdateActiveFlagAsFalse(Set<Id> recordIdsSet,Set<String> chaptersSet,Set<String> recordTypesSet)
    {
       List<Dynamic_Content__c> updateDynamicContentRecList = new List<Dynamic_Content__c>();
     
       for(Dynamic_content__c getContent : [SELECT id,active__c, chapter_Name__c, RecordTypeId FROM Dynamic_Content__c WHERE RecordTypeId IN :recordTypesSet 
                                          AND ID Not IN :recordIdsSet AND active__c = true])
       {
       
           if(getContent.RecordTypeId == nationalRT)
           {
             Dynamic_Content__c newRec = new Dynamic_Content__c();
             newRec.id = getContent.id;
             newRec.active__c = false;
             updateDynamicContentRecList.add(newRec);
           }
           else if(chaptersSet.contains(getContent.chapter_Name__c))
           {
             Dynamic_Content__c newRec = new Dynamic_Content__c();
             newRec.id = getContent.id;
             newRec.active__c = false;
             updateDynamicContentRecList.add(newRec);
           }
       }
       
       if(updateDynamicContentRecList.size() > 0)
           update updateDynamicContentRecList;
      
    }
    
    // Preventing Active Update for duplicate records.
    Public static void PreventingActiveUpdate(Set<String> recordTypesSet, Set<String> chaptersSet, List<Dynamic_Content__c> currRecList)
    {
         Set<String> exRTsSet = new Set<String>();
         Set<String> exChaptersSet = new Set<String>();
       
       for(Dynamic_Content__c exRec : [SELECT Id, Active__c , chapter_Name__c, RecordTypeId FROM Dynamic_Content__c 
                                       WHERE RecordTypeId IN :recordTypesSet AND Active__c = True])
       {
          exRTsSet.add(exRec.recordTypeId);
          exChaptersSet.add(exRec.chapter_Name__c);
       }
       
       for(Dynamic_Content__c currRec : currRecList)
       {
           if(currRec.recordTypeId == nationalRT && exRTsSet.contains(currRec.RecordTypeId))
           {
              currRec.addError('Active National Record already exist');
           }
           else if(exChaptersSet.contains(currRec.chapter_name__c) && exRTsSet.contains(currRec.recordTypeId))
           {
              currRec.addError('Active record already exist for this chapter and record type');
           }
           
       }
    
    }
}