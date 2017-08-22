public class LiveAgent_DefaultChatWindowController {
    
    public string agentTypingString {get;set;}
    public string userNameString {get;set;}

    public LiveAgent_DefaultChatWindowController(){
        agentTypingString='';
        userNameString = popUserNameString();
    }


    public String popUserNameString(){
        String retVal = 'Agent ';
        User[] us = [select firstname, lastname, id from User where ID =:UserInfo.getUserId()];
        if(!us.isEmpty()){
            retVal =  us[0].firstname + ' ' + us[0].lastname.substring(0,1);
        }    
       return retVal;
    }

    @RemoteAction
    public static String getAgentName(String userId)
    {
        User[] us = [select firstname, lastname, id from User where ID =:userId];
        if(!us.isEmpty()){
            return us[0].firstname + ' ' + us[0].lastname.substring(0,1) + '. is typing a message ...';
        }
        return null;
    }
}