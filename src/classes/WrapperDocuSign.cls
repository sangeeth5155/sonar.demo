public class WrapperDocuSign { 
public String envelopeId; 
public String uri; 
public String statusDateTime; 
public String status; 
public static WrapperDocuSign parse(String json){

return (wrapperDocusign)System.JSON.deserialize(JSON,WrapperDocuSign.class); 

} 

}