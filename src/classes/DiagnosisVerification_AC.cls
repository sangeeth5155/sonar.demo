/*****************************************************************************************************************
Author      : MST Solutions
Date        : 10/4/2016
Description : This form is for Medical Professionals to fill up the Medical Summary Reports about the Wish child
whom they are treating.
*******************************************************************************************************************/
public class DiagnosisVerification_AC {  
    private transient Map<String, List<Medical_Questions__c>> condDesMedicalQuestionMap;
    public list<DiagnosisWrapper> diagnosisVerificationWrapperLst{get; set;}
    public TravelAlgorithmWrapper travelAlgorithmWrapperIns{get;set;}
    public WishChildWrapper wishChildWrapperIns{get;set;}
    private transient Map<Id,Medical_Questions__c> medicalQuestionMap;
    //public String currentCondition {get; set;}
    public Lead currlead{get;set;} 
    private String leadId;
    private Set<String> uniqueCurrentConditionSet;
    public DiagnosisWrapper wrapCls {get; set;}    
    private String icdOrPcd;
    private Integer diagnosisBlockNum;
    private String medicalResponse;
    public boolean showAddAnotherDiagnosisBtn{get;set;}
    public String otherDiagnosisBlock {get;set;}    
    public String wishStatus {get;set;}   
    private List<Diagnosis_Verification__c> diagnosisVerificationLst;
    private  Map<String,String> travelVal;
    private  Map<String,String> travelLabel;
    private transient Map<String,String> travelMap;
    private Map<String,String> travelAlgorithmMap;  
    public DiagnosisVerification_AC(){
        wishChildWrapperIns = new WishChildWrapper();
        uniqueCurrentConditionSet = new Set<String>();
        wishChildWrapperIns.login = false;
        wishStatus = null;
        wrapCls = new DiagnosisWrapper();
        currlead = new Lead();
        leadId = ApexPages.currentPage().getParameters().get('leadId');
        if(leadId != Null && leadId.length() > 0){
            loadData();  
        }
    }
    
    //Used to fill Child Information, Medical Professional Information & Diagnosis Information when the form is loaded
    public void loadData(){
        medicalQuestionMap = new Map<Id,Medical_Questions__c>();
        condDesMedicalQuestionMap = new Map<String,List<Medical_Questions__c>>();
        diagnosisVerificationWrapperLst = new list<DiagnosisWrapper>();
        travelAlgorithmWrapperIns = new TravelAlgorithmWrapper();
        travelAlgorithmWrapperIns.travelAgroithmList = new List<String>();
        travelVal = new Map<String,String>();
        travelLabel = new Map<String, String>();
        travelMap = new Map<String,String>();
        travelAlgorithmMap = new Map<String,String>();
        travelAlgorithmWrapperIns.travelSet = new Set<String>();
        String  query = 'SELECT FirstName,Provided_additional_information__c, RFI_Form_Info_Hidden__c, Override_Dupe_Check__c, isConverted, Please_Explain_Deteriorate__c, LastName ,Email, Phone, Name, id, ';
        for(Schema.FieldSetMember currField :getPartAFields()) {
            query+=currField.getFieldPath()+',';
        }
        query=query.removeEnd(',');
        query+=' FROM Lead WHERE Id =:leadId';
        currLead = Database.query(query); 
        wishChildWrapperIns.additionalInfo = currLead.Provided_additional_information__c;
        currLead.Current_Condition_Label__c = currLead.Travel_algorithm__c;
        wishChildWrapperIns.stillEligibile = currLead.Why_do_you_feel_would_be_eligible_Wish__c;
        wishChildWrapperIns.treatingFName = currLead.Treating_Medical_Professional_First_Name__c;
        wishChildWrapperIns.treatingLName = currLead.Treating_Medical_Professional_Last_Name__c;
        wishChildWrapperIns.treatingPhone = currLead.Treating_Medical_Professional_Phone__c;
        wishChildWrapperIns.treatingEmail = currLead.Treating_Medical_Professional_Email__c;
        wishChildWrapperIns.treatingHospital = currLead.Hospital_Treatment_Facility_Treating__c;
        wishStatus = currLead.RFI_Form_Info_Hidden__c;
        wishChildWrapperIns.recognizationPickValSelected = currLead.I_am_Recognized_To_Practice_As_a__c;
        wishChildWrapperIns.healthCareWork = currLead.I_m_Part_of_The_Treating_HealthCare_Team__c;
        wishChildWrapperIns.vegetativeState = currLead.Is_in_a_Comatose_Vegetative_State__c;       
        wishChildWrapperIns.explainDeteriorate = currLead.Please_Explain_Deteriorate__c;
        wishChildWrapperIns.expediteTheProcess = currLead.Is_We_Need_To_Expedite_The_Process__c;
        wishChildWrapperIns.conditioDeteriorate = currLead.Will_Child_s_Condition_Deteriorate__c;
        wishChildWrapperIns.wishChildEligibilityNotes = currLead.Why_do_you_feel_would_be_eligible_Wish__c;
        wishChildWrapperIns.plzExplain = currLead.Please_Explain__c;
        if(currLead.Child_will_ultimately_die_prematurely__c == true) {
            wishChildWrapperIns.describePatient = '1';
        } else if(currLead.Treatment_may_be_feasible_but_can_fail__c == true) {
            wishChildWrapperIns.describePatient = '2';
        } else if(currLead.Treatment_may_prolong_normal_activities__c == true) {
            wishChildWrapperIns.describePatient = '3';
        } else if(currLead.Debilitation_may_extend_over_many_years__c == true) {
            wishChildWrapperIns.describePatient = '4';
        } else if(currLead.Increased_probability_of_premature_death__c == true) {
            wishChildWrapperIns.describePatient = '5';
        } else if(currLead.Risk_of_complications_premature_death__c == true) {
            wishChildWrapperIns.describePatient = '6';
        } else if(currLead.Responds_to_treatment_with_normal_health__c == true) {
            wishChildWrapperIns.describePatient = '7';
        } else if(currLead.None_of_these_statements_describes_Child__c == true) {
            wishChildWrapperIns.describePatient = '8';
        } 
        if(currLead.Communication__c != null){
            for(String com : currLead.Communication__c.split(';')){
                wishChildWrapperIns.communicationList.add(com);
            }
        }
        
        /*if((!String.isEmpty(currLead.Travel_algorithm__c)) && currLead.Travel_algorithm__c.contains(';')) {
Integer i = 0;
currentCondition = '';
for(String currentSplitString : currLead.Travel_algorithm__c.split(';')) {
if(!String.isEmpty(currentSplitString)) {
currentCondition += i+1 +'. '+ currentSplitString + '\n';
i++;
}
}
}*/
        
        //Loading all the Medicial Questions.
        for(Medical_Questions__c medicalQuestions : [SELECT ID,Condition_Description__c,Condition_Description__r.Name,Current_Condition__c,Data_Type__c,Epilepsy_picklist__c,Picklist_values__c,Question__c,Recommendation_to_Chapter__c,Sort_Order__c,Wrapper_Variable__c FROM Medical_Questions__c order by Sort_Order__c ASC]){
            if(medicalQuestions.Question__c != null) {
                medicalQuestions.Question__c = medicalQuestions.Question__c.replace('[child\'s name]', ' ' +currLead.FirstName+ ' ' +currLead.LastName).replace(' (child\'s name) ', currLead.FirstName+' '+currLead.LastName).replace('[Insert child\'s name]', currLead.FirstName+' '+currLead.LastName);
            } else {
                travelAlgorithmMap.put(medicalQuestions.Current_Condition__c,medicalQuestions.Recommendation_to_Chapter__c);
            }
            medicalQuestionMap.put(medicalQuestions.id,medicalQuestions); 
            if(medicalQuestions.Condition_Description__c != Null){
                if(condDesMedicalQuestionMap.containsKey(medicalQuestions.Condition_Description__c)) {
                    condDesMedicalQuestionMap.get(medicalQuestions.Condition_Description__c).add(medicalQuestions);
                } else {
                    condDesMedicalQuestionMap.put(medicalQuestions.Condition_Description__c, new List<Medical_Questions__c>{medicalQuestions});
                }
            }            
        } 
        //Wrapping the Diagnosis Verification records and Medical Questions of the lead to the DiagnosisWrapper       
        diagnosisVerificationLst = new List<Diagnosis_Verification__c>();
        diagnosisVerificationLst = [SELECT id,ICD_Code__c,Lead__c,Primary_Diagnosis__c,PCD_ICD__c,Order__c,Short_Description__c,Condition_Description__c,isEligible__c,(SELECT  Medical_Question__c,Epilepsy_Value__c,Medical_Question_Answer__c,isEligible__c,Comment__c FROM DiagnosisMedicalQuestions__r) FROM Diagnosis_Verification__c WHERE Lead__c = :leadId order by Order__c ];
        if(diagnosisVerificationLst.size() > 0){  
            for(Diagnosis_Verification__c buildWrapper : diagnosisVerificationLst){
                DiagnosisWrapper diagonsisWrapper = new DiagnosisWrapper();
                diagonsisWrapper.icdCode = buildWrapper.ICD_Code__c;
                diagonsisWrapper.pcdOrIcd = buildWrapper.PCD_ICD__c;
                if(buildWrapper.PCD_ICD__c == 'ICD'){
                    diagonsisWrapper.valueSelectedICD = 'value-selected'; 
                    // diagonsisWrapper.valueSelectedPCD = 'value-selected';            
                }else if(buildWrapper.PCD_ICD__c == 'PCD'){
                    diagonsisWrapper.valueSelectedPCD = 'value-selected';   
                }
                diagonsisWrapper.shortDescription = buildWrapper.Short_Description__c;
                diagonsisWrapper.isEligible = buildWrapper.isEligible__c;
                diagonsisWrapper.conditionDescription = buildWrapper.Primary_Diagnosis__c; 
                diagonsisWrapper.conditionDescriptionObject = (String) buildWrapper.Condition_Description__c;
                Map<Id,DiagnosisMedicalQuestions__c> diagnosisQuestionMap = new Map<Id,DiagnosisMedicalQuestions__c>();
                if(buildWrapper.DiagnosisMedicalQuestions__r.size() > 0) {
                    for(DiagnosisMedicalQuestions__c currDiagnosisMedicalQuestion : buildWrapper.DiagnosisMedicalQuestions__r ){
                        diagnosisQuestionMap.put(currDiagnosisMedicalQuestion.Medical_Question__c,currDiagnosisMedicalQuestion);
                    }
                }
                if(condDesMedicalQuestionMap.containsKey(buildWrapper.Condition_Description__c)){
                    for(Medical_Questions__c currMedicalQuestion : condDesMedicalQuestionMap.get(buildWrapper.Condition_Description__c)){
                        DiagnosisWrapper.MedicalWrapper medicalWrapperItem = new DiagnosisWrapper.MedicalWrapper();
                        medicalWrapperItem.medicalQuestion = currMedicalQuestion;
                        if(diagnosisQuestionMap.containsKey(currMedicalQuestion.id)){  
                            medicalWrapperItem.isEligible =  diagnosisQuestionMap.get(currMedicalQuestion.id).isEligible__c;   
                        }     
                        
                        if(currMedicalQuestion.Picklist_values__c != null) {
                            List<SelectOption> pickVals = new List<SelectOption>();
                            pickVals.add(new SelectOption('','Please Select'));
                            for(String currString: currMedicalQuestion.Picklist_values__c.split(',')) {
                                pickVals.add(new SelectOption(currString,currString));
                            }
                            medicalWrapperItem.pickVals = pickVals;
                            if(diagnosisQuestionMap.containsKey(currMedicalQuestion.id)){                                
                                medicalWrapperItem.selectedPickVal = diagnosisQuestionMap.get(currMedicalQuestion.id).Medical_Question_Answer__c;    
                            }
                        }
                        if(currMedicalQuestion.Epilepsy_picklist__c != null) {
                            System.debug('inside Epilesy');
                            List<SelectOption> epilepsyPickVals = new List<SelectOption>();
                            epilepsyPickVals.add(new SelectOption('','Please Select'));
                            for(String currString: currMedicalQuestion.Epilepsy_picklist__c.split(',')) {
                                epilepsyPickVals.add(new SelectOption(currString,currString));
                            }
                            medicalWrapperItem.epilepsyPickVals = epilepsyPickVals;
                            if(diagnosisQuestionMap.containsKey(currMedicalQuestion.id) && diagnosisQuestionMap.get(currMedicalQuestion.id).Epilepsy_Value__c != Null ){
                                medicalWrapperItem.epilepsySelectedPickVal = diagnosisQuestionMap.get(currMedicalQuestion.id).Epilepsy_Value__c;    
                            }
                        }
                        if(currMedicalQuestion.Data_Type__c == 'Comment box') {
                            if(diagnosisQuestionMap.containsKey(currMedicalQuestion.id)){                                
                                medicalWrapperItem.reasonForNeed = diagnosisQuestionMap.get(currMedicalQuestion.id).comment__c;    
                            }
                            
                        }                      
                        diagonsisWrapper.medicalWrapperList.add(medicalWrapperItem);
                    }                    
                }
                diagnosisVerificationWrapperLst.add(diagonsisWrapper);
            }
            Integer lastElement = diagnosisVerificationWrapperLst.size();           
            if(wishStatus != 'Qualified' && diagnosisVerificationWrapperLst.size() < 5 && (diagnosisVerificationWrapperLst[lastelement - 1].iCDCode != Null  || diagnosisVerificationWrapperLst[lastelement - 1].conditionDescription != Null ) && diagnosisVerificationWrapperLst[lastelement - 1].medicalWrapperList.size() == diagnosisVerificationLst[lastelement - 1].DiagnosisMedicalQuestions__r.size()){
                showAddAnotherDiagnosisBtn = true;      
            }            
        }else{
            diagnosisVerificationWrapperLst.add(new DiagnosisWrapper());
        }        
        
        //Travel Algorithm
        Constant_AC  constant = new Constant_AC();
        Id algorithmRecordTypeId = Schema.SObjectType.Medical_questions__c.getRecordTypeInfosByName().get(constant.travelAlgmRT).getRecordTypeId();
        for(Medical_Questions__c currRec : [SELECT Current_Condition__c,Recommendation_to_Chapter__c,Wrapper_Variable__c 
                                            FROM Medical_Questions__c WHERE RecordtypeId = :algorithmRecordTypeId ]){
                                                if(currRec.Wrapper_Variable__c != Null){
                                                    travelLabel.put(currRec.Wrapper_Variable__c,currRec.Current_Condition__c);
                                                    travelVal.put(currRec.Wrapper_Variable__c, currRec.Recommendation_to_Chapter__c);
                                                }
                                                if(currRec.Current_Condition__c!= Null)
                                                    travelMap.put(currRec.Current_Condition__c,currRec.Wrapper_Variable__c);
                                            }
        /*if(currLead.Travel_algorithm__c != null) {
travelAlgorithmWrapperIns.algList = currLead.Travel_algorithm__c.removeEnd(';');            
if(travelAlgorithmWrapperIns.algList.contains(';')) {
for(String travel : travelAlgorithmWrapperIns.algList.split(';')) {
travelAlgorithmWrapperIns.travelSet.add(travel);
}
} else {
travelAlgorithmWrapperIns.travelSet.add(travelAlgorithmWrapperIns.algList);
}
}*/
        String jsonString = json.serialize(travelAlgorithmWrapperIns);
        Map<String,Object> wrapClsMap = new Map<String,Object>();
        wrapClsMap = (Map<String,Object>)json.deserializeuntyped(jsonString);            
        if(currLead.Travel_algorithm__c != Null){
            for(String currVal : (currLead.Travel_algorithm__c.split(';'))){
                if(travelMap.containsKey(currVal)){
                    String fieldName = travelMap.get(currVal);
                    if(fieldName != null) {
                        wrapClsMap.put(fieldName,true);
                    }
                }
            }
            String jsonStringLoad = json.serialize(wrapClsMap);
            travelAlgorithmWrapperIns = (travelAlgorithmWrapper)json.deserialize(jsonStringLoad,travelAlgorithmWrapper.class); 
        }
        if(currLead.Chronic_Hepatitis__c != Null)
            travelAlgorithmWrapperIns.chronicHepatitisString = currLead.Chronic_Hepatitis__c;
        if(currLead.Pulmonary_Hypertension__c != Null)
            travelAlgorithmWrapperIns.pulmonaryHypertensionString = currLead.Pulmonary_Hypertension__c;
        if(currLead.Strokes__c != Null)
            travelAlgorithmWrapperIns.strokesType = currLead.Strokes__c;
        if(currLead.Convulsive_Disorders__c != Null){
            for(String currVal : currLead.Convulsive_Disorders__c.split(';')){
                travelAlgorithmWrapperIns.convulsiveDisorders.add(currVal);
            }
        }
        if(currLead.Congenital_Heart_Disease__c!= Null){
            for(String currVal : currLead.Congenital_Heart_Disease__c.split(';')){
                travelAlgorithmWrapperIns.congenitalHeartDiseaseString.add(currVal);
            }
        }
        if(currLead.Chronic_Heart_Failure__c!= Null){
            for(String currVal : currLead.Chronic_Heart_Failure__c.split(';')){
                travelAlgorithmWrapperIns.chronicHeartFailureString.add(currVal);
            }
        }
        if(currLead.Heart_Failure__c!= Null){
            for(String currVal : currLead.Heart_Failure__c.split(';')){
                travelAlgorithmWrapperIns.heartFailureString.add(currVal);
            }
        }
        if(currLead.Arrhythmia__c!= Null){
            for(String currVal : currLead.Arrhythmia__c.split(';')){
                travelAlgorithmWrapperIns.ArrhythmiaString.add(currVal);
            }
        }
        if(currLead.Ventilator__c != Null){
            travelAlgorithmWrapperIns.ventilatorText = currLead.Ventilator__c;
        }
        if(currLead.Angina__c!= Null){            
            for(String currVal : currLead.Angina__c.split(';')){
                travelAlgorithmWrapperIns.anginaString.add(currVal);
            }
        }         
        if(currLead.Lung_Disease__c != Null){
            for(String currVal : currLead.Lung_Disease__c.split(';')){
                travelAlgorithmWrapperIns.lungDiseaseString.add(currVal);
            }
        }
        
    }
    
    //Used to clear the diagnosis information for removed block 
    public void ResetDiagnosis() {
        diagnosisBlockNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('diagnosisBlockNum'));
        
        diagnosisVerificationWrapperLst[diagnosisBlockNum].shortDescription = Null;
        diagnosisVerificationWrapperLst[diagnosisBlockNum].pcdOrIcd = Null;
        diagnosisVerificationWrapperLst[diagnosisBlockNum].valueSelectedICD = Null;
        diagnosisVerificationWrapperLst[diagnosisBlockNum].valueSelectedPCD = Null;
        diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = false;
        if(diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList.size() > 0){
            diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList.clear();
        }
        for(Integer i=0; i< diagnosisVerificationWrapperLst.size(); i++) {
            if(String.isEmpty(diagnosisVerificationWrapperLst[i].iCDCode) && String.isEmpty(diagnosisVerificationWrapperLst[i].conditionDescription) && i != diagnosisBlockNum) {
                diagnosisVerificationWrapperLst[i].shortDescription = Null;
                diagnosisVerificationWrapperLst[i].pcdOrIcd = Null;
                diagnosisVerificationWrapperLst[i].valueSelectedICD = Null;
                diagnosisVerificationWrapperLst[i].valueSelectedPCD = Null;
                diagnosisVerificationWrapperLst[i].isEligible = false;
                if(diagnosisVerificationWrapperLst[i].medicalWrapperList.size() > 0){
                    diagnosisVerificationWrapperLst[i].medicalWrapperList.clear();
                }
                diagnosisVerificationWrapperLst.remove(i);
            }
        }  
        setWishStatus();
    } 
    
    
    //Used to remove Diagnosis Block
    public void RemoveDiagnosisBlock() {
        diagnosisBlockNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('diagnosisBlockNum')); // Used to hold the Diagnosis block number
        List<Diagnosis_Verification__c> removeDiagnosisVerificationList = [SELECT Id, Order__c FROM Diagnosis_Verification__c WHERE Order__c =: diagnosisBlockNum];
        
        diagnosisVerificationWrapperLst[diagnosisBlockNum].shortDescription = Null;
        diagnosisVerificationWrapperLst[diagnosisBlockNum].pcdOrIcd = Null;
        diagnosisVerificationWrapperLst[diagnosisBlockNum].valueSelectedICD = Null;
        diagnosisVerificationWrapperLst[diagnosisBlockNum].valueSelectedPCD = Null;
        diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = false;
        if(diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList.size() > 0){
            diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList.clear();
        }
        diagnosisVerificationWrapperLst.remove(diagnosisBlockNum);
        if(diagnosisVerificationWrapperLst.size() < 5 && (diagnosisVerificationWrapperLst[diagnosisBlockNum - 1].icdCode.length() > 0 || diagnosisVerificationWrapperLst[diagnosisBlockNum - 1].conditionDescription.length() > 0) ){
            showAddAnotherDiagnosisBtn = true;
        }
        setWishStatus();
    }
    
    
    //Used to add another diagnosis block
    public void addDiagnosisVerification(){
        if(diagnosisVerificationWrapperLst.size() < 5){
            diagnosisVerificationWrapperLst.add(new DiagnosisWrapper());
            showAddAnotherDiagnosisBtn = false; 
            otherDiagnosisBlock = null;
        }
        setWishStatus();
    }
    
    // Auto Complete the ICD Code values.
    @RemoteAction
    public static List<ICD_Codes__c> searchDiagnosis(String searchTerm) {
        List<ICD_Codes__c> icdCodes = Database.query('SELECT Id, Name,Condition_Description__c, Condition_Description__r.Name, Short_Description__c FROM ICD_Codes__c WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\' AND Hidden_ICD_Code__c = false');
        return icdCodes;
    }
    
    // Auto Complete the Dianosis field value.
    @RemoteAction
    public static List<Condition_Description__c> searchCondition(String searchTerm) {
        List<Condition_Description__c> conditionDescriptions = Database.query('Select Id, Name, Code_To_Use__c from Condition_Description__c where Name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
        if(!(conditionDescriptions.size() > 0))
        {
            conditionDescriptions =[Select Id, Name, Code_To_Use__c from Condition_Description__c WHERE Not_Listed__c = True];
        }
        return conditionDescriptions;
    } 
    
    //Used to check login credentials and whether document is already signed
    public pagereference submit(){
        if(currLead.isSign__c == true) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Document already reviewed, Please contact chapter staff for access');
            ApexPages.addMessage(myMsg);
        } else if(currLead.isConverted == true) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot review this document');
            ApexPages.addMessage(myMsg);
        } else if(wishChildWrapperIns.password != currLead.Part_A_Form_Password__c) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Incorrect password');
            ApexPages.addMessage(myMsg);
        } else if(wishChildWrapperIns.password == currLead.Part_A_Form_Password__c){
            wishChildWrapperIns.login = true;
        } 
        return null;
    }
    
    //Used to hold the describe patient value 
    public void changePatientValue() {
        wishChildWrapperIns.describePatient = wishChildWrapperIns.selectedItemValue;
    } 
    
    //To check whether Wish Child is eligible based on ICD & Condition Description provided
    public void WishChildEligibilityCheck() {
        icdOrPcd = ApexPages.currentPage().getParameters().get('icdOrPcd'); //Used to hold the given auto complete input is ICD Code or Condition Description
        diagnosisBlockNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('diagnosisBlockNum')); // Used to hold the Diagnosis block number
        diagnosisVerificationWrapperLst[diagnosisBlockNum].shortDescription = Null;
        if(icdOrPcd == 'ICD'){
            diagnosisVerificationWrapperLst[diagnosisBlockNum].valueSelectedICD = 'value-selected'; 
            //diagnosisVerificationWrapperLst[diagnosisBlockNum].valueSelectedPCD = 'value-selected';            
        }else if(icdOrPcd == 'PCD'){
            diagnosisVerificationWrapperLst[diagnosisBlockNum].valueSelectedPCD = 'value-selected';     
        }
        
        diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = false;
        diagnosisVerificationWrapperLst[diagnosisBlockNum].pcdOrIcd = icdOrPcd;
        showAddAnotherDiagnosisBtn = false;
        if(diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList.size() > 0){
            diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList.clear();
        }
        //ICD code 
        if(icdOrPcd == 'ICD') {
            //diagnosisVerificationWrapperLst[diagnosisBlockNum].conditionDescription = Null;            
            List<ICD_Codes__c> icdCodeInfo = [SELECT Id, Name, Condition_Description__c, Short_Description__c,Condition_Description__r.Name, Condition_Description__r.isEligible__c, Group1__c FROM ICD_Codes__c WHERE Name =: diagnosisVerificationWrapperLst[diagnosisBlockNum].iCDCode AND Hidden_ICD_Code__c = false];
            if(icdCodeInfo.size() > 0) {
                List<Medical_Questions__c> medicalQuestionList = new List<Medical_Questions__c>();
                medicalQuestionList =   [SELECT ID,Condition_Description__c,Condition_Description__r.Name,Current_Condition__c,Data_Type__c,Epilepsy_picklist__c,Picklist_values__c,Question__c,Recommendation_to_Chapter__c,Sort_Order__c,Wrapper_Variable__c FROM Medical_Questions__c  WHERE Condition_Description__c = :icdCodeInfo[0].Condition_Description__c order by Sort_Order__c ASC];
                System.debug('inside the ICD Medical Question++'+medicalQuestionList);
                diagnosisVerificationWrapperLst[diagnosisBlockNum].shortDescription = icdCodeInfo[0].Short_Description__c;
                diagnosisVerificationWrapperLst[diagnosisBlockNum].isGroup1Rec = icdCodeInfo[0].Group1__c;
                //Condition Description categories like Epilepsy, Cardiomyopathy with group 1 records are considered as eligible without asking Medical Questions
                //Those questions are identified by using isEligible__c field
                if(!String.isEmpty(icdCodeInfo[0].Condition_Description__r.Name) && icdCodeInfo[0].Condition_Description__r.Name == 'Total Parenteral Nutrition (TPN)') {
                    showAddAnotherDiagnosisBtn = true;
                }
                /*if(icdCodeInfo[0].Condition_Description__r.isEligible__c == true) { 
if(wishChildWrapperIns.describePatient != '7' && wishChildWrapperIns.describePatient != '8' && wishChildWrapperIns.describePatient != '6'){                    
diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = true;
}else{
showAddAnotherDiagnosisBtn = true;    
}
} */else {
    MediacalQuestions(icdCodeInfo[0].Name, icdCodeInfo[0].Condition_Description__c, icdCodeInfo[0].Group1__c,  icdOrPcd, diagnosisBlockNum,medicalQuestionList);
}
            } 
            //Conition Description
        } else if(icdOrPcd == 'PCD') {  
            //diagnosisVerificationWrapperLst[diagnosisBlockNum].iCDCode = Null;            
            if(diagnosisVerificationWrapperLst[diagnosisBlockNum].conditionDescription == 'Total Parenteral Nutrition (TPN)') {
                showAddAnotherDiagnosisBtn = true;
            }
            List<Condition_Description__c> conditionDescriptionInfo = [SELECT Id, Name, isEligible__c, Group1__c, Code_To_Use__c FROM Condition_Description__c WHERE Name =: diagnosisVerificationWrapperLst[diagnosisBlockNum].conditionDescription];
            if(conditionDescriptionInfo.size() > 0) {
                diagnosisVerificationWrapperLst[diagnosisBlockNum].isGroup1Rec = conditionDescriptionInfo[0].Group1__c;
                List<Medical_Questions__c> medicalQuestionList = new List<Medical_Questions__c>();
                medicalQuestionList =   [SELECT ID,Condition_Description__c,Condition_Description__r.Name,Current_Condition__c,Data_Type__c,Epilepsy_picklist__c,Picklist_values__c,Question__c,Recommendation_to_Chapter__c,Sort_Order__c,Wrapper_Variable__c FROM Medical_Questions__c  WHERE Condition_Description__c = :conditionDescriptionInfo[0].id order by Sort_Order__c ASC];
                //Condition Description categories like Epilepsy, Cardiomyopathy with group 1 records are considered as eligible without asking Medical Questions
                //Those questions are identified by using isEligible__c field
                if(conditionDescriptionInfo[0].isEligible__c == true) {
                    if(wishChildWrapperIns.describePatient != '7' && wishChildWrapperIns.describePatient != '8' && wishChildWrapperIns.describePatient != '6'){                    
                        diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = true; 
                    }else{
                        showAddAnotherDiagnosisBtn = true;    
                    }
                } else {
                    //Medical question inputs for given Condition Description if the ICD Code is not null
                    if(!String.isEmpty(conditionDescriptionInfo[0].Code_To_Use__c)) {
                        List<ICD_Codes__c> icdCodeInfo = [SELECT Id, Name, Condition_Description__c, Short_Description__c,Condition_Description__r.Name, Group1__c FROM ICD_Codes__c WHERE Name =: conditionDescriptionInfo[0].Code_To_Use__c AND Hidden_ICD_Code__c = false];
                        if(icdCodeInfo.size() > 0) {
                            diagnosisVerificationWrapperLst[diagnosisBlockNum].valueSelectedICD = 'value-selected';
                            diagnosisVerificationWrapperLst[diagnosisBlockNum].shortDescription = icdCodeInfo[0].Short_Description__c;
                            MediacalQuestions(icdCodeInfo[0].Name, conditionDescriptionInfo[0].Id, icdCodeInfo[0].Group1__c,  icdOrPcd, diagnosisBlockNum,medicalQuestionList);
                        } else {
                            diagnosisVerificationWrapperLst[diagnosisBlockNum].valueSelectedICD = 'value-selected';
                            MediacalQuestions(conditionDescriptionInfo[0].Code_To_Use__c, conditionDescriptionInfo[0].Id, conditionDescriptionInfo[0].Group1__c,  icdOrPcd, diagnosisBlockNum,medicalQuestionList);
                        }
                        //Medical question inputs for given Condition Description if the ICD Code is null
                    } else {
                        MediacalQuestions(conditionDescriptionInfo[0].Code_To_Use__c, conditionDescriptionInfo[0].Id, conditionDescriptionInfo[0].Group1__c,  icdOrPcd, diagnosisBlockNum,medicalQuestionList);
                    }
                }
            }
        }
        setWishStatus();        
    }
    
    //Used to set status based on Medical Question response.
    public void setWishStatus(){
        wishStatus = '';
        for(DiagnosisWrapper currDiagnosisWrapper : diagnosisVerificationWrapperLst){
            if(currDiagnosisWrapper.isEligible){
                wishStatus = 'Qualified';
            }
        }
        //if(wishStatus != 'Qualified' && diagnosisVerificationWrapperLst.size() == 5 ){
        if(wishStatus != 'Qualified'  ){
            wishStatus = 'Not Qualified';    
        }
    }
    
    //Getting Medical Question List based on ICD Code & Condition Description given by Medical Professional
    public List<DiagnosisWrapper.MedicalWrapper> MediacalQuestions(String icdCode, String conditionDescription, Boolean isGroup1, String icdOrPcd, Integer diagnosisBlockNum,List<Medical_Questions__c> medicalQuestions) {
        diagnosisVerificationWrapperLst[diagnosisBlockNum].conditionDescriptionObject = conditionDescription;
        //if(!String.isEmpty(conditionDescription) && condDesMedicalQuestionMap.containsKey(conditionDescription)) {
        //medicalQuestionList
        if(!String.isEmpty(conditionDescription) && medicalQuestions.size() > 0) {
            List<Medical_Questions__c> medicalQuestionList = new List<Medical_Questions__c>();
            medicalQuestionList.addAll(medicalQuestions);
            if(medicalQuestionList.size() > 0) {               
                for(Medical_Questions__c medicalQuestion : medicalQuestionList) {
                    DiagnosisWrapper.MedicalWrapper medicalWrapperItem = new DiagnosisWrapper.MedicalWrapper();
                    medicalWrapperItem.medicalQuestion = medicalQuestion;
                    if(medicalQuestion.Picklist_values__c != null) {
                        List<SelectOption> pickVals = new List<SelectOption>();
                        pickVals.add(new SelectOption('','Please Select'));
                        for(String currString : medicalQuestion.Picklist_values__c.split(',')) {
                            pickVals.add(new SelectOption(currString,currString));
                        }
                        medicalWrapperItem.pickVals = pickVals;                    
                    }
                    if(medicalQuestion.Epilepsy_picklist__c != null) {
                        List<SelectOption> epilepsyPickVals = new List<SelectOption>();
                        epilepsyPickVals.add(new SelectOption('','Please Select'));
                        for(String currString : medicalQuestion.Epilepsy_picklist__c.split(',')) {
                            epilepsyPickVals.add(new SelectOption(currString,currString));
                        }
                        medicalWrapperItem.epilepsyPickVals = epilepsyPickVals;
                    }
                    diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList.add(medicalWrapperItem);
                }
            } else if(isGroup1 == true) {
                if(wishChildWrapperIns.describePatient != '7' && wishChildWrapperIns.describePatient != '8' && wishChildWrapperIns.describePatient != '6'){                
                    diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = true;  
                }else{
                    showAddAnotherDiagnosisBtn = true;    
                }
            } else {                
                if (diagnosisVerificationWrapperLst.size() < 5){
                    showAddAnotherDiagnosisBtn = true;    
                }else {
                    showAddAnotherDiagnosisBtn = false;                     
                    diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = false;
                }                
            }
        } else if(isGroup1 == true) { 
            if(wishChildWrapperIns.describePatient != '7' && wishChildWrapperIns.describePatient != '8' && wishChildWrapperIns.describePatient != '6'){
                diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = true;  
            }else{
                showAddAnotherDiagnosisBtn = true;    
            }
        } else {            
            diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = false;
            if (diagnosisVerificationWrapperLst.size() < 5){
                showAddAnotherDiagnosisBtn = true;
            }else {                
                showAddAnotherDiagnosisBtn = false;
            }  
        }
        setWishStatus();
        return null;        
    }
    
    //Making wish as Eligible & Not Eligible based on Medical Question Value
    public void MedicalResponse() {
        medicalResponse = ApexPages.currentPage().getParameters().get('medicalResponse'); //Used to hold the Medical Question response 
        diagnosisBlockNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('diagnosisBlockNum')); // Used to hold the Diagnosis block number
        integer questionNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('questionNumber')); 
        if(medicalResponse != null && medicalResponse == 'Yes') {
            System.debug('Inside +++'+medicalResponse);            
            if(wishChildWrapperIns.describePatient != '7' && wishChildWrapperIns.describePatient != '8' && wishChildWrapperIns.describePatient != '6'){
                showAddAnotherDiagnosisBtn = false;
                diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = true;
                diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList[questionNumber].isEligible = true;     
            }      
        } else if((medicalResponse != null) && (medicalResponse == 'No' || medicalResponse == 'ShowNext') ) {           
            if(diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList[questionNumber].isEligible){
                diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = false;
                diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList[questionNumber].isEligible = false;
            }
            if(diagnosisVerificationWrapperLst.size() < 5 ){
                system.debug('inside the condition');
                showAddAnotherDiagnosisBtn = true;    
            }                        
        } else if(diagnosisBlockNum > 5) {            
            if(diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList[questionNumber].isEligible){
                diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = false;
                diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList[questionNumber].isEligible = false;
            }
        }
        setWishStatus();
    }
    
    // To change the Wish status
    public void changeWishStatus() { 
        diagnosisBlockNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('diagnosisBlockNum')); // Used to hold the Diagnosis block number
        integer questionNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('questionNumber')); 
        if(diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList[questionNumber].isEligible){
            diagnosisVerificationWrapperLst[diagnosisBlockNum].isEligible = false;
            diagnosisVerificationWrapperLst[diagnosisBlockNum].medicalWrapperList[questionNumber].isEligible = false;
        }
        setWishStatus();
    }
    
    //Used to delete the Medical Summary Attachment
    public void deleteLeadFile() { 
        String attachmentId = ApexPages.currentPage().getParameters().get('attachmentId'); // Used to hold the Diagnosis block number
        try{
            Delete [SELECT Id FROM Lead_File__c WHERE ID = : attachmentId];
        }Catch(Exception ex){
            System.debug('Exception'+ex.getMessage());
        }
    }
    
    
    
    //Used to save information given by MedicalProfessional
    public void SaveMedicalInformation() {
        String currentConditionFormattedString = ApexPages.currentPage().getParameters().get('travelString');
        String currentConditionChosenString = ApexPages.currentPage().getParameters().get('collectedConditionValue');
        
        currLead.Treating_Medical_Professional_First_Name__c =  wishChildWrapperIns.treatingFName ;
        currLead.Treating_Medical_Professional_Last_Name__c = wishChildWrapperIns.treatingLName;
        currLead.Treating_Medical_Professional_Phone__c = wishChildWrapperIns.treatingPhone;
        currLead.Treating_Medical_Professional_Email__c = wishChildWrapperIns.treatingEmail;
        currLead.Hospital_Treatment_Facility_Treating__c = wishChildWrapperIns.treatingHospital;
        currLead.I_am_Recognized_To_Practice_As_a__c = wishChildWrapperIns.recognizationPickValSelected;
        currLead.I_m_Part_of_The_Treating_HealthCare_Team__c = wishChildWrapperIns.healthCareWork;
        currLead.Is_in_a_Comatose_Vegetative_State__c = wishChildWrapperIns.vegetativeState;
        currLead.RFI_Form_Info_Hidden__c = wishStatus;
        currLead.Is_We_Need_To_Expedite_The_Process__c = wishChildWrapperIns.expediteTheProcess;
        currLead.Please_Explain_Deteriorate__c = wishChildWrapperIns.explainDeteriorate;
        currLead.Please_Explain__c = wishChildWrapperIns.plzExplain;
        currLead.Will_Child_s_Condition_Deteriorate__c = wishChildWrapperIns.conditioDeteriorate;
        currLead.Why_do_you_feel_would_be_eligible_Wish__c = wishChildWrapperIns.wishChildEligibilityNotes;
        currLead.Why_do_you_feel_would_be_eligible_Wish__c = wishChildWrapperIns.stillEligibile;  
        currLead.Provided_additional_information__c = wishChildWrapperIns.additionalInfo;
        currLead.Child_will_ultimately_die_prematurely__c = false;
        currLead.Treatment_may_be_feasible_but_can_fail__c = false;
        currLead.Treatment_may_prolong_normal_activities__c = false;
        currLead.Debilitation_may_extend_over_many_years__c = false;
        currLead.Increased_probability_of_premature_death__c = false;
        currLead.Risk_of_complications_premature_death__c = false;
        currLead.None_of_these_statements_describes_Child__c = false;
        currLead.Responds_to_treatment_with_normal_health__c = false;
        if(wishChildWrapperIns.describePatient == '1') {
            currLead.Child_will_ultimately_die_prematurely__c = true;
        } else if(wishChildWrapperIns.describePatient == '2') {
            currLead.Treatment_may_be_feasible_but_can_fail__c = true;
        } else if(wishChildWrapperIns.describePatient == '3') {
            currLead.Treatment_may_prolong_normal_activities__c = true;
        } else if(wishChildWrapperIns.describePatient == '4') {
            currLead.Debilitation_may_extend_over_many_years__c = true;
        } else if(wishChildWrapperIns.describePatient == '5') {
            currLead.Increased_probability_of_premature_death__c = true;
        } else if(wishChildWrapperIns.describePatient == '6') {
            currLead.Risk_of_complications_premature_death__c = true;
        } else if(wishChildWrapperIns.describePatient == '7') {
            currLead.Responds_to_treatment_with_normal_health__c = true;
        } else if(wishChildWrapperIns.describePatient == '8') {
            currLead.None_of_these_statements_describes_Child__c = true;
        }
        if(wishChildWrapperIns.communicationList != Null){
            String communications ='';
            for(String s : (wishChildWrapperIns.communicationList)){
                communications+=s+';';
            }
            currLead.Communication__c  = communications.removeEnd(';');
        }
        list<Diagnosis_Verification__c> diagnosisVerificationLstForInsert = new list<Diagnosis_Verification__c>();
        list<DiagnosisMedicalQuestions__c> diagnosisMedicalQuestionLst = new list<DiagnosisMedicalQuestions__c>();
        integer order = 0;   
        currLead.PD_Condition_Description__c = null;
        currLead.PD_ICD_Code__c = null;
        currLead.SD1_Condition_Description__c = null;
        currLead.SD1_ICD_Code__c = null;
        currLead.SD3_Condition_Description__c = null;
        currLead.SD3_ICD_Code__c = null; 
        currLead.SD2_Condition_Description__c = null;
        currLead.SD2_ICD_Code__c = null;
        currLead.SD4_Condition_Description__c = null;
        currLead.SD4_ICD_Code__c = null;    
        Set<Integer> orderSet = new Set<Integer>();
        Set<String> icdCodeSet = new Set<String>();
        Map<String, Id> icdInfoMap = new Map<String, Id>();
        for(DiagnosisWrapper diagnosisVerificationItem : diagnosisVerificationWrapperLst) {
            icdCodeSet.add(diagnosisVerificationItem.iCDCode);
        }
        for(ICD_Codes__c icdInfo : [SELECT Id, Name FROM ICD_Codes__c WHERE Name IN : icdCodeSet]) {
            icdInfoMap.put(icdInfo.Name, icdInfo.Id);
        }
        for( DiagnosisWrapper diagnosisVerificationItem : diagnosisVerificationWrapperLst){
            if(!orderSet.contains(order) && (!String.isEmpty(diagnosisVerificationItem.iCDCode) || !String.isEmpty(diagnosisVerificationItem.conditionDescription))) {
                Diagnosis_Verification__c diagnosisVerification = new Diagnosis_Verification__c();
                diagnosisVerification.Order__c = order;
                diagnosisVerification.Group1__c = diagnosisVerificationItem.isGroup1Rec;
                diagnosisVerification.Lead__c = leadId;
                diagnosisVerification.isEligible__c = diagnosisVerificationItem.isEligible;
                diagnosisVerification.ICD_Code__c = diagnosisVerificationItem.iCDCode;
                diagnosisVerification.PCD_ICD__c = diagnosisVerificationItem.pcdOrIcd;
                diagnosisVerification.Primary_Diagnosis__c = diagnosisVerificationItem.conditionDescription;
                diagnosisVerification.Condition_Description__c = diagnosisVerificationItem.conditionDescriptionObject;
                diagnosisVerification.Short_Description__c = diagnosisVerificationItem.shortDescription;
                diagnosisVerificationItem.externalId = Math.random();
                diagnosisVerification.Eternal_Id__c = string.valueof(diagnosisVerificationItem.externalId);
                diagnosisVerificationLstForInsert.add(diagnosisVerification);
                
                if(order == 0){
                    currLead.PD_Condition_Description__c = diagnosisVerificationItem.conditionDescription;
                    if(icdInfoMap.containsKey(diagnosisVerificationItem.iCDCode)) {
                        currLead.PD_ICD_Code__c = icdInfoMap.get(diagnosisVerificationItem.iCDCode);
                    }
                }
                if(order == 1){
                    currLead.SD1_Condition_Description__c = diagnosisVerificationItem.conditionDescription;
                    if(icdInfoMap.containsKey(diagnosisVerificationItem.iCDCode)) {
                        currLead.SD1_ICD_Code__c = icdInfoMap.get(diagnosisVerificationItem.iCDCode);
                    }
                }
                if(order == 2){
                    currLead.SD2_Condition_Description__c = diagnosisVerificationItem.conditionDescription;
                    if(icdInfoMap.containsKey(diagnosisVerificationItem.iCDCode)) {
                        currLead.SD2_ICD_Code__c = icdInfoMap.get(diagnosisVerificationItem.iCDCode);
                    }
                }
                if(order == 3){
                    currLead.SD3_Condition_Description__c = diagnosisVerificationItem.conditionDescription;
                    if(icdInfoMap.containsKey(diagnosisVerificationItem.iCDCode)) {
                        currLead.SD3_ICD_Code__c = icdInfoMap.get(diagnosisVerificationItem.iCDCode);
                    }
                }
                if(order == 4){
                    currLead.SD4_Condition_Description__c = diagnosisVerificationItem.conditionDescription;
                    if(icdInfoMap.containsKey(diagnosisVerificationItem.iCDCode)) {
                        currLead.SD4_ICD_Code__c = icdInfoMap.get(diagnosisVerificationItem.iCDCode);
                    }
                }
                orderSet.add(order);
            }
            order++;            
        }
        for( DiagnosisWrapper diagnosisVerificationItem : diagnosisVerificationWrapperLst){
            if((diagnosisVerificationItem.iCDCode != Null && diagnosisVerificationItem.iCDCode.length() > 0) || (diagnosisVerificationItem.conditionDescription != Null && diagnosisVerificationItem.conditionDescription.length() > 0)){
                Diagnosis_Verification__c diagnosisVerificationReference = new Diagnosis_Verification__c(Eternal_Id__c=string.valueof(diagnosisVerificationItem.externalId));
                for(DiagnosisWrapper.MedicalWrapper medicalWrapperItem : diagnosisVerificationItem.medicalWrapperList ){
                    if((medicalWrapperItem.selectedPickVal != Null && medicalWrapperItem.selectedPickVal.length() > 0) || (medicalWrapperItem.reasonForNeed!= Null && medicalWrapperItem.reasonForNeed.length() > 0 )){ 
                        DiagnosisMedicalQuestions__c diagnosisQuestion = new DiagnosisMedicalQuestions__c();
                        diagnosisQuestion.Diagnosis_Verification__r = diagnosisVerificationReference;
                        diagnosisQuestion.Epilepsy_Value__c = medicalWrapperItem.epilepsySelectedPickVal;
                        diagnosisQuestion.Comment__c = medicalWrapperItem.reasonForNeed; 
                        diagnosisQuestion.Medical_Question_Answer__c = medicalWrapperItem.selectedPickVal;
                        diagnosisQuestion.Medical_Question__c = medicalWrapperItem.medicalQuestion.id;
                        diagnosisQuestion.isEligible__c = medicalWrapperItem.isEligible;
                        diagnosisMedicalQuestionLst.add(diagnosisQuestion);                        
                    }
                }
            }
        }        
        
        Set<String> travelValuesSet = new Set<String>();
        Set<String> travelValuesLabel = new Set<String>();
        String jsonString = json.serialize(travelAlgorithmWrapperIns);
        Map<String,Object> wrapClsMap = new Map<String,Object>();
        wrapClsMap= (Map<String,Object>)json.deserializeuntyped(jsonString);   
        
        for(String currString : travelVal.keySet()){
            if(wrapClsMap.get(currString) == True){
                travelValuesSet.add(travelVal.get(currString));
                travelValuesLabel.add(travelLabel.get(currString));
            }
        } 
        
        currLead.Current_Condition_label__c = '';        
        for(String currVal : travelValuesLabel){
            currLead.Current_Condition_label__c+=currVal+';';
        } 
        
        if(travelAlgorithmWrapperIns.chronicHepatitisString != Null){
            currLead.Chronic_Hepatitis__c = travelAlgorithmWrapperIns.chronicHepatitisString;
        }
        
        if(travelAlgorithmWrapperIns.pulmonaryHypertensionString != Null){
            currLead.Pulmonary_Hypertension__c = travelAlgorithmWrapperIns.pulmonaryHypertensionString;
        }
        
        if(travelAlgorithmWrapperIns.strokesType != Null){
            currLead.Strokes__c = travelAlgorithmWrapperIns.strokesType ;
        }
        
        currLead.Convulsive_Disorders__c = '';
        if(travelAlgorithmWrapperIns.convulsiveDisorders != Null) {
            for(String currVal : travelAlgorithmWrapperIns.convulsiveDisorders){
                currLead.Convulsive_Disorders__c+=currVal+';';
            }
        }
        
        currLead.Congenital_Heart_Disease__c = '';
        if(travelAlgorithmWrapperIns.congenitalHeartDiseaseString != Null){
            for(String currVal : travelAlgorithmWrapperIns.congenitalHeartDiseaseString ){
                currLead.Congenital_Heart_Disease__c+=currVal+';';
            }
        }
        
        currLead.Chronic_Heart_Failure__c = '';
        if(travelAlgorithmWrapperIns.chronicHeartFailureString != Null){
            for(String currVal : travelAlgorithmWrapperIns.chronicHeartFailureString){
                currLead.Chronic_Heart_Failure__c+=currVal+';';
            }
        }
        
        currLead.Heart_Failure__c = '';
        if(travelAlgorithmWrapperIns.heartFailureString!= Null){
            for(String currVal : travelAlgorithmWrapperIns.heartFailureString){
                currLead.Heart_Failure__c+=currVal+';';
            }
        }
        
        currLead.Arrhythmia__c = '';
        if(travelAlgorithmWrapperIns.ArrhythmiaString!= Null){
            for(String currVal : travelAlgorithmWrapperIns.ArrhythmiaString){
                currLead.Arrhythmia__c+=currVal+';';
            }
        }
        
        currLead.Angina__c = '';
        if(travelAlgorithmWrapperIns.anginaString!= Null){
            for(String currVal : travelAlgorithmWrapperIns.anginaString){
                currLead.Angina__c+=currVal+';';
            }
        }
        
        currLead.Ventilator__c = travelAlgorithmWrapperIns.ventilatorText;
        
        currLead.lung_disease__c='';
        if(travelAlgorithmWrapperIns.lungDiseaseString!= Null){
            for(String currVal : travelAlgorithmWrapperIns.lungDiseaseString){
                currLead.lung_disease__c+=currVal+';';
            }
        }
        
        System.debug('currentConditionChosenString'+currentConditionChosenString);
        uniqueCurrentConditionSet.clear();
        currLead.Current_Condition__c = '';
        if(!String.isEmpty(currentConditionChosenString)) {
            for(String currCon : currentConditionChosenString.split(';')) {
                if(travelAlgorithmMap.containsKey(currCon)) {
                    if(!uniqueCurrentConditionSet.contains(currCon)) {
                        if(!String.isEmpty(travelAlgorithmMap.get(currCon))) {
                            uniqueCurrentConditionSet.add(travelAlgorithmMap.get(currCon));
                        }
                    }
                }
            }
        }
        
        currLead.Current_Condition__c = '';
        if(uniqueCurrentConditionSet.size() > 0) {
            Integer i = 1;
            for(String condition : uniqueCurrentConditionSet) {
                currLead.Current_Condition__c += i+'. '+condition + ';'+'\n';
                i++;
            }
        }
        
        currLead.Travel_algorithm__c = currLead.Current_Condition_Label__c;
        
        currLead.Current_Condition_Label__c = '';
        if(!String.isEmpty(currentConditionFormattedString)) {
            currLead.Current_Condition_Label__c = currentConditionFormattedString;
        }
        
        try{
            update currLead;
            insert diagnosisVerificationLstForInsert;
            Insert diagnosisMedicalQuestionLst;
            Delete diagnosisVerificationLst;
        }Catch(Exception ex){
            System.debug('Exception ex'+ex.getMessage());
        }
        loadData();
    }
    
    //Self Fieldset, it holds the mandatory fields of Self relationship.
    public List<Schema.FieldSetMember> getPartAFields() {
        return SObjectType.Lead.FieldSets.Diagnosis_Verfication_Fieldset.getFields();
    } 
    
    //Used to place sign signature in the docusign page
    public pageReference SubmitSign(){
        String account;
        String UserName;
        String Password;
        String IntegratorKey;
        String endPointURL;
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        String currentRequestURL =   'http://wish.force.com/';
        
        for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
            UserName = credentialIns.name;
            account  = credentialIns.account__c;
            Password = credentialIns.Password__c;
            IntegratorKey  = credentialIns.IntegratorKey__c;
            endPointURL = credentialIns.end_Point__c;
        }
        string endpoint = endPointURL+'/accounts/'+account+'/envelopes';
        String authorizationHeader = '<DocuSignCredentials><Username>'+UserName+'</Username><Password>'+Password+'</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
        String boundary = 'AAA';
        Pagereference PDF = Page.LeadPartA_ApprovalForm_VF_PDF;
        PDF.getParameters().put('leadId',leadId);
        
        String documentPDF;
        
        try {
            documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
            
        }catch(Exception e) {
            // Generic exception handling code here.
        }
        String body =  '{'+
            '  "status":"sent",'+
            '  "enableWetSign": "false",'+
            '  "emailBlurb":"",'+
            '  "emailSubject": "Diagnosis Verification Form",'+
            '  "enforceSignerVisibility":"True",'+
            '  "documents": [{'+
            '      "name": "document.pdf",'+
            '      "documentId":"1",'+
            '      "order":"1",'+
            '      "documentBase64":"'+documentPDF+'"'+
            '  }],'+
            '"recipients": {'+
            '    "signers" : [{'+
            '      "email": "'+currLead.Treating_Medical_Professional_Email__c+'",'+
            '      "name": "'+currLead.Treating_Medical_Professional_First_Name__c+' '+currLead.Treating_Medical_Professional_Last_Name__c+'",'+
            '      "recipientId":"1",'+
            '      "clientUserId":"1",'+
            '      "tabs": {'+
            '                "signHereTabs": [{'+
            '                    "anchorString": "~s1",'+
            '                    "anchorXOffset": "0.6",'+
            '                    "anchorYOffset": "0.1",'+
            '                    "anchorIgnoreIfNotPresent": "false",'+
            '                    "anchorUnits": "inches"'+
            '                }]'+
            '            }'+
            '    }],'+
            '                "dateSignedTabs": [{'+
            '                      "anchorString": "~date",'+
            '                       "anchorXOffset": "0",'+
            '                       "fontSize":      "Size14",'+
            '                       "fontColor":     "Black",'+
            '                        "anchorYOffset": "0",'+
            '                        "anchorIgnoreIfNotPresent": "false",'+
            '                        "xPosition": "100",'+
            '                        "yPosition": "72",'+
            '                        "anchorUnits": "inches"'+
            '                    }]'+
            '  }'+
            '}';
        
        String header = '--'+boundary+'\nContent-Type: application/json\nContent-Disposition: form-data';
        String jsonBody = header +'\n\n'+body+'\n\n--'+boundary+'--';
        system.debug(jsonBody);
        //Callout to Docusign.
        HttpRequest req = new HttpRequest();
        req.setHeader('X-DocuSign-Authentication', authorizationHeader);
        req.setHeader('Accept','application/json');
        req.setHeader('Host','demo.docusign.net');
        req.setHeader('Content-Length','162100');
        req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
        req.setEndpoint(endpoint);
        req.setMethod('POST'); 
        req.setBody(jsonBody);
        Http http = new Http();
        HTTPResponse res;
        res = http.send(req);
        system.debug(res.getBody());
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        if((String) results.get('envelopeId')!=''){
            String env = (String) results.get('envelopeId');
            string endpoint2 = endPointURL+'/accounts/'+account+'/envelopes/'+env+'/views/recipient';
            HttpRequest request = new HttpRequest();
            request.setHeader('X-DocuSign-Authentication', authorizationHeader);
            request.setHeader('Accept','application/json');
            request.setHeader('Host','demo.docusign.net');
            request.setHeader('Content-Length','162100');
            request.setHeader('Content-Type','application/json');
            request.setMethod('POST'); 
            Http httprequest = new Http();
            HTTPResponse response;
            request.setEndpoint(endpoint2);
            string jsonPayload;
            system.debug('URL.getSalesforceBaseUrl().toExternalForm()'+URL.getSalesforceBaseUrl().toExternalForm());
            jsonPayload = '{'+
                '    "userName": "'+currLead.Treating_Medical_Professional_First_Name__c+' '+currLead.Treating_Medical_Professional_Last_Name__c+'",'+
                '    "email": "'+currLead.Treating_Medical_Professional_Email__c+'",'+
                '    "recipientId": "1",'+
                '    "clientUserId": "1",'+
                '    "authenticationMethod": "None",'+
                '    "returnUrl": "'+currentRequestURL+'/verification_success'+'"'+
                '}';     
            request.setBody(jsonPayload);
            response = httprequest.send(request); 
            results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            if((String) results.get('url') != '' || (String) results.get('url') != null){
                dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                dsfs.dsfs__DocuSign_Envelope_ID__c = env;
                dsfs.dsfs__Lead__c= currLead.Id;
                Insert dsfs;  
                PageReference reference=new PageReference((String) results.get('url'));
                return reference;
                
            }
        }
        return null;
    }
    
}