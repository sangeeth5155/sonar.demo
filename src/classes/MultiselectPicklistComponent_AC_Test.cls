@isTest
public class MultiselectPicklistComponent_AC_Test {
    
    public static testmethod void doTest () {
        
        MultiselectPicklistComponent_AC cont = new MultiselectPicklistComponent_AC();
        List<String> rightOrginValueList = new List<String>{'Sam', 'Jaba','Jonathan', 'Edwards','Mike', 'Ricky'};
        List<String> rightSelectedValueList = new List<String>{'Sam', 'Jaba'};
        List<String> leftSelectedValueList = new List<String>{'Jonathan', 'Mike'};
        Set<String> leftValues = new Set<String>{'Jonathan'};
        Set<String> rightValues = new Set<String>{'Sam'};
        cont.rightOriginalvalues = rightOrginValueList;
        cont.rightselected = rightSelectedValueList;
        cont.leftselected = leftSelectedValueList;
        cont.selectclick();
        cont.unselectclick();
        cont.getunSelectedValues();
        cont.getSelectedValues();
    }
}