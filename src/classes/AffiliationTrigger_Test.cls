@isTest
public class AffiliationTrigger_Test {
	static testmethod void affiliationCreation() {
        Constant_AC  constant = new Constant_Ac();
        Id chapterRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
        
        Account newAccount = new Account();
        newAccount.Name = 'Alabama - Chapter';
        newAccount.RecordTypeId = chapterRecordTypeId;
        insert newAccount;
        
        npe5__Affiliation__c newAffiliation = new npe5__Affiliation__c();
        newAffiliation.npe5__Organization__c = newAccount.Id;
    }
}