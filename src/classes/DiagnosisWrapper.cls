public class DiagnosisWrapper {    
    public string conditionDescription{get;set;}
    public string iCDCode{get;set;}
    public string pcdOrIcd {get;set;}
    public string valueSelectedICD{get;set;}
    public string valueSelectedPCD{get;set;}
    public string shortDescription {get;set;}
    public double externalId{get;set;}
    public String conditionDescriptionObject{get;set;}
    public boolean isEligible{get;set;}
    public boolean isGroup1Rec{get;set;}
    public List<MedicalWrapper> medicalWrapperList{get;set;}
    public DiagnosisWrapper(){
        isEligible = false;
        isGroup1Rec = false;
        medicalWrapperList = new  List<MedicalWrapper>(); 
    }
    public class MedicalWrapper{        
        public List<SelectOption> pickVals {get;set;}
        public List<SelectOption> epilepsyPickVals {get;set;}
        public Medical_Questions__c medicalQuestion{get;set;}
        public String selectedPickVal {get;set;}
        public String epilepsySelectedPickVal {get;set;}
        public String reasonForNeed {get;set;}
        public boolean isEligible {get;set;}
        public MedicalWrapper(){
            pickVals = new  List<SelectOption>();
            isEligible = false;
            epilepsyPickVals = new  List<SelectOption>();
            medicalQuestion = new Medical_Questions__c();
        }
    }
}