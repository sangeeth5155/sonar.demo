/* Created by : MST
Description : This class will be used to create LMS Orientation Registration Request for the Call out.
*/
public class LMSOrientationRegistrationRequest {
    public String course_code;  //wish101
    public String user_login;   //user@test.com
    public String status;   //dropped
    public static LMSOrientationRegistrationRequest parse(String json){
        return (LMSOrientationRegistrationRequest) System.JSON.deserialize(json, LMSOrientationRegistrationRequest.class);
    }    
}