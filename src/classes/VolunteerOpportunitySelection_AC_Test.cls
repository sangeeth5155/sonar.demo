@isTest
private class VolunteerOpportunitySelection_AC_Test{

private static testmethod void createVolunterSelection(){
    
        Constant_AC  constant = new Constant_Ac(); 
        Id nonWishEvents = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.nonWishEventRT).getRecordTypeId();
        Id wishEvents = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
       
        Role__c currRole = OrientationandTrainingUtil.createRole();
        Role__c currNonWishRole = OrientationandTrainingUtil.createNonWishRole();
        Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.Id);
        Chapter_Role__c  currNonWishChapRole = OrientationandTrainingUtil.createChapter(acc.id,currNonWishRole.Id);
        Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.Id);
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case newParentWish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        User currUser;
        System.RunAs(new User(Id = UserInfo.getUserId())) {
           
            currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
            
        }
         Volunteer_Opportunity__c wishVolunteerOpportunity = OrientationandTrainingUtil.CreateNewWishVolunteerOpportunity(acc.Id,currChapRole.Id,newParentWish.Id);
            Volunteer_Opportunity__c dbVolOpp = new Volunteer_Opportunity__c();
            dbVolOpp.Id = wishVolunteerOpportunity.Id;
            dbVolOpp.Volunteer_Name__c = con.Id;
            dbVolOpp.Status__c = 'Approved';
            update dbVolOpp;
            
           system.RunAs(currUser){
           VolunteerOpportunitySelection_AC volunteeerController = new VolunteerOpportunitySelection_AC();
            volunteeerController.createTimeSheet();
            volunteeerController.CreateNewTimeSheet();
            volunteeerController.DisplayError();
            VolunteerOpportunitySelection_AC.volunteerWrapper newWrapper = new VolunteerOpportunitySelection_AC.volunteerWrapper();
            newWrapper.recordSelected = false;
            newWrapper.volOpp = dbVolOpp;
            }
           
           
        
        //volunteeerController.volunteerWrapper();
      //volunteeerController.createTimeSheet();
        //volunteeerController.CreateNewTimeSheet();
}
}