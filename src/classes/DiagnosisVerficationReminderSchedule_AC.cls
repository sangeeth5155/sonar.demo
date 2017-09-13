/*****************************************************************************************
 Created By  : MST
 CreatedDate : 09/16/2016
 Author : MST Solutions
 Description : It will send a Part A Reminder email notification to Treating Medical Professional.
*********************************************************************************************/
global class DiagnosisVerficationReminderSchedule_AC implements Schedulable{

    global void execute(SchedulableContext SC){
        
        Database.executeBatch(new DiagnosisVerficationRemainder_AC(),25);
        
    }
}