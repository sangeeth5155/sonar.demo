/* Created by : MST
Description : This class will be used to create LMS Orientation Registration response from the call out response.
*/
public class LMSOrientationRegistrationResponse{
    public Integer id;  //50174739
    public Integer user_id; //2567858
    public Integer account_id;  //810
    public Integer course_id;   //128763
    public String enrolled_on;  //2016-08-15T13:27:56.060-04:00
    public String due_on;
    public String started_on;
    public String completed_on; //2016-08-15T15:17:03.215-04:00
    public String expires_on;
    public String status;   //dropped
    public String progress; //0
    public String score;
    public Integer currtime;    //0
    public String updated_on;   //2016-08-15T15:17:03.455-04:00
    public String code;
    public String completed_activities_count;
    public String attachments_count;
    public boolean is_initial_enrollment;
    public String updated_by;   //API
    public boolean accepted_invite;
    public String pre_assessment_score;
    public String pre_assessment_status;
    public String created_by;   //API
    public String graded_by_instructor_id;
    public String created_on;   //2016-08-15T13:27:56.060-04:00
    public String curriculum_activities_version;
    public String user_code;    //sai@vignesh.com
    
    public static LMSOrientationRegistrationResponse parse(String json){
        return (LMSOrientationRegistrationResponse) System.JSON.deserialize(json, LMSOrientationRegistrationResponse.class);
    }


}