@isTest
private class Background_CheckBeforeDelete_Test{

    static testMethod void triggerTest1()
    {
        test.starttest();
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
      
        
        Background_check__c backCheck = new Background_check__c();
        backCheck.Date__c = system.today();
        backCheck.Volunteer__c = volunteerContact.id;
        backCheck.current__c = True;
        backCheck.Status__c = 'Approved';
        backCheck.Date_Completed__c = Date.Today();
        insert backCheck;

        Background_Check_File__c aFile=new Background_Check_File__c();
        aFile.File_Name__c='Test File';
        aFile.WIP__c=false;
        aFile.Parent__c=backCheck.Id;
        insert aFile;

        try
        {
            delete backCheck;
           // system.assert(false);
        }
        catch(Exception e)
        {
            //system.assert(true);
        }
        test.stoptest();
    }
}