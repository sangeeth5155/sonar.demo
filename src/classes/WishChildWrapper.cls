public class WishChildWrapper {
	public String describePatient {get; set;}     
    public String password{get; set;}
    public boolean login {get; set;}
    public String healthCareWork {get;set;}
    public String treatingFName {get;set;}
    public String treatingLName {get;set;}
    public String treatingPhone {get;set;}
    public String treatingEmail {get;set;}
    public String treatingHospital {get;set;}
    public String recognizationPickValSelected {get;set;}
    public String vegetativeState {get;set;}
    public String explainDeteriorate {get;set;}
    public String expediteTheProcess{get;set;}
    public String plzExplain{get;set;}
    public String conditioDeteriorate{get;set;}
    public String stillEligibile {get;set;}
    public String additionalInfo {get;set;}
    Public String wishChildEligibilityNotes {get;set;} 
    public List<String> communicationList {get;set;}
    public String selectedItemValue {get; set;}
    public WishChildWrapper(){
    	communicationList = new List<String>();       
    }
     //Used to get state recognization picklist values
    Public List<SelectOption> getStateRecognizationPicklistValues(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead.I_am_Recognized_To_Practice_As_a__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Please Select'));
        for(Schema.PicklistEntry fieldValue : picklistValues){
            options.add(new SelectOption(fieldValue.getLabel(), fieldValue.getValue()));
        } 
        return options;           
    }
    public List<SelectOption> getHealthCareWorks(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.I_m_Part_of_The_Treating_HealthCare_Team__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Please Select')); 
        for( Schema.PicklistEntry currVal : picklistValues) {      
            options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
        }  
        return options; 
    } 
    public List<SelectOption> getCommunications(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.Communication__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', 'Please Select',true));
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }   
}