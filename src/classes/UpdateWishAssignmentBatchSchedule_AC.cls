/*****************************************************************************************
 Created By  : MST
 CreatedDate : 8/31/2016
 Author : MST Solutions
 Description : If wish granter is not assigned for a parent wish particular period of time, then it will send an 
 email notification to Volunteer Manager.
**********************************************************************************************/
global class UpdateWishAssignmentBatchSchedule_AC implements Schedulable{

    global void execute(SchedulableContext SC){
        
        Database.executeBatch(new UpdateWishAssignmentBatch_AC(),25);
        
    }
}