public class TravelAlgorithmWrapper {
    public boolean infectious{get;set;}
    public boolean airborne{get;set;}
    public boolean pneumothorax{Get;set;}
    public boolean pleural{get;set;}
    public boolean lungDisease{get;set;}
    public boolean oxygen{get;set;}
    public boolean longTermOxygen{get;set;}
    public boolean respiratoryIllness{get;set;}
    public boolean seaLevel{get;set;}
    public boolean hypertension{get;set;}
    public boolean ventilator{get;set;}
    public boolean uncontrolledHypertension{get;set;}
    public boolean surgeryinTwoMonths{get;set;}
    public boolean angina{get;set;}
    public boolean arrhythmia{get;set;}
    public boolean heartFailure{get;set;}
    public boolean chronicHeartFailure{get;set;}
    public boolean congenitalHeartDisease{get;set;}
    public boolean chronicHepatitis{get;set;}
    public boolean majorBleeding{get;set;}
    public boolean symptomaticAnemia{get;set;}
    public boolean sickleCellAnemia{get;set;}
    public boolean intracranialPressure{get;set;}
    public boolean convulsiveDisorder{get;set;}
    public boolean strokes{get;set;}
    public boolean panicDisorder{get;set;}
    public boolean portalHypertension{get;set;}
    public boolean esophagealVarices{get;set;}
    public boolean portopulmonaryHypertension{get;set;}
    public boolean heptopulmonarySyndrome{get;set;}
    public boolean liverDisease{get;set;}
    public boolean acuteoRChronicHepatitis{get;set;}
    public boolean notApplicable{get;set;}
    public boolean noneApply {get;set;}
    public boolean iamNotSure {get;set;}    
    public string chronicHepatitisString{get;set;}
    public string pulmonaryHypertensionString{get;set;}
    public String strokesType{get;set;}
    public List<String> convulsiveDisorders{get;set;}
    public List<String> congenitalHeartDiseaseString{get;set;}
    public List<String> chronicHeartFailureString{get;set;}
    public List<String> heartFailureString{get;set;}
    public List<String> ArrhythmiaString{get;set;}
    public List<String> anginaString{get;set;}
    public List<String> ventilatorString{get;set;}
    public List<String> lungDiseaseString{get;set;}
    public String ventilatorText{get;set;}
    public List<String> travelAgroithmList {get;set;}
    public Set<String> travelSet;
     public String algList;
    Public TravelAlgorithmWrapper(){
        infectious = false;
        airborne = false;
        pneumothorax = false;
        pleural = false;
        lungDisease = false;
        oxygen = false;
        longTermOxygen = false;
        respiratoryIllness = false;
        seaLevel = false;
        hypertension = false;
        ventilator = false;
        uncontrolledHypertension = false;
        surgeryinTwoMonths = false;
        angina = false;
        arrhythmia = false;
        heartFailure = false;
        chronicHeartFailure = false;
        congenitalHeartDisease = false;
        chronicHepatitis = false;
        majorBleeding = false;
        symptomaticAnemia = false;
        sickleCellAnemia = false;
        intracranialPressure = false;
        convulsiveDisorder = false;
        strokes = false;
        panicDisorder = false;
        portalHypertension = false;
        esophagealVarices = false;
        portopulmonaryHypertension = false;
        heptopulmonarySyndrome = false;
        liverDisease = false;
        acuteoRChronicHepatitis = false;
        notApplicable = false;
        noneApply = false;
        iamNotSure = false;
        ventilatorText = '';
        convulsiveDisorders = new List<String>();
    	congenitalHeartDiseaseString = new List<String>();
        chronicHeartFailureString = new List<String>(); 
    	heartFailureString = new List<String>(); 
    	ArrhythmiaString = new List<String>(); 
    	anginaString = new List<String>(); 
    	ventilatorString = new List<String>(); 
    	lungDiseaseString = new List<String>(); 
    }
      public List<SelectOption> getLungDiseaseList() {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select That All Apply',true));
        options.add(new SelectOption('Vital capacity less than 1 liter or less than 20 ml/kg','Vital capacity less than 1 liter or less than 20 ml/kg'));
        options.add(new SelectOption('current or frequent hypoxemia','current or frequent hypoxemia'));
        options.add(new SelectOption('current or frequent hypercapnia','current or frequent hypercapnia'));
        options.add(new SelectOption('FEV1 less than 50% predicted','FEV1 less than 50% predicted'));
        options.add(new SelectOption('Required long-term oxygen in the past 6 months','Required long-term oxygen in the past 6 months'));
        options.add(new SelectOption('Oxygen dependence at sea level','Oxygen dependence at sea level'));
        options.add(new SelectOption('I do not know','I do not know'));
        options.add(new SelectOption('Not Applicable','Not Applicable'));
        return options;        
    }
    Public List<SelectOption> getventilatorList() {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select',true));
        options.add(new SelectOption('I am the treating provider for the ventilator','I am the treating provider for the ventilator'));
        options.add(new SelectOption('I am not the treating provider for the ventilator','I am not the treating provider for the ventilator'));
        return options;
    }
    public List<SelectOption> getanginaList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select That All Apply',true));
        options.add(new SelectOption('CCS Class III','CCS Class III'));
        options.add(new SelectOption('CCS Class IV','CCS Class IV'));
        options.add(new SelectOption('Chest pain with everyday living activities with moderate limitations','Chest pain with everyday living activities with moderate limitations'));
        options.add(new SelectOption('Chest pain on minimal exertion with no change to symptoms or medication in the last 6 weeks','Chest pain on minimal exertion with no change to symptoms or medication in the last 6 weeks'));
        options.add(new SelectOption('Is unable to perform any activity without chest pain or is experiencing chest pain at rest and/or severe limitation','Is unable to perform any activity without chest pain or is experiencing chest pain at rest and/or severe limitation'));
        options.add(new SelectOption('Chest pain at rest','Chest pain at rest'));
        options.add(new SelectOption('Change in symptoms and/or medication in the past 6 weeks','Change in symptoms and/or medication in the past 6 weeks'));
        options.add(new SelectOption('I do not know','I do not know'));
        options.add(new SelectOption('Not Applicable','Not Applicable'));
        return options;
    }    
    public List<SelectOption> getArrhythmiaList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select That All Apply',true));
        options.add(new SelectOption('Unstable arrhythmia','Unstable arrhythmia'));
        options.add(new SelectOption('High-grade premature ventricular contractions','High-grade premature ventricular contractions'));
        options.add(new SelectOption('Recent ablation therapy','Recent ablation therapy'));
        options.add(new SelectOption('Internal Cardiac Defibrillator (ICD) – the device has delivered a shock, individual is unstable','Internal Cardiac Defibrillator (ICD) – the device has delivered a shock, individual is unstable'));
        options.add(new SelectOption('Internal Cardiac Defibrillator (ICD) – the device has delivered a shock, the individual has been stable for at least 6 weeks','Internal Cardiac Defibrillator (ICD) – the device has delivered a shock, the individual has been stable for at least 6 weeks'));
        options.add(new SelectOption('Valve disease of functional class IV or is experiencing chest pain or syncope','Valve disease of functional class IV or is experiencing chest pain or syncope'));
        options.add(new SelectOption('Pacemaker placement less than one week ago','Pacemaker placement less than one week ago'));
        options.add(new SelectOption('I do not know','I do not know'));
        options.add(new SelectOption('Not Applicable','Not Applicable'));
        return options;
    }    
    public List<SelectOption> getheartFailureList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select That All Apply',true));
        options.add(new SelectOption('Hospitalized or treated for pleural effusion in past 6 weeks','Hospitalized or treated for pleural effusion in past 6 weeks'));
        options.add(new SelectOption('Hospitalized or treated for dyspnea in past 6 weeks','Hospitalized or treated for dyspnea in past 6 weeks'));
        options.add(new SelectOption('I do not know','I do not know'));
        options.add(new SelectOption('Not Applicable','Not Applicable'));
        return options;
    }  
    public List<SelectOption> getHepatitisValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        options.add(new SelectOption('Impaired gas exchange', 'Impaired gas exchange')); 
        options.add(new SelectOption('Not Applicable', 'Not Applicable')); 
        return options;
    }  
    public List<SelectOption> getPulmonaryHypertensionValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        options.add(new SelectOption('with intrapulmonary shunting', 'with intrapulmonary shunting')); 
        options.add(new SelectOption('without intrapulmonary shunting', 'without intrapulmonary shunting')); 
        return options;
    }  
    public List<SelectOption> getStrokeValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        options.add(new SelectOption('Frequent or crescendo transient ischemic attacks or strokes', 'Frequent or crescendo transient ischemic attacks or strokes')); 
        options.add(new SelectOption('Not Applicable', 'Not Applicable')); 
        return options;
    } 
    public List<SelectOption> getconvulsiveDisorderList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select That All Apply',true));
        options.add(new SelectOption('Currently, frequent uncontrolled, prolonged, generalized seizures that last >5min without cessation after abortive seizure medication treatmentut cessation after abortive seizure medication treatment', 'Currently, frequent uncontrolled, prolonged, generalized seizures that last >5min without cessation after abortive seizure medication treatment')); 
        options.add(new SelectOption('Has had a seizure in the last 24 hours', 'Has had a seizure in the last 24 hours')); 
        options.add(new SelectOption('I do not know','I do not know'));
        options.add(new SelectOption('Not Applicable','Not Applicable')); 
        return options;
    }  
    public List<SelectOption> getcongenitalHeartDiseaseList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select That All Apply',true));
        options.add(new SelectOption('NYHA class IV', 'NYHA class IV')); 
        options.add(new SelectOption('Dyspnea at rest', 'Dyspnea at rest')); 
        options.add(new SelectOption('Mainly bedbound due to heart disease', 'Mainly bedbound due to heart disease')); 
        options.add(new SelectOption('Change in symptoms and/or medication in the past 6 weeks', 'Change in symptoms and/or medication in the past 6 weeks')); 
        options.add(new SelectOption('Dyspnea on exertion', 'Dyspnea on exertion')); 
        options.add(new SelectOption('I do not know','I do not know'));
        options.add(new SelectOption('Not Applicable','Not Applicable')); 
        return options;
    }  
    public List<SelectOption> getchronicHeartFailureList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select That All Apply',true));
        options.add(new SelectOption('NYHA Class IV','NYHA Class IV'));
        options.add(new SelectOption('NYHA Class III','NYHA Class III'));
        options.add(new SelectOption('Is unable to carry on any physical activity without discomfort','Is unable to carry on any physical activity without discomfort'));
        options.add(new SelectOption('Has symptoms of heart failure at rest','Has symptoms of heart failure at rest')); 
        options.add(new SelectOption('Has discomfort that increases with any physical activity','Has discomfort that increases with any physical activity'));
        options.add(new SelectOption('Is dyspnea at rest','Is dyspnea at rest'));
        options.add(new SelectOption('Has a change in symptoms and/or medication in the past 6 weeks','Has a change in symptoms and/or medication in the past 6 weeks'));
        options.add(new SelectOption('I do not know','I do not know'));
        options.add(new SelectOption('Not Applicable','Not Applicable'));
        return options;
    } 
}