/* Created by : MST
Description : This class will be used to create JSON for LMS User Request Call.
*/
public class LMSUserRequest{
    public String login;    //sailappa@test.com
    public String first_name;   //sailappa
    public String last_name;    //pg
    public String email;    //sailappar@test.com
    public String password; //sailappa
    public String chapter_id; //sailappa
    public static LMSUserRequest parse(String json){
        return (LMSUserRequest) System.JSON.deserialize(json, LMSUserRequest.class);
    }
}