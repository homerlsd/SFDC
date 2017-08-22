public with sharing class KnowledgeSearchController {
	public Knowledge_Group__c editKB {get;set;}
	
	public string custerror {get;set;}
	public Map<string, Question__kav> detailMap {get;set;}
    public String querystring {get;set;}
    public String querystring_affiliation {get;set;}
    public String querystring_client {get;set;}

    public Map<string, string> describeMap {get;set;}

    public List<question> questions {get;set;}
    public Set<id> questionIDs {get;set;}
    public Map<String, Question> questionMap {get;set;}

	public string selectedPartner {get;set;}
    public string selectedChannel {get;set;}
    public string selectedType {get;set;}
	
    public string selectedBody {get;set;}
    public string selectedTab {get;set;}
	
	public string caseID {get;set;}
    public string kbID {get;set;}

	public integer LimitSize;
	public integer OffsetSize;
	public integer totalLIVEKnowledge;

	public boolean loadQuestionDetail {get;set;}
	public boolean hasNxt {get;set;}
	public boolean hasPrev {get;set;}
	public boolean noresults {get;set;}

    public Question__kav selectedEx {get;set;}
    public Internal__kav selectedInt {get;set;}

	private integer counter=0;  //keeps track of the offset
    private integer list_size=10; //sets the page size or number of rows

	public KnowledgeSearchController() {
        detailMap = new Map<string, Question__kav>();
        describeMap = new Map<string,string>();

        questionIDs = new Set<ID>();
        questions = new List<question>();
        questionMap = new Map<string, question>();

        selectedEx = new Question__kav();
        selectedInt = new Internal__kav();

        custerror = '';
        querystring = '';
        querystring_affiliation = '';
        querystring_client = '';

        selectedBody = '';

        loadQuestionDetail = false;
        noresults = false;

        selectedTab = 'name1';

        LimitSize = 10;
        OffsetSize = 0;
        totalLIVEKnowledge = 0;
  
  		caseID = ApexPages.currentPage().getParameters().get('caseID');

        kbID = Apexpages.currentPage().getParameters().get('kbID');

        if(kbID != null){

            string Temp_querystring = Apexpages.currentPage().getParameters().get('querystring');
            if(Temp_querystring != null)
                querystring = Temp_querystring;

            string Temp_querystringClient = Apexpages.currentPage().getParameters().get('querystring_client');
            if(Temp_querystringClient != null)
                querystring_client = Temp_querystringClient;

            string Temp_querystringAffiliation = Apexpages.currentPage().getParameters().get('querystring_affiliation');
            if(Temp_querystringAffiliation != null)
                querystring_affiliation = Temp_querystringAffiliation;

            string Temp_partner = Apexpages.currentPage().getParameters().get('selectedPartner');
            if(Temp_partner != null)
                selectedPartner = Temp_partner;

            string Temp_channel = Apexpages.currentPage().getParameters().get('selectedChannel');
            if(Temp_channel != null)
                selectedChannel = Temp_channel;

            string Temp_type = Apexpages.currentPage().getParameters().get('selectedType');
            if(Temp_type != null)
                selectedType = Temp_type;
            else
                selectedType = 'Search All';

            SearchKB();
            renderKBDetail();
        }
	}

	public void SearchKB(){
		clearme();

        boolean queryAll = false;

        system.debug('ARE WE Searching ' + querystring);
        system.debug('ARE QUESTIONS NULL ' + questions);
        system.debug('Partner? ' + selectedPartner);
        system.debug('Chanel? ' + selectedChannel);
        system.debug('Affiliation? ' + querystring_affiliation);
        system.debug('client? ' + querystring_client	);

        if( (querystring == null || querystring == '') 
        	&& (querystring_client == null || querystring_client == '')
        		&& (querystring_affiliation == null || querystring_affiliation == '')
        			&& (selectedPartner == null || selectedPartner.contains('Search All'))
        				&& (selectedChannel == null || selectedChannel.contains('Search All'))){

        	List<Question__kav> external = database.query(CC_Constants.BASE_QUERY);
        	List<Internal__kav> internal = database.query(CC_Constants.BASE_QUERY_INTERNAL);

            if(selectedType == 'External' || selectedType == 'Search All'){
                for(Question__kav qq : external){
                	boolean custLink = qq.Custom_Link_Text__c != null ? true : false;
                    question qqq = new question(qq.summary, 'External', qq.knowledgearticleid, custLink, qq.title, qq.RichTextSummary__c);
                    questionMap.put(qq.title, qqq);
                    questionIDs.add(qq.knowledgearticleid);
                } 
            }
            if(selectedType == 'Internal' || selectedType == 'Search All'){
                for(Internal__kav iq : internal){
                	question qqq = new question(iq.summary, 'Internal', iq.knowledgearticleid, false, iq.title, iq.Troubleshooting_Steps__c);
                    questionMap.put(iq.title, qqq);
                    questionIDs.add(iq.knowledgearticleid);
                }
            }
        }
        else{

        	Set<id> kbIds = new Set<id>();
        	Map<Group_Article__c, Id> kbMap = new Map<Group_Article__c, Id>();

        	boolean needGA = false;

        	string BASE = 'select id, Knowledge_Article_ID__c, Custom_URL__c, Active__c from Group_Article__c WHERE';

        	if(querystring_client != ''){
        		querystring_client = '%'+querystring_client+'%';

        		BASE += ' (Knowledge_Group__r.Client__c LIKE : querystring_client OR Knowledge_Group__r.Group_Name__c LIKE : querystring_client)';
        		needGA = true;
        	}
        	if(querystring_affiliation != ''){
        		if(needGA){
        			BASE += ' AND Knowledge_Group__r.Affiliation__c = : querystring_affiliation';
        		}
        		else{
        			BASE += ' Knowledge_Group__r.Affiliation__c = : querystring_affiliation';
        			needGA = true;
        		}
        	}
        	if(selectedPartner != null && !selectedPartner.contains('Search All')){
        		if(needGA){
        			BASE += ' AND Knowledge_Group__r.Partner_Lookup__c = : selectedPartner';
        		}
        		else{
        			BASE += ' Knowledge_Group__r.Partner_Lookup__c = : selectedPartner';
        			needGA = true;
        		}
        	}
        	if(selectedChannel != null && !selectedChannel.contains('Search All'))	{
				if(needGA){
        			BASE += ' AND Knowledge_Group__r.Channel__c = : selectedChannel';
        		}
        		else{
        			BASE += ' Knowledge_Group__r.Channel__c = : selectedChannel';
        			needGA = true;
        		}
        	}

        	if(needGA){

        		system.debug('BASE QUERY FOR GROUP ARTICLES ' + BASE);

        		List<Group_Article__c> gas = database.query(BASE);

	        	system.debug('GROUP ARTICLES ARE ' + gas);

        		for(Group_Article__c ga : gas){
        			kbids.add(ga.Knowledge_Article_ID__c);
        			kbmap.put(ga, ga.Knowledge_Article_ID__c);
        		}
        	}

        	system.debug('KB IDS IS ' + kbIds);

        	string exquery = CC_Constants.BASE_QUERY;
        	string inquery = CC_Constants.BASE_QUERY_INTERNAL;

        	if(needGA){
        		exquery += ' AND KnowledgeArticleID IN : kbIds ORDER BY CreatedDate DESC';
        		inquery += ' AND KnowledgeArticleID IN : kbIds ORDER BY CreatedDate DESC';
        	}

        	system.debug('EXTERNAL QUERY IS ' + exquery);
        	system.debug('INTERNAL QUERY IS ' + inquery);

        	List<Question__kav> external = database.query(exquery);
        	List<Internal__kav> internal = database.query(inquery);

            if(selectedType == 'External' || selectedType == 'Search All'){
    			for(Question__kav qs : external){
                	boolean custLink = qs.Custom_Link_Text__c != null ? true : false;
    				
    				if(querystring == '' || 
    					((qs.Category__c != null && (qs.Category__c.contains(querystring) || qs.Category__c.toLowerCase().contains(querystring)))
    						|| (qs.title != null && (qs.title.contains(querystring) || qs.title.toLowerCase().contains(querystring)))
                                || (qs.RichTextSummary__c != null && (qs.RichTextSummary__c.contains(querystring) || qs.RichTextSummary__c.toLowerCase().contains(querystring)))
        							|| (qs.Specific_Group_Client__c != null && (qs.Specific_Group_Client__c.contains(querystring) || qs.Specific_Group_Client__c.toLowerCase().contains(querystring)))
        								|| (qs.summary != null && (qs.summary.contains(querystring) || qs.summary.toLowerCase().contains(querystring))))){
    	                				question qqq = new question(qs.summary, 'External', qs.knowledgearticleid, custLink, qs.title, qs.RichTextSummary__c);
    	                				questionMap.put(qs.title, qqq);
    	                				questionIDs.add(qs.knowledgearticleid);
    								}
    			}
            }
            if(selectedType == 'Internal' || selectedType == 'Search All'){
    			for(Internal__kav iqs : internal){
    				
    				if(querystring == '' || 
    					((iqs.title != null && (iqs.title.contains(querystring) || iqs.title.toLowerCase().contains(querystring)))
                            || (iqs.Troubleshooting_Steps__c != null && (iqs.Troubleshooting_Steps__c.contains(querystring) || iqs.Troubleshooting_Steps__c.toLowerCase().contains(querystring)))
    					       || (iqs.summary != null && (iqs.summary.contains(querystring) || iqs.summary.toLowerCase().contains(querystring))))){
            				question qqq = new question(iqs.summary, 'Internal', iqs.knowledgearticleid, false, iqs.title, iqs.Troubleshooting_Steps__c);
                    		questionMap.put(iqs.title, qqq);
                    		questionIDs.add(iqs.knowledgearticleid);
                    	}
    			}
            }
        }

       	questions.addall(sortMap(questionMap));

       	system.debug('QUESTIONS IS ' + questions);

        if(!questions.isEmpty())
        	totalLIVEKnowledge = questions.size();
        else
        	noresults = true;

        system.debug('NO RESULTS BOOL IS ' + noresults);

        system.debug('CURRENT ARTICLE IDS SIZE ' + questions.size());

        selectedTab = 'name1';
    }

    public void refreshQuery(){
    	List<Question__kav> external = database.query(CC_Constants.BASE_QUERY + ' AND KnowledgeArticleID IN : questionIDs LIMIT : LimitSize OFFSET: OffsetSize');
        List<Internal__kav> internal = database.query(CC_Constants.BASE_QUERY_INTERNAL + ' AND KnowledgeArticleID IN : questionIDs LIMIT : LimitSize OFFSET: OffsetSize');
    }

	public List<SelectOption> getPartners() {
        List<SelectOption> Options = new List<SelectOption>();

        Options.add(new SelectOption('Search All','Search All'));

        for (Partner__c kb: [select id, name from Partner__c]) {
            Options.add(new SelectOption(kb.id, kb.name));
        }
        System.debug('Options is' + Options);

        return Options;
    }

    public List<SelectOption> getChannels() {
        List<SelectOption> Options = new List<SelectOption>();

        Options.add(new SelectOption('Search All','Search All'));

        for (Sales_Channel__c sc: [select id, name from Sales_Channel__c]) {
            Options.add(new SelectOption(sc.id, sc.name));
        }

        System.debug('Options is' + Options);

        return Options;
    }

    public List<SelectOption> getQtypes() {        
        List<SelectOption> Options = new List<SelectOption>();

        Options.add(new SelectOption('Search All','Search All'));
        Options.add(new SelectOption('External', 'External'));
        Options.add(new SelectOption('Internal', 'Internal'));
        
        System.debug('Options is' + Options);

        return Options;
    }

	public void ChooseFirstLetter() {
		clearme();

        String SelectedLetter = Apexpages.currentPage().getParameters().get('letter');
        
        if( SelectedLetter == Null )
            SelectedLetter = 'A';
        
        SelectedLetter+='%';

        system.debug('QUERY IS ' + CC_Constants.BASE_QUERY + ' and title like :SelectedLetter');

        List<Question__kav> allQs = Database.query(CC_Constants.BASE_QUERY + ' and title like :SelectedLetter LIMIT 900');
        
        system.debug('ALL QUESTIONS ARE ' + allQs);

        for(Question__kav qav: allQs) {
            string client = '';
            if(qav.Specific_Group_Client__c != null && qav.Specific_Group_Client__c != '')
                client = qav.Specific_Group_Client__c;
            else
                client = 'Generic';

            boolean custLink = qav.Custom_Link_Text__c != null ? true : false;

            question qqq = new question(qav.summary, 'External', qav.knowledgearticleid, custLink, qav.title, qav.RichTextSummary__c);
            questionMap.put(qav.title, qqq);
            questionIDs.add(qav.knowledgearticleid);
        }

        system.debug('INTERNAL QUERY IS ' + CC_Constants.BASE_QUERY_INTERNAL + ' and title like :SelectedLetter');

        List<Internal__kav> allIQs = Database.query(CC_Constants.BASE_QUERY_INTERNAL + ' and title like :SelectedLetter LIMIT 900');
        
        system.debug('ALL INTERNAL QUESTIONS ARE ' + allIQs);

        for(Internal__kav ik: allIQs) {
            string client = '';

            question qqq = new question(ik.summary, 'Internal', ik.knowledgearticleid, false, ik.title, ik.Troubleshooting_Steps__c);
            questionMap.put(ik.title, qqq);
            questionIDs.add(ik.knowledgearticleid);
            
        }

        questions.addall(sortMap(questionMap));

        system.debug('Questions is ' + questions);

        if(!questions.isEmpty())
        	totalLIVEKnowledge = questions.size();
    }

    public class question{
        
        public string  questionType                                                     { get; set; }
        public string  knowledgearticleid                                               { get; set; }
        public string title                                                        		{ get; set; }
        public string body                                                        		{ get; set; }
        public string summary                                                        	  { get; set; }
        public boolean customLink                                                       { get; set; }

        public question(string paramSummary, string type, string paramKnowledgeArticleId, boolean paramCustomLink, string paramTitle, string paramBody){
            this.questionType = type;
            this.customlink = paramCustomLink;
            this.knowledgearticleid = paramKnowledgearticleid;
            this.title = paramTitle;
            this.body = paramBody;
            this.summary = paramSummary;

            system.debug('BODY IS ' + this.body);
        }      
    }

    public void FirstPage(){
		OffsetSize = 0;
		getnxt();
		refreshQuery();
	}
	
	public void previous(){
		OffsetSize = OffsetSize - LimitSize;
		getprev();
		refreshQuery();
	}
	
	public void next(){
		OffsetSize = OffsetSize + LimitSize;
		getnxt();
		refreshQuery();
	}
	
	public void LastPage(){
		OffsetSize = totalLIVEKnowledge - math.mod(totalLIVEKnowledge,LimitSize);
		getprev();
		refreshQuery();
	}
	
	public boolean getprev(){
		if(OffsetSize == 0){
			return true;
		}
		else
			return false;
	}
	
	public boolean getnxt(){
		if((OffsetSize + LimitSize) > totalLIVEKnowledge){
			return true;
		}
		else
			return false;
	}

	public void getBools(){
		if(OffsetSize == 0){
			hasPrev = true;
		}
		else
			hasPrev = false;
	
		if((OffsetSize + LimitSize) > totalLIVEKnowledge)
			hasNxt = true;
		else
			hasNxt = false;
	}

	/*public void loadQuestionDetail(){
        clearSelected();
        //selectedBody = ApexPages.currentPage().getParameters().get('qBody');
        string articleTemp = ApexPages.currentPage().getParameters().get('qID');
        system.debug('ARTICLE ID IS ' + articleTemp);

        if(getArticleType(articleTemp).contains('Internal')){
            selectedBody = 'Internal';
            selectedInt = database.query(CC_Constants.BASE_QUERY_INTERNAL + ' AND knowledgearticleid = : articleTemp');
        }
        else{
            selectedBody = 'External';
            selectedEx = database.query(CC_Constants.BASE_QUERY + ' AND knowledgearticleid = : articleTemp');
        }

        system.debug('SELECTED ARTICLE BODY IS ' + selectedBody);
		loadQuestionDetail = true;
	}*/

    public PageReference loadQuestionDetail(){
        string articleTemp = ApexPages.currentPage().getParameters().get('qID');
        system.debug('ARTICLE ID IS ' + articleTemp);
        PageReference pg = page.Knowledgesearch;
        pg.getParameters().put('kbID', articleTemp);
        pg.getParameters().put('showDetail', 'true');
        
        if(querystring != null && querystring != '')
            pg.getParameters().put('querystring', querystring);
        if(querystring_client != null && querystring_client != '')
            pg.getParameters().put('querystring_client', querystring_client);
        if(querystring_affiliation != null && querystring_affiliation != '')
            pg.getParameters().put('querystring_affiliation', querystring_affiliation);
        
        if(selectedType != null && selectedType != 'Search All')
            pg.getParameters().put('selectedType', selectedType);

        if(selectedPartner != null && selectedPartner != 'Search All')
            pg.getParameters().put('selectedPartner', selectedPartner);

        if(selectedChannel != null && selectedChannel != 'Search All')
            pg.getParameters().put('selectedChannel', selectedChannel);

        pg.setAnchor('Section2');
        pg.setRedirect(true);
        return pg;
    }

    public void renderKBDetail(){
        if(getArticleType(kbID).contains('Internal')){
            selectedBody = 'Internal';
            selectedInt = database.query(CC_Constants.BASE_QUERY_INTERNAL + ' AND knowledgearticleid = : kbID');
        }
        else{
            selectedBody = 'External';
            selectedEx = database.query(CC_Constants.BASE_QUERY + ' AND knowledgearticleid = : kbID');
        }

        system.debug('SELECTED ARTICLE BODY IS ' + selectedBody);
        loadQuestionDetail = true;
        selectedTab = 'name2';
    }

	public void clearme(){
		noresults = false;
		if(!questions.isEmpty())
			questions.clear();
		if(!questionIDs.isEmpty())
			questionIDs.clear();
		if(!questionMap.isEmpty())
			questionMap.clear();
	}

    public void clearSelected(){
        if(selectedEx.id != null)
            selectedEx.clear();
         if(selectedInt.id != null)
            selectedInt.clear();
    }

	public List<question> sortMap (Map<String, question> theMap) {

	    Map<String, question> returnMap = new Map<String, question>();
	    Set<String> keySet = theMap.keySet();
	    List<String> keyList = new List<String>();
	    keyList.addAll(keySet);

	    keyList.sort();

        for (Integer i = 0; i < keyList.size(); i++)
            returnMap.put(keyList[i], theMap.get(keyList[i]));

	    return returnMap.values();
	}

    public void linkArticle(){
    	string articleTemp = ApexPages.currentPage().getParameters().get('qID');

    	system.debug('article id param' + articleTemp);

    	CaseArticle ca = new CaseArticle();
    	ca.caseid = caseID;
    	ca.knowledgearticleid = articleTemp;
    	try{
    		insert ca;
    		system.debug('CASE ARTICLE ID IS ' + ca.id);
    		custerror = Label.KnowledgeSearch_LinkArticleSuccess;	
    	}
    	catch(exception ex){
    		custerror = ex.getMessage().replace('FIELD_CUSTOM_VALIDATION_EXCEPTION', '').replace('Upsert failed. First exception on row 0; first error: , ', '').replace('Insert failed. First exception on row 0; first error: , ', '').replace(': []', '');
	        return;
    	}
    }

    //Util method to get Article Type from article Id.
    public String getArticleType(String articleId) {
        Map<string, string> mappy = new Map<String, String>();

        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<String> keySet = gd.keySet();
        for (String key : keySet) {
            Schema.SObjectType objectType = gd.get(key);
            if (key.endsWith('ka') || key.endsWith('kb')) {
                mappy.put(objectType.getDescribe().getKeyPrefix(), objectType.getDescribe().getLabel());
            }
        }

        String articlePrefix = articleId.substring(0,3);
        String articleType = null;

        for(String key: mappy.keySet()) {
            system.debug('KEY IN LOOP IS ' + key);
            if(articlePrefix.equalsIgnoreCase(key)) {
                articleType = mappy.get(key);
            }
        }

        system.debug(articleType);
        return articleType;
    }
}