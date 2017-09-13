public class LMSOrientationUpdateRequest{
    public String user_login;   //user@test.com
    public String course_code;  //wish101
    public String status;   //dropped
    public static LMSOrientationUpdateRequest parse(String json){
        return (LMSOrientationUpdateRequest) System.JSON.deserialize(json, LMSOrientationUpdateRequest.class);
    }
   
}