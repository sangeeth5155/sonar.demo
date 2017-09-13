public class MultiselectPicklistComponent_AC 
{
    public List<String> leftoriginalvalues{get;set;}
    public List<String> rightOriginalvalues{get;set;}
    Public List<string> leftselected{get;set;}
    Public List<string> rightselected{get;set;}
    public List<String> currRightString{get;set;}
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
   
    Map<String,String> rightMap = new Map<String,String>();
    Map<String,String> leftMap = new Map<String,String>();

    public MultiselectPicklistComponent_AC(){
        leftoriginalvalues = new List<String>();
        rightOriginalvalues = new List<String>();
        currRightString = new List<String>();
        leftselected = new List<String>();
        rightselected = new List<String>();
       
     }
     
    public PageReference selectclick(){
        rightselected.clear();
       
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
            rightMap.put(s,s);
            leftMap.remove(s);
        }
        leftoriginalvalues.addAll(leftMap.keySet());
        rightOriginalvalues.addAll(rightMap.keySet());
        currRightString.addAll(rightMap.keySet());
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
       
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
            rightMap.remove(s);
            leftMap.put(s,s);
        }
         leftoriginalvalues.addAll(leftMap.values());
         rightOriginalvalues.addAll(rightMap.values());
         currRightString.addAll(rightMap.keySet());
         
         System.debug('leftoriginalvalues++++++++++++++++++++++++++++++++ ' +leftoriginalvalues);
         System.debug('rightOriginalvalues++++++++++++++++++++++++++++++++ ' +rightOriginalvalues);
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
       
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        for(String currString : leftoriginalvalues)
        {
             leftMap.put(currString,currString);
        }
        leftoriginalvalues.clear();
        
        tempList.addAll(leftMap.values());
        tempList.sort();
        for(string s : tempList)
        {
            leftvalues.add(s);
            options.add(new SelectOption(s,s));
        }
            
        return options;
    }
 
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
   
        for(String currString : rightOriginalvalues)
        {
             rightMap.put(currString,currString);
        }
        rightOriginalvalues.clear();
        tempList.addAll(rightMap.values());
        tempList.sort();
        for(String s : tempList)
        {
            options1.add(new SelectOption(s,s));
            rightvalues.add(s);
        }
            
        return options1;
    }
}