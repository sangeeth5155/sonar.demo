/*****************************************************************************
Author : MST Solutions
CreateDate : 14/11/2016
Description : WishLiabilityMinorParticipant_AC_Test is used to increase the code coverage for WishLiabilityForm_AC.
******************************************************************************/
 @isTest
public class WishLiabilityMinorParticipant_AC_Test { 
 
 /*This method is used to cover the code coverage of Constructor method*/
    static testMethod void CalltheConstructorMethod(){ 
      Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
      Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
      wishChild.Hidden_Minor_Participant__c = 'kanagaraj,Kesav';
      update  wishChild;
      case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
      OrientationandTrainingUtil.insertDocusignSetting();
      ApexPages.StandardController sc = new ApexPages.StandardController(wish);
      PageReference pageRef = Page.WishLiabilityMinorParticipant_VF;
      pageRef.getParameters().put('id',String.valueOf(wish.Id));
      Test.setCurrentPage(pageRef);
      WishLiabilityMinorParticipant_AC wishLiabilityIns = new WishLiabilityMinorParticipant_AC(sc);
      wishLiabilityIns.AddRow();
      wishLiabilityIns.SaveContact();
      wishLiabilityIns.cancel();
      wishLiabilityIns.preview();
      wishLiabilityIns.DisplayMessage();   
      system.AssertEquals(wishChild.Id,wish.ContactId); 
     }
      
      /*This method is used to cover the code coverage for When the Publicity ok is selected */
      static testMethod void PublicityOk(){ 
      Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
      Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
      wishChild.Hidden_Minor_Participant__c = 'kanagaraj,Kesav';
      wishChild.Publicity_OK__c = 'YES';
      update  wishChild;
      case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
      OrientationandTrainingUtil.insertDocusignSetting();
      ApexPages.StandardController sc = new ApexPages.StandardController(wish);
      PageReference pageRef = Page.WishLiabilityMinorParticipant_VF;
      pageRef.getParameters().put('id',String.valueOf(wish.Id));
      Test.setCurrentPage(pageRef);
      WishLiabilityMinorParticipant_AC wishLiabilityIns = new WishLiabilityMinorParticipant_AC(sc);
      wishLiabilityIns.AddRow();
      wishLiabilityIns.SaveContact();
      wishLiabilityIns.cancel();
      wishLiabilityIns.preview();
      wishLiabilityIns.DisplayMessage();   
      Map<String,String> sendEmailMap = new Map<String,String>();
      sendEmailMap.put('MAWAFirstName MAWALastName0', 'vennila@mstsolutions.com');
      sendEmailMap.put('MAWAFirstName MAWALastName1', 'kesavkumar@mstsolutions.com');
      sendEmailMap.put('MAWAFirstName MAWALastName2', 'kanagaraj@mstsolutions.com');
      Test.StartTest();
      Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
      wishLiabilityIns.SendtoEmail();
      //wishLiabilityIns.CallOuttoDocusign(sendEmailMap,wish.Id,'Yes');
     Test.StopTest();
     system.AssertEquals(wishChild.Id,wish.ContactId);   
     }
    /*This method is used to cover the code coverage for When the Publicity cancel is selected */
   static testMethod void PublicityCancel(){ 
      Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
      Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
      wishChild.Hidden_Minor_Participant__c = 'kanagaraj,Kesav';
      wishChild.Publicity_OK__c = 'No';
      update  wishChild;
      case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
      OrientationandTrainingUtil.insertDocusignSetting();
      ApexPages.StandardController sc = new ApexPages.StandardController(wish);
      PageReference pageRef = Page.WishLiabilityMinorParticipant_VF;
      pageRef.getParameters().put('id',String.valueOf(wish.Id));
      Test.setCurrentPage(pageRef);
      WishLiabilityMinorParticipant_AC wishLiabilityIns = new WishLiabilityMinorParticipant_AC(sc);
      wishLiabilityIns.AddRow();
      wishLiabilityIns.SaveContact();
      wishLiabilityIns.cancel();
      wishLiabilityIns.preview();
      //wishLiabilityIns.removeContact();
      wishLiabilityIns.DisplayMessage();   
      Map<String,String> sendEmailMap = new Map<String,String>();
      sendEmailMap.put('MAWAFirstName MAWALastName0', 'vennila@mstsolutions.com');
      sendEmailMap.put('MAWAFirstName MAWALastName1', 'kesavkumar@mstsolutions.com');
      sendEmailMap.put('MAWAFirstName MAWALastName2', 'kanagaraj@mstsolutions.com');
      Test.StartTest();
      Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
      wishLiabilityIns.SendtoEmail();
      //wishLiabilityIns.CallOuttoDocusign(sendEmailMap,wish.Id,'Yes');
     Test.StopTest();  
     system.AssertEquals(wishChild.Id,wish.ContactId); 
     }
   
   
   
 }