Public Class WishChildFormUtil
{
   
    Public Boolean displayTrainingAck {get;set;}
    public Case currCase{get;set;}
    public List<SelectOption> multiPickoptions {get;set;}
    String caseId {get;set;}
    String Participants {get;set;}
    public List<Contact> wishFamilyContactList {get;set;}
    public List<Contact> wishParticipantsContactList {get;set;}
    public Id wishFamilyDT;
    public List<Contact> deleteContactList = new List<Contact>();
    Public String caseTeamMemberNo1{get;set;}
    Public String caseTeamMemberNo2{get;set;}
    
    public list<Wish_Child_Form__c > wishChildList {get;set;}
    public List<WrapperClass> wishFamilyWrapList{get;set;}
    public List<WrapperClass> wishParticipantList{get;set;}
    public List<DriverWrapper> driverWrapperCls{get;set;}
    public Map<String,String> emailMap{get;set;}
    public List<String> emailList{get;set;}
   
    public Map<String,String> selectedMailMap{get;set;}
    public String SignNowName{get;set;}
    public String SignNowEmail{get;set;}
       /********************** Multiselect picklist variables **********************************/
    public List<String> leftDietaryNameList{get;set;}
    public List<String> righttDietaryNameList{get;set;}
    public List<String> currrentDietaryNameList{get;set;}
    public String currrentDietaryName{get;set;}
    public Set<String> dietaryNamesSet  = new Set<String>();
    
    
    public List<String> leftWCNamesList{get;set;}
    public List<String> rightWCNamesList{get;set;}
    public List<String> currentWCNamesList{get;set;}
    public Set<String> WCNamesSet  = new Set<String>();
    public String currentWCName{get;set;}
    
    public List<String> leftOxygenNamesList{get;set;}
    public List<String> rightOxygenNamesList{get;set;}
    public List<String> currentOxygenNamesList{get;set;}
    public String currentOxygenNames{get;set;}
    public Set<String> OxygenNamesSet  = new Set<String>();
    
    public List<String> leftAllergyNamesList{get;set;}
    public List<String> rightAllergyNamesList{get;set;}
    public List<String> currentAllergyNamesList{get;set;}
    public String currentAllergyNames{get;set;}
    public Set<String> AllergyNamesSet  = new Set<String>();
    
    public List<String> leftOtherNeedsList{get;set;}
    public List<String> righttOtherNeedsList{get;set;}
    public List<String> currentOtherNeedsList{get;set;}
    public String currentOtherNeeds{get;set;}
    public Set<String> OtherNeedsSet  = new Set<String>();
    
    public List<String> leftOwnWheelChairList{get;set;}
    public List<String> rightOwnWheelChairList{get;set;}
    public List<String> currentOwnWheelChairList{get;set;}
    public Set<String> ownWheelChairNamesSet = new Set<String>();
    public String currentOwnWheelChair{get;set;}
     
    public List<String> leftWCCollapsibleList{get;set;}
    public List<String> rightWCCollapsibleList{get;set;}
    public List<String> currentWCCollapsibleList{get;set;}
    public String currentWCCollapsible{get;set;}
    public Set<String> WCCollapsiblesSet  = new Set<String>();
    
    
    public List<String> leftWCPowerList{get;set;}
    public List<String> rightWCPowerList{get;set;}
    public List<String> currentWCPowerList{get;set;}
    public String currentWCPower{get;set;}
    public Set<String> WCPowerNamesSet= new Set<String>();
    
    public List<String> leftMedicationList{get;set;}
    public List<String> rightMedicationList{get;set;}
    public List<String> currentMedicationList{get;set;}
    public String currentMedication{get;set;}
    public Set<String> MedicationNamesSet  = new Set<String>();
    
    public List<String> leftNursingCareList{get;set;}
    public List<String> rightNursingCareList{get;set;}
    public List<String> currentNursingCareList{get;set;}
    public String currentNursingCare{get;set;}
    public Set<String> nursingCaresSet  = new Set<String>();
    
    public String availableMonth1{get;set;}
    public String availableMonth2{get;set;}
    public String availableMonth3{get;set;}
    public String availableYear1{get;set;}
    public String availableYear2{get;set;}
    public String availableYear3{get;set;}
    public list<SelectOption> driverNameList{get;set;}
    public boolean displayPopup{get;set;} 
    public boolean displayExitPopup{get;set;} 
    public boolean isInformation{get;set;}
    public String b64SignData{get;set;}
    public List<String> listofSenderName{get;set;}
    public  Map<String,String> sendEmailMap {get;set;}
    public String documentPDF;
    public String querySignature;
    public Id wishChildId{get;set;}
    public List<String> signedList{get;set;}
    public boolean displaySignNowPopup {get;set;}
    public boolean displayError{get;set;}
    public boolean confirmSignNow{get;set;}
    public List<String> SignNowList{get;set;}
    
    public String envelopeId;
    public Map<String,String> signersKeyPairMap;
    
    public string childForm {get;set;}
    public string familyForm {get;set;}
    public string infoForm {get;set;}
    public boolean sameParentGuardian{get;set;}
    public boolean isChildPart{get;set;}
    public boolean approvalError{get;set;}
   
    
    
    public WishChildFormUtil()
    {
         wishChildList = new list<Wish_Child_Form__c >();
        emailList = new List<String>();
        sameParentGuardian = false;
        isChildPart = false;
        isInformation = false;
       
        driverNameList = new List<SelectOption>();
          /***********************************************************************/
        leftDietaryNameList = new List<String>();
        righttDietaryNameList= new List<String>();
        currrentDietaryNameList= new List<String>();
        leftWCNamesList= new List<String>();
        rightWCNamesList= new List<String>();
        currentWCNamesList= new List<String>();
        leftOxygenNamesList= new List<String>();
        rightOxygenNamesList= new List<String>();
        currentOxygenNamesList= new List<String>();
        leftAllergyNamesList= new List<String>();
        rightAllergyNamesList= new List<String>();
        currentAllergyNamesList = new List<String>();
        leftOtherNeedsList= new List<String>();
        righttOtherNeedsList= new List<String>();
        currentOtherNeedsList= new List<String>();
        leftOwnWheelChairList = new List<String>();
        rightOwnWheelChairList = new List<String>();
        currentOwnWheelChairList = new List<String>();
        leftWCCollapsibleList = new List<String>();
        rightWCCollapsibleList= new List<String>();
        currentWCCollapsibleList = new List<String>();
        leftWCPowerList = new List<String>();
        rightWCPowerList= new List<String>();
        currentWCPowerList = new List<String>();
        leftMedicationList = new List<String>();
        rightMedicationList= new List<String>();
        currentMedicationList= new List<String>();
        leftNursingCareList = new List<String>();
        rightNursingCareList = new List<String>();
        currentNursingCareList = new List<String>();
        wishFamilyWrapList = new List<WrapperClass>();
        wishParticipantList = new List<WrapperClass>();
        driverWrapperCls = new List<DriverWrapper>();
        emailMap = new Map<String,String>();
        sendEmailMap = new Map<String,String>();
        selectedMailMap = new Map<String,String>();
        SignNowList = new List<String>();
        listofSenderName = new List<String>();
        caseId = Apexpages.currentPage().getParameters().get('id');
        Participants = Apexpages.currentPage().getParameters().get('part');
        childForm = '/apex/WishChildForm_VF?id='+caseId+'&part='+Participants;
        familyForm = '/apex/WishFamilyForm_VF?id='+caseId+'&part='+Participants;
        infoForm = '/apex/WishInformationForm_VF?id='+caseId+'&part='+Participants;
        Boolean isWishFamilyAvailable = false;
        signersKeyPairMap = new Map<String,String>();       
        
    }
    
    public class DriverWrapper
    {
       public string driverName{get;set;}
       public String licenseNum{get;set;}
       public string state{get;set;}
       public string type{get;set;}
       public Date expirationDate{get;set;}
    }
    
    public class WrapperClass 
    {
        public string firstName{get;set;}
        public string lastName{get;set;}
        public String MiddleName{get;set;}
        public Date dob{get;set;}
        public String Email{get;set;}
        public string relationship{get;set;}
        public string mobileTelephone{get;set;}
        public string workTelephone{get;set;}
        public string homeTelephone{get;set;}
        public String tshirtSize{get;set;}
        public String medicalNeeds{get;set;}
        public String residingWishMedical{get;set;}
        public String City{get;set;}
        public String Street{get;set;}
        public String State{get;set;}
        public String PostalCode{get;set;}
        
        public String relId{get;set;}
        public boolean sameParentGuardianFlag = false;
        public boolean isChildParticipants {get; set;}
    }
 
   /*To display the state value of current logged in volunteer contact in community.*/
    public List<SelectOption> getStates(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.State_Picklist__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Please select state')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }
    
    public List<SelectOption> getYear()
    {
       List<SelectOption> options = new List<SelectOption>();
       Integer Year = Date.Today().Year();
       options.add(new SelectOption('','Year'));
       for(integer i = Year;i<=Year+10; i++)
       {
            String curryear = String.valueOf(i);
            options.add(new SelectOption(curryear,curryear));
       }
    
       return options;
    }
    
    public list<SelectOption> getParentGuardianRelationships()
    {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Mother','Mother')); 
         options.add(new SelectOption('Father','Father')); 
         options.add(new SelectOption('Legal Guardian','Legal Guardian')); 
         options.add(new SelectOption('Other','Other')); 
         options.add(new SelectOption('Parent','Parent')); 
         options.add(new SelectOption('Guardian','Guardian')); 
         options.add(new SelectOption('Sister','Sister')); 
         options.add(new SelectOption('Self','Self')); 
         options.add(new SelectOption('Brother','Brother')); 
         options.add(new SelectOption('Sibling','Sibling')); 
         options.add(new SelectOption('Grandmother','Grandmother')); 
         options.add(new SelectOption('Grandfather','Grandfather')); 
         options.add(new SelectOption('Stepmother','Stepmother')); 
         options.add(new SelectOption('Stepfather','Stepfather')); 
         options.add(new SelectOption('Step Sister','Step Sister')); 
         options.add(new SelectOption('Step Brother','Step Brother')); 
         options.add(new SelectOption('Half Sister','Half Sister')); 
         options.add(new SelectOption('Half Brother','Half Brother'));
         options.add(new SelectOption('Aunt','Aunt'));
         options.add(new SelectOption('Uncle','Uncle'));
         options.add(new SelectOption('Cousin','Cousin'));
         options.add(new SelectOption('Husband','Husband'));
         options.add(new SelectOption('Wife','Wife'));
         options.add(new SelectOption('Partner','Partner'));
         options.add(new SelectOption('Friend','Friend'));
         options.add(new SelectOption('Neighbor','Neighbor'));
         options.add(new SelectOption('Family','Family'));
         options.add(new SelectOption('Coworker','Coworker'));
         options.add(new SelectOption('Son','Son'));
         options.add(new SelectOption('Daughter','Daughter'));
         options.add(new SelectOption('Grandson','Grandson'));
         options.add(new SelectOption('Granddaughter','Granddaughter'));
         options.add(new SelectOption('Employer','Employer'));
         options.add(new SelectOption('Employee','Employee'));
         options.add(new SelectOption('Medical Professional','Medical Professional'));
         return options;
         
    }
    public List<SelectOption> getRelationships(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Wish_Child_Form__c.Emergency_Relationship__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }   
    public list<SelectOption> getParticipantRelationships()
    {
         List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  npe4__Relationship__c.npe4__Type__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
         
    }
     
   public List<Schema.FieldSetMember> getWishChildFields() {
        return SObjectType.Wish_Child_Form__c.FieldSets.Wish_Child_Form.getFields();
    }
    
   Public String selectedNames(String selectedNames)
    {
            Boolean start=True;
            String currString = '';
            String returnName;
            String returnSecondName;
            if(selectedNames != Null) {           
                for(String Str : selectedNames.split(';')) {
                  if(currString == '')
                  currString = str;
                  else
                  currString =+','+' '+str;
                }
               returnName = currString.removeStart('[');
               returnSecondName = returnName.removeEnd(']');
            }
       return returnSecondName;
    }
    
    
    
   
    public List<SelectOption> getMonths()
    {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('','Month'));
      options.add(new SelectOption('Jan','Jan'));
      options.add(new SelectOption('Feb','Feb'));
      options.add(new SelectOption('Mar','Mar'));
      options.add(new SelectOption('Apr','Apr'));
      options.add(new SelectOption('May','May'));
      options.add(new SelectOption('Jun','Jun'));
      options.add(new SelectOption('Jul','Jul'));
      options.add(new SelectOption('Aug','Aug'));
      options.add(new SelectOption('Sep','Sep'));
      options.add(new SelectOption('Oct','Oct'));
      options.add(new SelectOption('Nov','Nov'));
      options.add(new SelectOption('Dec','Dec'));
      return options;
    }
}