/*****************************************************************************************************************
Author      : MST Solutions
Date        : 10/26/2016
Description : This class contains test method for Contact object
*******************************************************************************************************************/
@isTest
public class ContactFile_AT_Test {
    @testSetup 
    static void setup() 
    {
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon();
        cg__ContactFile__c newFileRecord = OrientationandTrainingUtil.createContactFileRecord(wishChild.Id);
        
    }
    /*static testmethod void createContactFile() {
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon();
        cg__ContactFile__c newFileRecord = OrientationandTrainingUtil.createContactFileRecord(wishChild.Id);
        cg__ContactFile__c newFileRecord1 = OrientationandTrainingUtil.createContactFileRecord(wishChild.Id);
    }
    
    static testmethod void createContactDocumentFile() {
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon();
        cg__ContactFile__c newFileRecord = OrientationandTrainingUtil.createContactDocumentFileRecord(wishChild.Id);
        cg__ContactFile__c newFileRecord1 = OrientationandTrainingUtil.createContactDocumentFileRecord(wishChild.Id);

    }*/
    
}