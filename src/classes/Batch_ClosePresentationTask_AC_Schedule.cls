/*****************************************************************************************
 Created By  : MST
 CreatedDate : 4/21/2017
 Author : MST Solutions
 Description :This is a Schedule class for Batch_ClosePresentationTask_AC 
**********************************************************************************************/
global class Batch_ClosePresentationTask_AC_Schedule implements Schedulable{
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new Batch_ClosePresentationTask_AC ());
    }
}