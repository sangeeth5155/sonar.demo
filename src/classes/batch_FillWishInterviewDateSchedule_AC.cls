/*****************************************************************************************
 Created By  : MST
 CreatedDate : 10/20/2016
 Author : MST Solutions
 Description : It will send interview date not set for parent wish Reminder email notification to the case team and create task for paren case.
*********************************************************************************************/
global class batch_FillWishInterviewDateSchedule_AC implements Schedulable{

    global void execute(SchedulableContext SC){
        
        Database.executeBatch(new batch_FillWishInterviewDate(),25);
        
    }
}