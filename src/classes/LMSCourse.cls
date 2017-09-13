/*Created by : MST 
Description : This class is used to convert the Course response JSON from LMS to LMSCourse */

public class LMSCourse{
    public Integer id;  //1234
    public String name; //WishGranting101-Arizona
    public String created_on;   //2015-03-12T14:50:31-05:00
    public String credit_units; //1.0
    public boolean is_active;
    public String summary;  //Basicwishgrantertraining
    public Double duration; //12.2
    public String completion_type;  //pass/fail
    public String type; //elearning
    public String subtype;  //granting
    public static LMSCourse parse(String json){
        return (LMSCourse) System.JSON.deserialize(json, LMSCourse.class);
    }

   
}