/*****************************************************************************************************************
Author      : MST Solutions
Date        : 10/26/2016
Description : This class contains test method for Account object
*******************************************************************************************************************/
@isTest
public class AccountFile_AT_Test {
    static testmethod void createAccountFile() {
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        cg__AccountFile__c accountFile = OrientationandTrainingUtil.createAccountFileRecord(chapterAccount.Id);
    }
}