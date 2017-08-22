public with sharing class ManageKnowledgeController {
	public Knowledge_Group__c editKB {get;set;}
	
	public string custerror {get;set;}
	public Map<string, Question__kav> detailMap {get;set;}
	public Map<id, Group_Article__c> gaToKBmap {get;set;}
	public List<KBcustom> currentKB {get;set;}
	public List<GAcustom> newGroupArticles {get;set;}
	public Map<id, Group_Article__c> currentArticleIDs {get;set;}
	public List<SelectOption> allArticles {get;set;}
    public String querystring {get;set;}
	public boolean recent {get;set;}

	public string selectDefault {get;set;}
	
	public integer total_size;

	private integer counter=0;  //keeps track of the offset
    private integer list_size=10; //sets the page size or number of rows

	public ManageKnowledgeController() {
        editKB = [select id, channel__c from Knowledge_Group__c where ID = : ApexPages.currentPage().getParameters().get('id')];
        newGroupArticles = new List<GAcustom>();
        detailMap = new Map<string, Question__kav>();
        gaToKBmap = new Map<id, Group_Article__c>();
        currentArticleIDs = new Map<ID, Group_Article__c>();
        custerror = '';
        querystring = '';

        recent = true;

        selectDefault = 'Please Select Article...';
        
        GAcustom gaNew = new GAcustom(selectDefault);
        newGroupArticles.add(gaNew);

        total_size = [select count() from Group_Article__c WHERE Knowledge_Group__c = : editKB.id]; //set the total size in the constructor
  
        ChooseFirstLetter();
        findCurrentKB();
	}

	public void findCurrentKB(){
    	Map<ID, boolean> kbIds = new Map<id, boolean>();
        List<id> idList = new List<id>();
    	currentKB = new List<KBcustom>();
        List<Group_Article__c> gas = new list<Group_Article__c>();
        boolean queryAll = false;

    	string queryStringIds = '(';
        idList.add(editKB.id);

        system.debug('ARE WE GETTING THE CURRENT ARTICLES  ' + idlist);

        String SelectedLetter = Apexpages.currentPage().getParameters().get('letter');
        
        if( querystring == ''){

            string BASE = 'select id, Knowledge_Article_ID__c, Custom_URL__c, Active__c from Group_Article__c WHERE Knowledge_Group__c IN : idList';

            if( SelectedLetter == Null || SelectedLetter == ''){
                gas = Database.query(base);
                queryall = true;
            }  
            else{
                SelectedLetter += '%';
                base = base + ' AND Knowledge_Title__c LIKE : SelectedLetter';
                gas = Database.query(base);
            } 
            
            for(Group_Article__c ga : gas){
                kbIds.put(ga.Knowledge_Article_ID__c, ga.Active__c);
                gaToKBmap.put(ga.Knowledge_Article_ID__c, ga);
                if(queryAll)
                    currentArticleIDs.put(ga.Knowledge_Article_ID__c, ga);
            } 
            
            if(!kbIds.isEmpty()){
                for(Question__kav qs : [select Id,Group_Name__c,Category__c,KnowledgeArticleID, Is_Common_Question__c,title,summary, UrlName, LastPublishedDate,LastModifiedById,RichTextSummary__c FROM Question__kav WHERE PublishStatus = 'online' and Language = 'en_US' AND KnowledgeArticleID IN : kbIds.keyset() ORDER BY CreatedDate DESC]){
                    boolean isActive = (kbIds.containsKey(qs.KnowledgeArticleID) ? kbIds.get(qs.KnowledgeArticleID) : false);
                    string customLink = gaToKBmap.containsKey(qs.KnowledgeArticleID) ? gaToKBmap.get(qs.KnowledgeArticleID).Custom_URL__c : '';
                    currentKB.add(new KBcustom(qs, isActive, customLink));
                }
            }
        }
        else{

            for(Group_Article__c ga : [select id, Knowledge_Article_ID__c, Active__c from Group_Article__c WHERE Knowledge_Group__c IN : idList ORDER BY Knowledge_Article_ID__c]){
            	kbIds.put(ga.Knowledge_Article_ID__c, ga.Active__c);
            	gaToKBmap.put(ga.Knowledge_Article_ID__c, ga);
            }
    		
    		if(!kbIds.isEmpty()){
    			for(Question__kav qs : [select Id,Group_Name__c,Category__c,KnowledgeArticleID, Is_Common_Question__c,title,summary, UrlName, LastPublishedDate,LastModifiedById,RichTextSummary__c FROM Question__kav WHERE PublishStatus = 'online' and Language = 'en_US' AND KnowledgeArticleID IN : kbIds.keyset() ORDER BY CreatedDate DESC]){
    				boolean isActive = (kbIds.containsKey(qs.KnowledgeArticleID) ? kbIds.get(qs.KnowledgeArticleID) : false);
                    string customLink = gaToKBmap.containsKey(qs.KnowledgeArticleID) ? gaToKBmap.get(qs.KnowledgeArticleID).Custom_URL__c : '';

    				if((qs.Category__c != null && (qs.Category__c.contains(querystring) || qs.Category__c.toLowerCase().contains(querystring))) || (qs.title != null && (qs.title.contains(querystring) || qs.title.toLowerCase().contains(querystring))) || (qs.summary != null && (qs.summary.contains(querystring) || qs.summary.toLowerCase().contains(querystring))))
    					currentKB.add(new KBcustom(qs, isActive, customLink));
    			}
    		}
            querystring = '';
        }

        system.debug('CURRENT ARTICLE IDS SIZE ' + currentArticleIDs.size());
    }

	/*public List<SelectOption> getallArticles() {
        List<SelectOption> Options = new List<SelectOption>();

        Options.add(new SelectOption('Please Select Article...','Please Select Article...'));
        detailMap.put('Please Select Article...','');

        List<Question__kav> allQs = Database.query(CC_Constants.BASE_QUERY);

        system.debug('ALL QS ARE ' + allqs);

        for (Question__kav kb: allqs) {
            Options.add(new SelectOption(kb.id, kb.title));
            system.debug('SUMMARY IS ' + kb.summary);
            string stSum = string.valueOf(kb.summary);
            detailMap.put(kb.id, kb.summary);
        }
        System.debug('Options is' + Options);

        return Options;
    }*/

	public void ChooseFirstLetter() {
        allArticles = new List<SelectOption>();
        detailMap.put('Please Select Article...', new Question__kav());

        String SelectedLetter = Apexpages.currentPage().getParameters().get('letter');
        
        if( SelectedLetter == Null )
            SelectedLetter = 'A';
        
        allArticles.add( new SelectOption('','Please Choose( Starts with '+SelectedLetter+' )'));
        SelectedLetter+='%';


        List<String> tempChans = new List<String>();
        tempChans.add(editKB.channel__c);

        system.debug('QUERY IS ' + CC_Constants.BASE_QUERY + ' AND Channel__c IN : tempChans and title like :SelectedLetter');

        List<Question__kav> allQs = Database.query(CC_Constants.BASE_QUERY + ' AND Channel__c IN : tempChans and title like :SelectedLetter LIMIT 900');
        
        system.debug('ALL QUESTIONS ARE ' + allQs);

        for(Question__kav qav: allQs) {
            string client = '';
            if(qav.Specific_Group_Client__c != null && qav.Specific_Group_Client__c != '')
                client = qav.Specific_Group_Client__c;
            else
                client = 'Generic';

            allArticles.add( new SelectOption(qav.knowledgeArticleId,qav.title + ' - ' + client));
            detailMap.put(qav.knowledgeArticleId, qav);
        }
    }

    public class KBcustom{
        
        public Question__kav  articleVersion                                            { get; set; }
        public boolean active                                                           { get; set; }
        public boolean active_init                                                      { get; set; }
        public string customLink                                                       { get; set; }

        public KBcustom(Question__kav paramRegistration, boolean paramIsActive, string paramCustomLink){
            this.articleVersion = paramRegistration;
            this.active = paramIsActive;
            //We check this var in the save method so we don't just update everything
            this.active_init = paramIsActive;
            this.customlink = paramCustomLink;
        }      
    }

    public class GAcustom{
        
        public string customUrl                                                           { get; set; }
        public string selectedArticleLine                                                 { get; set; }

        public GAcustom(string selectedArt){
            this.selectedArticleLine = 'Please Select Article...';
        }      
    }

    /*public void findArticleDetails(){
        system.debug('DO WE GET DETAILS' + integer.valueof(ApexPages.currentPage().getParameters().get('g')));
        index = integer.valueof(ApexPages.currentPage().getParameters().get('g'));
        GAcustom currentGA=newGroupArticles[index];
        if(currentGA.selectedArticleLine != null && currentGA.selectedArticleLine != 'Please Select Article...'){
            currentGA.selectedQ = [select id, Custom_Link_Text__c, RichTextSummary__c from Question__kav where KnowledgeArticleID = : currentGA.selectedArticleLine];
        }
    }*/

    public void saveOldStuff(){
    	List<Group_Article__c> updateGAs = new List<Group_Article__c>();

    	if(!currentKB.isEmpty()){
    		for(KBcustom kbc : currentKB){
    			if(kbc.active && !kbc.active_init){
    				Group_Article__c ga2 = gaToKBmap.get(kbc.articleVersion.knowledgeArticleId);
    				ga2.Active__c = true;
    				updateGAs.add(ga2);
    			}
    			else if(!kbc.active && kbc.active_init){
    				Group_Article__c ga2 = gaToKBmap.get(kbc.articleVersion.knowledgeArticleId);
    				ga2.Active__c = false;
    				updateGAs.add(ga2);
    			}
    		}
    		
    		system.debug('DO WE UPDATE THIS THING ' + updateGAs);
    		
    		try{
	    		update updateGAs;
			}
			catch( Exception ex ) {
	            custerror = ex.getMessage().replace('FIELD_CUSTOM_VALIDATION_EXCEPTION', '').replace('Upsert failed. First exception on row 0; first error: , ', '').replace('Insert failed. First exception on row 0; first error: , ', '').replace(': []', '');
	            return;
	        }
    	}
    	return;
    }

    public PageReference saveNewStuff(){
    	saveOldStuff();

    	List<Group_Article__c> newGas = new List<Group_Article__c>();

    	if(!newGroupArticles.isEmpty()){
    		for(GAcustom ga : newGroupArticles){
    			system.debug('SELECTED ARTICLE ID IS ' + ga.selectedArticleLine);
    			if(ga.selectedArticleLine != null && !ga.selectedArticleLine.contains('Please')){
	    			List<string> tempIDs = new List<string>();
                    tempIDs.add(ga.selectedArticleLine);
                    string quer = CC_Constants.BASE_QUERY + ' AND knowledgeArticleId IN : tempIDs';
                    
                    Question__kav art = new Question__kav();

                    try{
                        art = Database.query(quer);
                    }
                    catch ( Exception ex ) {
                        custerror = ex.getMessage().replace('FIELD_CUSTOM_VALIDATION_EXCEPTION', '').replace('Upsert failed. First exception on row 0; first error: , ', '').replace('Insert failed. First exception on row 0; first error: , ', '').replace(': []', '');
                        return null;
                    }

                    if(currentArticleIDs.containsKey(ga.selectedArticleLine)){
                        Group_Article__c gaDelete = currentArticleIDs.get(ga.selectedArticleLine);
                        delete gaDelete;
                    }

                    Group_Article__c gaa = new Group_Article__c();
                    gaa.Knowledge_Group__c = editKB.id;
                    gaa.Knowledge_Article_ID__c = ga.selectedArticleLine;
                    gaa.Knowledge_Summary__c = art.summary;
                    gaa.Knowledge_Title__c = art.title;
                    gaa.knowledge_description__c = art.RichTextSummary__c;
                    gaa.Knowledge_LastPublishedDate__c = date.valueOf(art.LastPublishedDate);
                    gaa.Is_Default_Question__c = art.Is_Default_Question__c;
                    gaa.Is_Common_Question__c = art.Is_Common_Question__c;
                    gaa.channel__c = art.Channel__c;
                    gaa.Active__c = true;
                    if(ga.customUrl != null && ga.customUrl != '')
                        gaa.Custom_URL__c = ga.customUrl;
                    newGas.add(gaa);
	    		}
    		}

    		if(!newGas.isEmpty()){
				try{
					insert newGas;
					PageReference pg = page.manageknowledge;
					pg.getParameters().put('id', editKB.id);
					pg.setRedirect(true);
					return pg;
				}
				catch ( Exception ex ) {
		            custerror = ex.getMessage().replace('FIELD_CUSTOM_VALIDATION_EXCEPTION', '').replace('Upsert failed. First exception on row 0; first error: , ', '').replace('Insert failed. First exception on row 0; first error: , ', '').replace(': []', '');
		            return null;
		        }
		    }
		    else{
		    	PageReference pg = page.manageknowledge;
				pg.getParameters().put('id', editKB.id);
				pg.setRedirect(true);
				return pg;
		    }
    	}
    	else{
			PageReference pg = page.manageknowledge;
			pg.getParameters().put('id', editKB.id);
			pg.setRedirect(true);
			return pg;
    	}
    }

    public void addNewGA() {

        GAcustom gaNew = new GAcustom('Please Select Article...');
        newGroupArticles.add(gaNew);}

    public void removeLastGA() {
        Integer i = newGroupArticles.size();
        newGroupArticles.remove(i-1);
    }

    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      counter += list_size;
      return null;
   }
 
   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      return null;
   }
 
   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
 
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
}