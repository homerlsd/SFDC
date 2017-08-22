global class Utils {
	
    //UNCOMMENT FOR WEBSERVICE CALLOUT WHEN AUTHN IS READY FOR US - AMR 7.9.15
    
	/*public AdminDBJSON callAdminDB(String Username) {
        HttpRequest req = new HttpRequest();
                        
        //String apiKey = API_KEY__c.getInstance('AdminDB Key') != null ? API_KEY__c.getInstance('AdminDB Key').API_Key__c : '';
        
        String apiKey = '';

        req.setEndpoint('https://SOMEURLTOPOSTTO/SOMEENDEPOINTNONSENSE?api_key=' + apiKey + '&username=' + username);
        req.setMethod('GET');
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setCompressed(true);

        try {
            res = http.send(req);
            string jresp = res.getBody();
            
            //might have to check null here, depends on how AdminDB handles this
            AdminDBJSON myClass = AdminDBJSON.parse(jresp);

            if(myClass != null)
            	return myClass;
            else
            	return null;
            	
        } 
        catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
            return null;
        }
    }*/

    public static Map<integer, integer> getCalendarMap(){
        Map<integer, integer> intmap = new Map<integer, integer>();
        intmap.put(1,31);
        intmap.put(2,28);
        intmap.put(3,31);
        intmap.put(4,30);
        intmap.put(5,31);
        intmap.put(6,30);
        intmap.put(7,31);
        intmap.put(8,31);
        intmap.put(9,30);
        intmap.put(10,31);
        intmap.put(11,30);
        intmap.put(12,31);
        return intmap;
    }

    public static void addSingleErrorLog(Utils.ApexError[] errorList){     
        List<System_Log__c> errors = new List<System_Log__c>();

        for(Utils.ApexError ae : errorList){
            System_Log__c errorLog = new System_Log__c();
            errorLog.recordTypeId = LABEL.DEFAULT_ERRORLOG_RECORDTYPE_ID;
            errorLog.Record_Id__c = ae.recordID;
            if(ae.recordID != null && ae.recordID != '')
                errorLog.Object_Type__c = id.ValueOf(ae.recordID).getSObjectType().getDescribe().getName();
            errorLog.Page_Process__c = ae.pageOrProcess;
            errorlog.Error_Message__c = ae.errorString;
            errorLog.User__c = ae.userId;
            errors.add(errorLog);
        }
              
        // as this method is static, we will insert the error straight away
        Database.insert(errors, false); 
        
    }

    global class ApexError{
        
        global string recordID          {get; set;}
        global String pageOrProcess          {get; set;}
        global String userId          {get; set;}
        global string errorString       {get; set;}
        global DateTime timeStamp       {get; set;}
    
    }

    public static String DateTimeToSoqlDateTime(DateTime dt) {
        // DateTime no Miliseconds formats like YYYY-MM-DDTHH:mm:SS
        return String.ValueOf(dt).Replace(' ', 'T') + 'Z';
    }

    public static String DateToSoqlDate(Date d) {
        // Date format in SOQL can't have the time
        return String.ValueOf(d).Replace(' 00:00:00', '');
    }

    //CHANNEL WORK//
    // Auto-Caching channels
    private static List<Sales_Channel__c> chans_p;
    public static List<Sales_Channel__c> Channels {
        get {
            if (chans_p == null)
                chans_p = [select Id, Name, Unapproved_Record_Type_ID__c, Approved_Record_Type_Id__c, DNIS_Formula__c,Case_Record_Type_ID__c from Sales_Channel__c];
            return chans_p;
        }
    }

    //Partner WORK//
    // Auto-Caching Partners
    private static List<Partner__c> partner_p;
    public static List<Partner__c> Partners {
        get {
            if (partner_p == null)
                partner_p = [select Id, name,Support_Number_Formula__c from Partner__c];
            return partner_p;
        }
    }

     //Partner WORK//
    // Auto-Caching Gateways
    private static List<Gateway__c> gateway_p;
    public static List<Gateway__c> fwdingGateways {
        get {
            if (gateway_p == null)
                gateway_p = [select Id, DNIS_Formula__c from Gateway__c where Suppress_Case_Creation__c = true];
            return gateway_p;
        }
    }

    //Partner WORK//
    // Auto-Caching Gateways2
    private static List<Gateway__c> gateway_all;
    public static List<Gateway__c> allGateways {
        get {
            if (gateway_all == null)
                gateway_all = [select Id, DNIS_Formula__c,Partner__c,Channel__c from Gateway__c where Active__c = true];
            return gateway_all;
        }
    }


    public static Set<Id> ChannelRecordTypeIDs(String channel) {

        Set<Id> chanIds = new Set<Id>();

        // Go through every channel object
        for (Sales_Channel__c c : Channels) {
            if (c.Name.equalsIgnoreCase(channel)) {
                chanIds.add(c.Unapproved_Record_Type_Id__c);
                chanIds.add(c.Approved_Record_Type_Id__c);
            }
        }
        
        return chanIds;
    }

    public static string KnowledgeArticleName(id kavID){
        Question__Kav[] qs = database.query(CC_Constants.BASE_QUERY + ' AND ID = : kavID');
        if(!qs.isEmpty())
            return qs[0].title;
        else
            return null;
    }

    public static Set<string> findUserPermissions(string useID){
        Set<string> newSet = new Set<string>();
        //first check the actual permission sets that are prepended with "User Property"
        for(PermissionSetAssignment pe: [select PermissionSet.Name, PermissionSet.label
                                                from PermissionSetAssignment
                                                where Assignee.Id = :useId
                                                order by PermissionSet.Name]){
            
            system.debug('PERMISSION SET NAME IS ' + pe.PermissionSet.label);

            if(pe.PermissionSet.label.containsIgnoreCase('User Property')){
                string temp = pe.PermissionSet.label.Replace('User Property: ', '');
                newSet.add(temp);
            }
        }
        //check metadata property object where applicable
        for(Metadata_Property__c mp : [select id, Properties__c from Metadata_Property__c where ((Metadata_Type__c = 'Profile' AND Metadata_ID__c = : userInfo.getProfileID()) OR (Metadata_Type__c = 'Role' AND Metadata_ID__c = : userInfo.getUserRoleID()))]){
            if(mp.Properties__c != null && mp.Properties__c != ''){
                List<string> tempList = mp.Properties__c.split(';');    
                system.debug('tempList is ' + tempList);
                if(!tempList.isEmpty())
                    newset.addall(tempList);
            }
        }

        return newSet;
    }

    public static id getNextAccountID(){
        id rallyAcctID;

        for (AggregateResult a :  [select Count(ID) cnt, AccountId from Contact where Account.RecordType.Name = 'Consumer Support' GROUP BY AccountId ORDER BY Count(ID)]) {
            rallyAcctID = String.ValueOf(a.get('AccountId'));
            break;
        }

        return rallyAcctID;
    }

    public static Sales_Channel__c GetChannelFromDNIS(string dnis){
        //Get the Rally account to associate newly created Contacts to it.
        for(Sales_Channel__c sc : channels){
            if(sc.DNIS_Formula__c == dnis){
                return sc;
            }
        }
        return null;
    }

    public static Partner__c GetPartnerFromDNIS(string dnis){
        //Get the Rally account to associate newly created Contacts to it.
        for(Partner__c p : partners){
            if(p.Support_Number_Formula__c == dnis){
                return p;
            }
        }
        return null;
    }

    public static boolean suppressCaseCreate(string dnis){
         //Get the Rally account to associate newly created Contacts to it.
        for(Gateway__c g : fwdingGateways){
            if(g.DNIS_Formula__c == dnis){
                return true;
            }
        }
        return false;
    }

    public static Map<String,String> GetChannelIDFromDNIS(string dnis){
        //Get the Rally account to associate newly created Contacts to it.
        Map<String,String> mappy = new Map<String,String>();

        for(Gateway__c g : [select Channel__c, Channel__r.Case_Record_Type_ID__c FROM Gateway__c WHERE DNIS_Formula__c = : DNIS LIMIT 1]){
            system.debug('DO WE GET HERE ' + g.Channel__r.Case_Record_Type_ID__c);

            mappy.put(g.Channel__r.id, g.Channel__r.Case_Record_Type_ID__c);
            return mappy;
        }
        
        mappy.put('empty', 'set');

        return mappy;
    }

    public static ID GetGatewayID(string dnis){
        //Get the Rally account to associate newly created Contacts to it.
        Map<String,String> mappy = new Map<String,String>();

        Gateway__c[] gate = [select id FROM Gateway__c WHERE DNIS_Formula__c = : DNIS LIMIT 1];

        if(gate != null && gate.size() > 0){
            return gate[0].id;
        }
        else{
            return null;
        }
    }

     public static ID GetPartnerIDFromDNIS(string dnis){
        //Get the Rally account to associate newly created Contacts to it.
        for(Gateway__c g : allGateways){
            if(g.DNIS_Formula__c == dnis){
                return g.Partner__c;
            }
        }
        return null;
    }

    public static List<SelectOption> findxxOptions(string controllingValue, string step, string caseRtype, string caseChannel){
        List<selectOption> optionslist = new List<selectOption>();
        Set<string> setCheck = new Set<string>();
        boolean isStep1 = false;

        string query = 'select id, Controlling_field_Value__c,Dependent_field_value__c, Object_Name_for_Dependent_Picklist__c FROM Dependent_Picklist1__mdt';
        if(step == '1'){
            if(caseRtype == Label.UtilsFindXXOptions_EngageRecordtypeName)
                query += ' WHERE Record_Type_Name__c = NULL AND Step__c = 1.0 ORDER BY Controlling_field_Value__c ASC';
            else
                query += ' WHERE Record_Type_Name__c = \'' + caseRtype +'\' AND Channel_Name__c = \'' + caseChannel +'\' AND Step__c = 1.0 ORDER BY Controlling_field_Value__c ASC';
            
            isStep1 = true;
        }
        else{
            string safeString = string.escapeSingleQuotes(controllingValue);
            system.debug('SAFE STRING IS ' + safeString);
            if(caseRtype == Label.UtilsFindXXOptions_EngageRecordtypeName)
                query += ' WHERE Record_Type_Name__c = NULL AND Controlling_field_Value__c LIKE \'' + safeString +'\' ORDER BY Dependent_field_Value__c ASC';
            else
                query += ' WHERE Record_Type_Name__c = \'' + caseRtype +'\' AND Channel_Name__c = \'' + caseChannel +'\' AND Controlling_field_Value__c LIKE \'' + safeString +'\' ORDER BY Dependent_field_Value__c ASC';
        }

        system.debug('PICKLIST QUERY IS ' + query);

        if(isStep1 || (controllingValue != null && controllingValue != '')){

            List<Dependent_Picklist1__mdt> picks = database.query(query);

            system.debug('PICKS ARE ' + picks);

            for(Dependent_Picklist1__mdt q : picks){
                
                if(isStep1 && q.Controlling_field_value__c != null && (setCheck.isEmpty() || !setCheck.contains(q.Controlling_field_value__c))){
                    optionslist.add(new SelectOption(q.Controlling_Field_Value__c, q.Controlling_Field_Value__c));
                    setCheck.add(q.Controlling_field_value__c);
                }
                else if(!isStep1 && q.Dependent_field_Value__c != null && (setCheck.isEmpty() || !setCheck.contains(q.Dependent_field_Value__c))){
                    optionslist.add(new SelectOption(q.Dependent_field_Value__c, q.Dependent_field_Value__c));
                    setCheck.add(q.Dependent_field_Value__c);
                }
            }
        }

        return optionslist;
    }

    global static Map<string, integer> findSecondsMapFromString(string[] timeStamps){
        
        Map<string,integer> tempMap = new Map<string,integer>();

        for(string s : timeStamps){
            if(s != '')
                tempMap.put(s, findSecondsFromString(s));
        }                                                
        
        system.debug('SECONDS MAP IS  ' +tempMap); 

        return tempMap;
    }

    global static integer findSecondsFromString(string timeStamp){
        integer seconds = 0;                                                
        
        List<string> timeStamps = timeStamp.split(':');
        system.debug(timeStamps); 
        //hours                                                
        if(integer.valueOf(timeStamps[0]) > 0){
            seconds += integer.valueOf(timeStamps[0])*3600;
        } 
        //minutes
        if(integer.valueOf(timeStamps[1]) > 0){
            seconds += integer.valueOf(timeStamps[1])*60;
        }   
        //seconds                          
        if(integer.valueOf(timeStamps[2]) > 0){
            seconds += integer.valueOf(timeStamps[2]);
        }       
        system.debug('seconds ' +seconds); 

        return seconds;
    }

    public static decimal getNPSScore(string userID, string origin, date dt){
        integer posCount = 0;
        integer negCount = 0;
        integer totalCount = 0;
        decimal score = 0;

        integer lookback = integer.valueOf(Label.Utils_NPSLookbackDays);
        date dtplus = dt.addDays(-lookback);

        system.debug('CALL DATE IS ' + dt);
        system.debug('LOOKBACK DATE IS ' + dtplus);

        for(surveyQuestionResponse__c nps : [select id,
                                                    createddate,
                                                    NPS_Score_Field__c,
                                                    SurveyTaker__c
                                                    from surveyQuestionResponse__c
                                                    where SurveyTaker__r.Case__r.Initial_Case_Closer__c = :userId
                                                    AND Is_Agent_Question__c = true
                                                    AND SurveyTaker__r.Case__r.origin =: origin
                                                    AND SurveyTaker__r.CreatedDate <=: dt
                                                    AND SurveyTaker__r.CreatedDate >=: dtplus]){
                
                totalCount++;
                if(nps.NPS_Score_Field__c <= 6)
                    negCount++;
                else if(nps.NPS_Score_Field__c >= 9)
                    posCount++;
        }

        system.debug('TOTAL COUNT OF SURVEY RESULTS - '+totalCount);

        if(totalCount == 0)
            score = 1000;
        else {
            decimal numerat = posCount - negCount;
            decimal denomo = totalCount;
            
            score = numerat/denomo;
            
            system.debug('RAW SCORE IS ' + score);
            
            score = score*100;
        }

        system.debug('WHAT IS THE MATH ' + posCount+'-'+negCount+'/'+totalCount);
        system.debug('WHAT IS THE SCORE ' + score);
        return score;
    }

    /*public static decimal getNPSScore(string userID, date startDate, date endDate){
        integer posCount = 0;
        integer negCount = 0;
        integer totalCount = 0;
        decimal score = 0;
        Set<ID> checkSet = new Set<ID>();

        for(surveyQuestionResponse__c nps : [select id,
                                                    NPS_Score_Field__c,
                                                    SurveyTaker__c
                                                    from surveyQuestionResponse__c
                                                    where SurveyTaker__r.Case__r.Initial_Case_Closer__c = :userId
                                                    AND NPS_Score_Field__c != NULL
                                                    AND SurveyTaker__r.CreatedDate >= : startDate
                                                    AND SurveyTaker__r.CreatedDate < : endDate]){
                
                checkSet.add(nps.SurveyTaker__c);

                totalCount++;
                if(nps.NPS_Score_Field__c <= 6)
                    negCount++;
                else if(nps.NPS_Score_Field__c >= 9)
                    posCount++;
        }

        if(checkSet.isEmpty() || (!checkset.isEmpty() && checkSet.size() <= 3))
            score = 100;
        else {
            score = ((posCount-negCount)/totalCount)*100;
        }

        return score;
    }*/

    public static Set<String> getFilteredToAddresses(){
        Set<string> toSet = new Set<string>();

        for(Inbound_Email_Address_Filter__mdt em : [select id, email_address__c from Inbound_Email_Address_Filter__mdt]){
            toSet.add(em.email_address__c);
        }

        return toSet;
    }

    public static Map<String,string> getFilteredTerms(){
        Map<string,string> toMap = new Map<string,string>();

        for(Inbound_Email_Term_Route__mdt em : [select id, Matching_Term__c,Routing_ID__c from Inbound_Email_Term_Route__mdt]){
            toMap.put(em.Matching_Term__c, em.Routing_ID__c);
        }

        return toMap;
    }

    public static Set<string> getFilteredSubjectTerms(){
        Set<string> sett = new Set<string>();

        for(Inbound_Subject_Line_Filter__mdt em : [select id, label from Inbound_Subject_Line_Filter__mdt]){
            sett.add(em.label);
        }

        return sett;
    }

    public static Set<string> getFilteredObjects(){
        Set<string> sett = new Set<string>();

        for(Filtered_Object__mdt em : [select id, label from Filtered_Object__mdt]){
            sett.add(em.label);
        }

        return sett;
    }

    public static Set<string> getFilteredLookups(string objName){
        Set<string> sett = new Set<string>();

        for(Filtered_Lookup__mdt em : [select id, Field_API_Name__c from Filtered_Lookup__mdt where Object_Name__c = :objName]){
            sett.add(em.Field_API_Name__c);
        }

        return sett;
    }

    public static Set<string> getFilteredLookupObjects(){
        Set<string> sett = new Set<string>();

        for(Filtered_Lookup__mdt em : [select id, Object_Name__c from Filtered_Lookup__mdt]){
            sett.add(em.Object_Name__c);
        }

        return sett;
    }

    public static Set<string> getDNCFields(string objName){
        Set<string> sett = new Set<string>();

        for(Do_not_clone_field__mdt dnc : [select id,label from Do_not_clone_field__mdt where Object_Name__c = :objName]){
            sett.add(dnc.label);
        }

        return sett;
    }  

    public static Map<String, String> getFilteredLookupMap(string objName){
        Map<String,string> sett = new Map<String,string>();

        for(Filtered_Lookup__mdt em : [select id, Field_API_Name__c, Lookup_Api_Name__c from Filtered_Lookup__mdt where Object_Name__c = :objName]){
            sett.put(em.Field_API_Name__c, em.Lookup_Api_Name__c);
        }

        return sett;
    }

    public static boolean isInBusinessHours(){
        BusinessHours bh = [SELECT Id FROM BusinessHours where name = : label.DEFAULT_Support_Business_Hours_Name];
        Boolean isWithin= BusinessHours.isWithin(bh.id, Datetime.now());
        return isWithin;
    }

    @future
    public static void SendTranscriptEmails(Set<ID> caseIDs){

        Map<ID,Case> caseMap = new Map<ID,Case>();

        for(case c : [select id, Thread_ID__c,Live_Agent_Transcript_Send_Email__c,Send_Live_Agent_Transcript__c,Email_Formula__c from Case where ID IN : caseIDs]){
            caseMap.put(c.id, c);
        }

        List<LiveChatTranscript> chats = [select Send_Transcript_Email__c, Transcript_Send_Address__c, CaseID from LiveChatTranscript where CaseID IN : caseMap.keyset()];

        for(LiveChatTranscript chat : chats){
            chat.Send_Transcript_Email__c = true;
            chat.Thread_ID__c = caseMap.get(chat.CaseID).Thread_ID__c;
            chat.Transcript_Send_Address__c = ((caseMap.get(chat.caseID).Live_Agent_Transcript_Send_Email__c == null || caseMap.get(chat.caseID).Live_Agent_Transcript_Send_Email__c == '') ? caseMap.get(chat.caseID).Email_Formula__c : caseMap.get(chat.caseID).Live_Agent_Transcript_Send_Email__c);
        }

        update chats;
    }

}