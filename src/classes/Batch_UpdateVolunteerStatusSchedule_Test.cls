@istest
public class Batch_UpdateVolunteerStatusSchedule_Test{
    static testmethod void scheduleStatusUpdate() {
        Test.startTest();
        
        String CRON_EXP = '0 0 0/12 1/1 * ? *';
        String jobId = System.schedule('Volunteer Status', CRON_EXP, new Batch_UpdateVolunteerStatusSchedule_AC() );   
        Test.stopTest();
    }

}