/* Created by : MST
Description : This class will be used to parse LMS SSO Response from the Call out.
*/
public class LMSSSORespose{
	public Integer account_id;	//810
	public Integer id;	//2369897
	public Integer user_id;	//2563608
	public String token;	//wNiX17x7YsrmJREVJuNkWdbW
	public String created_on;	//2016-08-04T19:30:29-04:00
	public String login_url;	//https://wish.exceedlms-staging.com/authentication/token_sign_on?user_id=2563608&token=wNiX17x7YsrmJREVJuNkWdbW
	public String enrollment_url; //https://wish.exceedlms-staging.com/student/home/show_enrollment/50174739
	public static LMSSSORespose parse(String json){
		return (LMSSSORespose) System.JSON.deserialize(json, LMSSSORespose.class);
	}
	
}