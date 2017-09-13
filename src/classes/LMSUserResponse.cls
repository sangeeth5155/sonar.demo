/* Created by : MST
Description : This class will be used to parse LMS user Response from the Call out.
*/
public class LMSUserResponse{
	public Integer id;	//2563608
	public String login;	//sailappa@test.com
	public String code;	//1234
	public String first_name;	//sailappa
	public String last_name;	//pg
	public String email;	//sailappar@test.com
	public boolean is_active;
	public String last_login_at;	//2016-08-04T19:20:05.407-04:00
	public static LMSUserResponse parse(String json){
		return (LMSUserResponse) System.JSON.deserialize(json, LMSUserResponse.class);
	}
	
}