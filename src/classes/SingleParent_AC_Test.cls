/*****************************************************************************
Author : MST Solutions
CreateDate : 03/25/2016
Description : SingleParent_AC_Test is used to increase the code coverage for SingleParent_AC.
******************************************************************************/

@isTest
Public class SingleParent_AC_Test{

     public static testMethod void createParentCase(){
      
       Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
       Contact contactWishParent =  OrientationandTrainingUtil.CreateWishFamily();
       npe4__Relationship__c relationShip = OrientationandTrainingUtil.relationshipChild(contactWishChild.id,contactWishParent.id);
       npe4__Relationship__c  newRelationShip = new npe4__Relationship__c();
       newRelationShip.Id = relationShip.Id;
       newRelationShip.npe4__Type__c = 'Father';
       Update newRelationShip;
       Case caseId = OrientationandTrainingUtil.CreateParentCaseWithTravel(contactWishChild.Id);
       OrientationandTrainingUtil.insertDocusignSetting();
       ApexPAges.StandardController sc = new ApexPages.StandardController(caseId);
       PageReference pageRef = Page.SingleForm_VF;
       pageRef.getParameters().put('id',String.valueOf(caseId.Id));
       Test.setCurrentPage(pageRef);
       SingleParent_AC absentIns = new SingleParent_AC(sc);
       Test.StartTest();
       Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
       absentIns.CallouttoDocusign();
       absentIns.cancel();
       Test.StopTest();
      
     }
     public static testMethod void createParentCaseWithWishChild(){
      
       Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
       Contact contactWishParent =  OrientationandTrainingUtil.CreateWishFamily();
       npe4__Relationship__c relationShip = OrientationandTrainingUtil.relationshipChild(contactWishChild.id,contactWishParent.id);
       npe4__Relationship__c  newRelationShip = new npe4__Relationship__c();
       newRelationShip.Id = relationShip.Id;
       newRelationShip.npe4__Type__c = 'Mother';
       Update newRelationShip;
       Case caseId = OrientationandTrainingUtil.CreateParentCaseWithTravel(contactWishChild.Id);
       OrientationandTrainingUtil.insertDocusignSetting();
       ApexPAges.StandardController sc = new ApexPages.StandardController(caseId);
       PageReference pageRef = Page.SingleForm_VF;
       pageRef.getParameters().put('id',String.valueOf(caseId.Id));
       Test.setCurrentPage(pageRef);
       SingleParent_AC absentIns = new SingleParent_AC(sc);
       Test.StartTest();
       Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
       absentIns.CallouttoDocusign();
       absentIns.cancel();
       Test.StopTest();
      
     }
     public static testMethod void createParentCaseWithWishFamily(){
      
       Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
       Contact contactWishParent =  OrientationandTrainingUtil.CreateWishFamily();
       npe4__Relationship__c relationShip = OrientationandTrainingUtil.relationshipChild(contactWishChild.id,contactWishParent.id);
       npe4__Relationship__c  newRelationShip = new npe4__Relationship__c();
       newRelationShip.Id = relationShip.Id;
       newRelationShip.npe4__Type__c = 'Legal Guardian';
       Update newRelationShip;
       Case caseId = OrientationandTrainingUtil.CreateParentCaseWithTravel(contactWishChild.Id);
       OrientationandTrainingUtil.insertDocusignSetting();
       ApexPAges.StandardController sc = new ApexPages.StandardController(caseId);
       PageReference pageRef = Page.SingleForm_VF;
       pageRef.getParameters().put('id',String.valueOf(caseId.Id));
       Test.setCurrentPage(pageRef);
       SingleParent_AC absentIns = new SingleParent_AC(sc);
       Test.StartTest();
       Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
       absentIns.CallouttoDocusign();
       absentIns.cancel();
       Test.StopTest();
      
     }
     
 }