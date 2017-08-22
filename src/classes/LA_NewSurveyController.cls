global virtual class LA_NewSurveyController {
    
    public String surveyId                          {get; 
        set{
            this.surveyId = value;
            init();
        }
    }   

    public case c                                                            {get; set;}
    public List<case> cs                                                            {get; set;}
    public String  qQuestion                                                {get; set;}
    public Boolean qRequired                                                {get; set;}
    public Boolean showExtraSurvey                                          {get; set;}
    public Boolean isUHC                                                    {get; set;}
    public String  qChoices                                                 {get; set;}
    public String surveyName                                                {get; set;}
    public String surveyHeader                                              {get; set;}
    
    public String questionName                                              {get; set;}  
    public String questionType                                              {get; set;}
    public Boolean questionRequired                                         {get; set;}
    public List<SelectOption> singleOptions                                 {get; set;} 
    public List<question> allQuestions                                      {get; set;}
    public List<question> subQuestions                                      {get; set;}
    public Integer allQuestionsSize                                         {get; set;}
    public Integer subQuestionsSize                                         {get; set;}
    public String  templateURL                                              {get; set;}
    public String  surveyThankYouText                                       {get; set;}
    public String surveyContainerCss                                        {get; set;}
    public String  surveyThankYouURL                                        {get; set;}
    public String  caseId                                                   {get; set;}
    public String  chatkey                                                  {get; set;}
    public String contactId                                                 {get; set;}
    public String anonymousAnswer                                           {get; set;}
    public List<SelectOption> anonymousOrUser                               {get; set;}
    public String baseURL                                                   {get; set;}
    public String attachedRecords                                           {get; set;}
    public String disconnectedBy                                            {get; set;}
    
    public String userId                                                    {get; set;}
    public String userName                                                  {get; set;}
    public String surveyTakerId                                             {get; set;}

    public String rallyID                                                   {get; set;}
    public String communityID                                               {get; set;}
    public String brandingExperience                                        {get; set;}


    public Boolean thankYouRendered                                         {get; set;}
    
    public Boolean showAlreadyTakenError                                    {get; set;}
    public Boolean showRequiredError                                        {get; set;}
    public Boolean showBadURLError                                          {get; set;}
    public Boolean showNoAgentAvailable                                     {get; set;}
    public Boolean showClientTimeout                                        {get; set;}

    public pageReference templateName {get; set;}

    
    /* Retrieves the list of questions, the survey name, after retrieving the 
       necessary parameters from the url.
    */
 //------------------------------------------------------------------------------// 
    public LA_NewSurveyController(ApexPages.StandardController stdController) 
    {
        System.debug( 'START: LA_NewSurveyController.constructor()' );
        System.debug( 'Param: ApexPages.StandardController = ' + stdController );
        
        showNoAgentAvailable = false;
        showClientTimeout = false;
        // Get url parameters
        surveyId = Apexpages.currentPage().getParameters().get('id');
        
        if( surveyId == null )
        {
            try
            {
                surveyId = [ SELECT Id
                             FROM Survey__c
                             WHERE Live_Agent_Button_ID__c = :Apexpages.currentPage().getParameters().get( 'buttonId' )
                             LIMIT 1 ].Id;
            }
            catch( Exception l_ex )
            {
                showBadURLError = true;
                System.debug( 'ERROR: No Survey defined with Live_Agent_Button_Id__c = ' + Apexpages.currentPage().getParameters().get( 'buttonId' ) );
            }
        }

        //you can use the caseID from the chat form
        caseId   = Apexpages.currentPage().getParameters().get('caId');
        
        // JSON string of any attached records. Use this to get the CaseId if
        // caId is not sent through
        attachedRecords = Apexpages.currentPage().getParameters().get('attachedRecords');
        System.debug( 'attachedRecords = ' + attachedRecords );
        
        // Parse JSON response to get the attached caseId value
        JSONParser parser;
        if(attachedRecords != null && attachedRecords != ''){
            parser = JSON.createParser( attachedRecords );
        }
        while ( attachedRecords != null && attachedRecords != '' && parser.nextToken() != null && caseId == null && contactId == null )
        {
            System.debug( 'JSONToken.FIELD_NAME = ' + JSONToken.FIELD_NAME );
            System.debug( 'parser.getText() = ' + parser.getText() );
            if( ( parser.getCurrentToken() == JSONToken.FIELD_NAME ) 
                  && ( parser.getText() == 'CaseId' ) ) 
            {
                parser.nextToken();
                System.debug( 'CaseId Found: parser.getText() = ' + parser.getText() );
                caseId = parser.getText();
            }
            else if( ( parser.getCurrentToken() == JSONToken.FIELD_NAME ) 
                  && ( parser.getText() == 'ContactId' ) ) 
            {
                parser.nextToken();
                System.debug( 'ContactId Found: parser.getText() = ' + parser.getText() );
                contactId = parser.getText();
            }
        }
        
        //or you can use the transcript chatkey
        chatkey   = Apexpages.currentPage().getParameters().get('chatKey');

        //replace this with the templace written for the live agent styling
        templateName = Page.CC_SupportTemplate_NO_SEARCH;
        
                                                 // Read the parameter identifying how
                                                 // the chat was ended
        disconnectedBy = Apexpages.currentPage().getParameters().get('disconnectedBy');
        
        System.debug( 'surveyId = ' + surveyId );
        System.debug( 'caseId = ' + caseId );
        System.debug( 'contactId = ' + contactId );
        System.debug( 'chatkey = ' + chatkey );
        System.debug( 'templateName = ' + templateName );
        System.debug( 'disconnectedBy = ' + disconnectedBy );
        
                                                 // If disconnectedBy = agentsUnavailable
        if( disconnectedBy == 'agentsUnavailable' 
            || disconnectedBy == 'error' )
        {
            showNoAgentAvailable = true;
            return;
        }
        
        if( disconnectedBy == 'clientIdleTimeout' )
        {
            showClientTimeout = true;
            return;
        }

        if(caseId ==null && chatkey == null){
            showBadURLError = true;
            return;
        }          
        else{
            cs = [ SELECT id, contactid, authenticated__c, Chat_Key__c
                   FROM Case 
                   WHERE (Id = : caseId
                   OR Chat_Key__c = : chatkey)
                   AND authenticated__c = true
                   LIMIT 1 ];
        }

        if(!cs.isEmpty()){
            c = cs[0];
            if( contactId == null )
            {
                contactId = c.ContactId;
            }
            init();
        }
        else{
            showBadURLError = true;
            return;
        }
        
        System.debug( 'END: LA_NewSurveyController.constructor()' );
    } 
    
    public void init()
    {
            
        if (surveyId != null){ 
            // Retrieve all necessary information to be displayed on the page
            allQuestions = new List<question>();
            subQuestions = new List<question>();
            
            setupQuestionList();
            
            setSurveyNameAndThankYou(surveyId);
            
            String urlBase = URL.getSalesforceBaseUrl().toExternalForm();
            baseURL = urlBase;
            
            userId = UserInfo.getUserId();
            userName = UserInfo.getName();

            showRequiredError = false;
            showAlreadyTakenError = false;
            
            thankYouRendered=false;
            
            
        }       
    }

     /* Called during the setup of the page. 
       Retrieve questions and responses from DB and inserts them in 2 lists. */
    public Integer setupQuestionList(){

        getAQuestion();
        return allQuestions.size();
    }

    public void showExtraQs(){
        system.debug('SHOW QS IS ' + showExtraSurvey);
    }
    
    /** Sets the survey's name variable
    *  param: sID   The survey ID as specified in the DB
    */
    public void setSurveyNameAndThankYou(String sId){
        Survey__c s = [SELECT Name, Id, URL__c, Thank_You_Text__c, thankYouText__c, thankYouLink__c, Survey_Header__c, Survey_Container_CSS__c FROM Survey__c WHERE Id =:sId];
        surveyName = s.Name;
        surveyHeader = s.Survey_Header__c;
        templateURL = s.URL__c+'id='+sId;//+'&cId={!Contact.Id}'+'&caId='+'{!Case.id}';
        surveyThankYouText = s.Thank_You_Text__c;
        if (surveyThankYouText == null)
        {
            surveyThankYouText = System.Label.LABS_SF_Survey_Submitted_Thank_you;
        }
        surveyThankYouURL = s.thankYouLink__c;
        surveyContainerCss = s.Survey_Container_CSS__c;
    }

//------------------------------------------------------------------------------//    
  private static boolean checkRequired(String response, Survey_Question__c question){
    if(question.Required__c == true){
        if(response == null || response =='NO RESPONSE')
          return false;
    }
    return true;
  } 


   /** Class: question
    *  Retrieves the question information and puts it in the question allQuestionsObject
    */      
    global class question{
        global String   name                                                {get; set;}
        global String   id                                                  {get; set;}
        global String   question                                            {get; set;}
        global String   header                                              {get; set;}
        global String   orderNumber                                         {get; set;}
        global String   choices                                             {get; set;}
        global String   selectedOption                                      {get; set;}
        global List<String> selectedOptions                                 {get; set;}
        global List<SelectOption> singleOptions                             {get; set;}
        global List<SelectOption> multiOptions                              {get; set;}
        global Boolean  required                                            {get; set;}
        global String   questionType                                        {get; set;}    
        global String   renderFreeText                                      {get; set;}
        global String   renderSelectRadio                                   {get; set;}
        global String   renderSelectCheckboxes                              {get; set;} 
        global String   renderSelectRow                                     {get; set;}
        global String   singleOptionsForChart                               {get; set;}
        global List<String> strList                                         {get; set;} // The question's option as a list of string
        global List<SelectOption> rowOptions                                {get; set;}
        global boolean  noData                                              {get; set;}
      
      /** Fills up the question object
       *  param:    Survey_Question__c 
       */     
     global question(Survey_Question__c sq) {
        name = sq.Name;
        id = sq.Id;
        question = sq.Question_New__c;
        header = sq.header__c;
        orderNumber = String.valueOf(sq.OrderNumber__c+1);
        choices = sq.Choices_New__c;
        required = sq.Required__c;
        questionType = sq.Type__c;
        singleOptionsForChart = ' ';
        selectedOption = '';
        selectedOptions = new List<String>();
     if (sq.Type__c=='Single Select--Vertical'){
                renderSelectRadio='true';
                singleOptions = stringToSelectOptions(choices);
            
                renderSelectCheckboxes='false';
                renderFreeText='false';
                renderSelectRow = 'false';
        selectedOption = '';
        selectedOptions = new List<String>();                               
      }
     else if (sq.Type__c=='Multi-Select--Vertical'){        
                renderSelectCheckboxes='true';
                multiOptions = stringToSelectOptions(choices);
                renderSelectRadio='false';
                renderFreeText='false';
              renderSelectRow = 'false';
        selectedOption = '';
        selectedOptions = new List<String>();
      }
     else if (sq.Type__c=='Single Select--Horizontal'){   
          renderSelectCheckboxes='false';
          rowOptions = stringToSelectOptions(choices);
          renderSelectRadio='false';
          renderFreeText='false';
          renderSelectRow = 'true';
        selectedOption = '';
        selectedOptions = new List<String>();     
      }
     else if (sq.Type__c=='Free Text'){
            renderFreeText='true';
            renderSelectRadio='false';
            renderSelectCheckboxes='false';
          renderSelectRow = 'false';
          choices='';
      }
      }
      
       /** Splits up the string as given by the user and adds each option
        *  to a list to be displayed as option on the Visualforce page
        *  param: str   String as submitted by the user
        *  returns the List of SelectOption for the visualforce page
        */  
      private List<SelectOption> stringToSelectOptions(String str){
        if (str == '')
        {
            return new List<SelectOption>();
        }
        strList = str.split('\n');
      
        List<SelectOption> returnVal = new List<SelectOption>();
        Integer i = 0;
        for(String s: strList){
            if (s!='') {    
                if (s != 'null' && s!= null) {
                    String sBis = s.replace(' ', '%20');
                    singleOptionsForChart += s.trim()+'|';
                    returnVal.add(new SelectOption(String.valueOf(i),s));
                    System.debug('*****VALUES: ' + s);
                    i++;
                }
            }
        }
        singleOptionsForChart = singleOptionsForChart.substring(0, singleOptionsForChart.length()-1);
        return returnVal;
      } 
    }
    
  /** Fills up the List of questions to be displayed on the Visualforce page
   */   
    public List<question> getAQuestion() {
            qQuestion = '';
            qChoices ='';
        
        List<Survey_Question__c> allQuestionsObject = 
                                        [Select Type__c,Active__c,header__c, Id, Survey__c, Required__c, Question_New__c, 
                                        OrderNumber__c, Name, Choices_New__c 
                                        From Survey_Question__c
                                        WHERE Survey__c =: surveyId 
                                        AND Active__c = true
                                        ORDER BY OrderNumber__c];
        
        system.debug('ALL QUESTIONS ARE ' + allQuestionsObject);

        allQuestions = new List<question>();
        
        Double old_OrderNumber = 0;
        Double new_OrderNumber;
        Double difference = 0;
        /* Make sure that the order number follow each other (after deleting a question, orders might not do so) */
        for (Survey_Question__c q : allQuestionsObject){ 
            new_OrderNumber = q.OrderNumber__c;
            difference = new_OrderNumber - old_OrderNumber - 1;
            if (difference > 0) {
                Double dd = double.valueOf(difference);
                Integer newOrderInt = dd.intValue();
                q.OrderNumber__c -= Integer.valueOf(newOrderInt); 
            }
            old_OrderNumber = q.OrderNumber__c;
            question theQ = new question(q);
            allQuestions.add(theQ);
        }
        allQuestionsSize = allQuestions.size();
        return allQuestions;
    }   
    
    public PageReference 
    submitResults2()
    {
        System.debug( 'START: submitResults2()' );
        thankYouRendered = true;
        return null;
    }
    
    public void submitResults()
    {
        showRequiredError = false;
        showAlreadyTakenError = false;

        system.debug('show required error is ' + showRequiredError);
        system.debug('show taken error is ' + showAlreadyTakenError);
        
        List <SurveyQuestionResponse__c> sqrList = new List<SurveyQuestionResponse__c>();
        
        for (question q : allQuestions)
        {
            SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
            if (q.renderSelectRadio == 'true')
            {
                
                if (q.required &&  (q.selectedOption == null || q.selectedOption == ''))
                {
                    showRequiredError = true;
                    return;
                }
                
                if (q.selectedOption == null || q.selectedOption == '')
                {
                    sqr.Response__c = '';
                }
                else
                {
                    sqr.Response__c = q.singleOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                }

                System.debug('*****Select Radio ');

                sqr.Survey_Question__c = q.Id;
                sqrList.add(sqr);
            }
            else if (q.renderFreeText == 'true')
            {
                system.debug('*****Free Text Response ' + q.choices);
                if (q.required && q.choices == '')
                {
                    showRequiredError = true;
                    return;
                }
                
                sqr.Text_Response__c = q.choices;
                sqr.Survey_Question__c = q.Id;
                sqrList.add(sqr);
            }
            else if (q.renderSelectCheckboxes == 'true')
            {
                if (q.required && (q.selectedOptions == null || q.selectedOptions.size() == 0))
                {
                    showRequiredError = true;
                    return;
                }
                
                for (String opt : q.selectedOptions)
                {
                    sqr = new SurveyQuestionResponse__c();
                    if (opt == '' || opt == null)
                    {
                        sqr.Response__c = '';
                    }               
                    else
                    {   
                        sqr.Response__c = q.multiOptions.get(Integer.valueOf(opt)).getLabel();
                    }
                    sqr.Survey_Question__c = q.Id;
                    sqrList.add(sqr);
                }
            }
            else if (q.renderSelectRow == 'true')
            {
                if (q.required && (q.selectedOption == null || q.selectedOption == ''))
                {
                    showRequiredError = true;
                    return;
                }
                
                if (q.selectedOption == null || q.selectedOption == '')
                {
                    sqr.Response__c = '';
                }
                else
                {
                    sqr.Response__c = q.rowOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                }
                sqr.Survey_Question__c = q.Id;
                sqrList.add(sqr);
            }
            
             
        }
        if(subQuestions != null && !subQuestions.isEmpty() && showExtraSurvey){
            for (question q : subQuestions)
            {
                SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
                if (q.renderSelectRadio == 'true')
                {
                    
                    if (q.required &&  (q.selectedOption == null || q.selectedOption == ''))
                    {
                        showRequiredError = true;
                        return;
                    }
                    
                    if (q.selectedOption == null || q.selectedOption == '')
                    {
                        sqr.Response__c = '';
                    }
                    else
                    {
                        sqr.Response__c = q.singleOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                    }

                    System.debug('*****Select Radio ');

                    sqr.Survey_Question__c = q.Id;
                    sqrList.add(sqr);
                }
                else if (q.renderFreeText == 'true')
                {
                    system.debug('*****Free Text Response ' + q.choices);
                    if (q.required && q.choices == '')
                    {
                        showRequiredError = true;
                        return;
                    }
                    
                    sqr.Text_Response__c = q.choices;
                    sqr.Survey_Question__c = q.Id;
                    sqrList.add(sqr);
                }
                else if (q.renderSelectCheckboxes == 'true')
                {
                    if (q.required && (q.selectedOptions == null || q.selectedOptions.size() == 0))
                    {
                        showRequiredError = true;
                        return;
                    }
                    
                    for (String opt : q.selectedOptions)
                    {
                        sqr = new SurveyQuestionResponse__c();
                        if (opt == '' || opt == null)
                        {
                            sqr.Response__c = '';
                        }               
                        else
                        {   
                            sqr.Response__c = q.multiOptions.get(Integer.valueOf(opt)).getLabel();
                        }
                        sqr.Survey_Question__c = q.Id;
                        sqrList.add(sqr);
                    }
                }
                else if (q.renderSelectRow == 'true')
                {
                    if (q.required && (q.selectedOption == null || q.selectedOption == ''))
                    {
                        showRequiredError = true;
                        return;
                    }
                    
                    if (q.selectedOption == null || q.selectedOption == '')
                    {
                        sqr.Response__c = '';
                    }
                    else
                    {
                        sqr.Response__c = q.rowOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                    }
                    sqr.Survey_Question__c = q.Id;
                    sqrList.add(sqr);
                }
                
                 
            }
        }

        if(AddSurveyTaker())
        {
            for (SurveyQuestionResponse__c sqr : sqrList)
            {
                sqr.SurveyTaker__c = surveyTakerId;
            }
            insert sqrList;
            thankYouRendered=true;      
        }

        
    }
    
    public Boolean AddSurveyTaker()
    {
        
        if (surveyId == null)
        {
            return false;
        }
        else
        {
            string query = 'Select Contact__c, Survey__c, Case__c, Case__r.Number_of_Case_Opens__c From SurveyTaker__c Where Contact__c=:contactId and Survey__c=:surveyId and Case__c = :caseId';
            
            system.debug('Check contactId =  ' + contactId );
            system.debug('Check surveyId =  ' + surveyId );
            system.debug('Check Query =  ' + query );
            List<SurveyTaker__c> check = database.query(query);
            system.debug('CHECK LIST IS ' + check.size());

            if( ! check.isEmpty() 
                && ( caseId == null 
                     || ( caseId != null 
                          && check.size() >= check[0].Case__r.Number_of_Case_Opens__c )
                    )
               )
            {
                    showAlreadyTakenError = true;
                    return false;       
            }
        }
        
        system.debug('CASE ID IS ' + caseId);

        system.debug('CONTACT ID IS ' + contactId);
        
        SurveyTaker__c st = new SurveyTaker__c();
        st.Contact__c = c.contactId;
        st.Survey__c = surveyId;
        st.Taken__c = 'false';
        st.Case__c = caseId;
        
        insert st;  
        
        surveyTakerId = st.Id;
        return true;    
    }

    public
    void
    setCaseChatKey()
    {
        String l_chat_key   = Apexpages.currentPage().getParameters().get('chatKey');
        String l_attached_records_json = Apexpages.currentPage().getParameters().get('attachedRecords');
        
        String l_case_id;
        
        if( l_attached_records_json == null )
        {
            return;
        }
                                                 // Parse JSON response to get 
                                                 // the attached caseId value
        JSONParser l_parser = JSON.createParser( l_attached_records_json );
        while ( l_parser!= null && l_parser.nextToken() != null && l_case_id == null )
        {
            if( ( l_parser.getCurrentToken() == JSONToken.FIELD_NAME ) 
                  && ( l_parser.getText() == 'CaseId' ) ) 
            {
                l_parser.nextToken();
                l_case_id = l_parser.getText();
            }
        }
        
        if( l_case_id != null && l_chat_key != null )
        {
            Case l_case = [ SELECT Chat_Key__c
                            FROM Case
                            WHERE Id = :l_case_id
                            LIMIT 1 ];
            l_case.Chat_Key__c = l_chat_key;
            update l_case; 
        }
        
    }

}// /END Class