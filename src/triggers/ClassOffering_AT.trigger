/*****************************************************************************
Created by    : Vennila Paramasivam
Author        : MST
CreatedDate   : 6/17/2016
Description   : This trigger used to validate the Start and End Time. Orientation/Training Start Time 
should not be greater than end time. Since Start & End Time field have been picklist(String) values, we have 
assigned some dummy values for start and end time checking.
*******************************************************************************/

trigger ClassOffering_AT on Class_Offering__c(before insert,before update, after insert, after update) {
    
    Map<String, integer> timeConversion = new Map<String, integer>();
    
    Schema.DescribeFieldResult fieldResult = Class_Offering__c.Start_Time__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
    // Assigning some dummy values for each time.
    integer i = 0;    
    for( Schema.PicklistEntry f : ple)
    {
        i=i+1;
        timeConversion.put(f.getValue(),i);
        
    }   
    
    
    for(Class_Offering__c currRec : Trigger.new)
    {
        Decimal startTime;
        Decimal endTime;
        
        if(currRec.Start_Time__c == Null && currRec.End_Time__c != Null)
            currRec.addError('Please Enter Start Time');
        if(timeConversion.containskey(currRec.Start_Time__c))
        {
            startTime = timeConversion.get(currRec.Start_Time__c);
        }
        if(timeConversion.containskey(currRec.end_Time__c))
        {
            endTime = timeConversion.get(currRec.end_Time__c);
        }
        // comparing start and end time. 
        if((startTime >= endTime) && (StartTime != i))
        {
            currRec.addError('End Time should be greater than start time');
        }
        
        // Start time should not be end of the day.  
        if(startTime == i)
            currRec.addError('Please enter valid Start and End Time');
    }
    
    
    if((Trigger.isInsert || Trigger.isUpdate) && (Trigger.isAfter))
    {
        Map<String, List<Class_Offering__c>> classOfferingMap = new Map<String, List<Class_Offering__c>>();
      
        for(Class_Offering__c currRec : [SELECT id, Chapter__c,OwnerId, Owner.UserRoleId, 
                                       Owner.UserRole.Name FROM Class_Offering__c WHERE Id IN :Trigger.newMap.keySet()])
        {
        
             if(Trigger.isInsert || (Trigger.isUpdate && currRec.OwnerId != Trigger.oldMap.get(currRec.id).OwnerId))
             {
              if(currRec.Owner.UserRole.Name == 'National Staff')
              {
                if(classOfferingMap.containsKey(currRec.Chapter__c))
                {
                    classOfferingMap.get(currRec.Chapter__c).add(currRec);
                }
                else
                    classOfferingMap.put(currRec.Chapter__c,new List<Class_Offering__c>{currRec});
               }          
              }
         }
         
         if(classOfferingMap.size() > 0)
            ChapterStaffRecordSharing_AC.classOfferingSharing(classOfferingMap);
     }
}