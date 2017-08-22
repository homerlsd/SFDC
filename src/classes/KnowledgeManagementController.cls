/**
* Controller for Visual force Page.
* author SFDC
*/
public class KnowledgeManagementController{
	//Page Size
	private Static Final Integer PAGE_NUMBER = 10;
	//Search String used in ArticleList tag
	public String searchstring { get; set; }
	public String recordID { get; set; }
	public String title { get; set; }
	public String SelectedLetter { get; set; }
	public String urlstring { get; set; }
	public string publishDate {get;set;}
	public string origPubDATE {get;set;}
	public string artNumber {get;set;}

	//Is new List reqd
	private boolean isRefRequired = true;
	public boolean creatingArticle {get;set;}
	public boolean foundEditArticle {get;set;}
	public boolean publish {get;set;}
	//Exclude filter criteria for UI only
	private static final String EXCLUDE_CRITERIA_FILTER = 'All';

	public List<Question__Kav> allArticles {get;set;}
	public List<Question__Kav> allDraftArticles {get;set;}
	//Used as the new Article if they create/publish one
	public Question__Kav art {get;set;}
	public question__ka editQ {get;set;}
	//Keeps track of current page & max size of article list
	Integer currentPage = 1;
	Integer maxSize = 1;

	private integer totalLIVEKnowledge = 0;
	private integer totalDRAFTKnowledge = 0;
	private integer OffsetSize = 0;
	private integer LimitSize= 10;

	public boolean hasNxt {get;set;}
	public boolean hasPrev {get;set;}


	public KnowledgeManagementController(){
		foundEditArticle = false;
		creatingArticle = false;
		publish = false;
		hasNxt = false;
		hasPrev = true;

		SelectedLetter = 'A';
		urlstring = '';
		publishDate = '';
		origPubDATE = '';
		artNumber = '';

		art = new Question__Kav();

		totalLIVEKnowledge = database.countQuery(CC_Constants.BASE_QUERY_COUNT_PUBLISHED);
		totalDraftKnowledge = database.countQuery(CC_Constants.BASE_QUERY_COUNT_UNPUBLISHED);

		recordID = Apexpages.CurrentPage().getParameters().get('id');
		
		if(recordID != null && recordID != '')
			queryCurrentRecord();
		else
			title = 'New Article';

		ChooseFirstLetter();
	}

	public void ChooseFirstLetter() {
		OffsetSize = 0;
		LimitSize = 10;
        SelectedLetter = Apexpages.currentPage().getParameters().get('letter');

        system.debug('SELECTED LETTER IS ' + SelectedLetter);
      
      	if(SelectedLetter == null)
      		SelectedLetter = 'A';
        SelectedLetter+='%';

        system.debug('LIVE QUERY IS ' + CC_Constants.BASE_QUERY + ' and title like :SelectedLetter LIMIT : LimitSize OFFSET: OffsetSize');

        allArticles = Database.query(CC_Constants.BASE_QUERY + ' and title like :SelectedLetter LIMIT : LimitSize OFFSET: OffsetSize');
        
        system.debug('ALL LIVE QUESTIONS ARE ' + allArticles);

        system.debug('DRAFT QUERY IS ' + CC_Constants.BASE_QUERY_UNPUBLISHED + ' and title like :SelectedLetter LIMIT : LimitSize OFFSET: OffsetSize');

        allDraftArticles = database.query(CC_Constants.BASE_QUERY_UNPUBLISHED + ' and title like :SelectedLetter LIMIT : LimitSize OFFSET: OffsetSize');

        system.debug('ALL Draft QUESTIONS ARE ' + allDraftArticles);

    }

    public void refreshQuery() {
      
      	if(!SelectedLetter.contains('%'))
      		SelectedLetter+='%';

        system.debug('LIVE QUERY IS ' + CC_Constants.BASE_QUERY + ' and title like :SelectedLetter LIMIT : LimitSize OFFSET: OffsetSize');

        allArticles = Database.query(CC_Constants.BASE_QUERY + ' and title like :SelectedLetter LIMIT : LimitSize OFFSET: OffsetSize');
        
        system.debug('ALL LIVE QUESTIONS ARE ' + allArticles);

        system.debug('DRAFT QUERY IS ' + CC_Constants.BASE_QUERY_UNPUBLISHED + ' and title like :SelectedLetter LIMIT : LimitSize OFFSET: OffsetSize');

        allDraftArticles = database.query(CC_Constants.BASE_QUERY_UNPUBLISHED + ' and title like :SelectedLetter LIMIT : LimitSize OFFSET: OffsetSize');

        system.debug('ALL Draft QUESTIONS ARE ' + allDraftArticles);

        getBools();

    }

	public void queryCurrentRecord(){
		List<string> currRecs = new list<string>();
		currRecs.add(recordID);
		try{
		
			system.debug('FIRST QUERY IS ' + CC_Constants.BASE_QUERY + ' AND (ID IN :currRecs OR KnowledgeArticleID IN : currRecs)');

			List<Question__Kav> arts = database.query(CC_Constants.BASE_QUERY + ' AND (ID IN :currRecs OR KnowledgeArticleID IN : currRecs)');

			if(arts.isEmpty()){
				//if we get here we have an article that has never been pubed and need to access question__ka
				system.debug('SECOND QUERY IS ' + CC_Constants.BASE_QUERY_UNPUBLISHED + ' AND (ID IN :currRecs OR KnowledgeArticleID IN : currRecs)');
				
				List<Question__Kav> editQs = database.query(CC_Constants.BASE_QUERY_UNPUBLISHED + 'AND (ID IN :currRecs OR KnowledgeArticleID IN : currRecs)');

				if(editQs.isEmpty()){

					system.debug('THIRD QUERY IS ' + CC_Constants.BASE_QUERY_ARCHIVED + ' AND (ID IN :currRecs OR KnowledgeArticleID IN : currRecs) AND isLatestVersion = false');
				
					List<Question__Kav> editQ1s = database.query(CC_Constants.BASE_QUERY_ARCHIVED + 'AND (ID IN :currRecs) AND isLatestVersion = false');

					if(editQ1s.isEmpty()){
						ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid ID - Please See Salesforce Administration.');
	            		ApexPages.addMessage(myMsg);
	            	}
	            	else{
	            		art = editQ1s[0].clone(true);
	            		artNumber = editQ1s[0].articlenumber;
	            	}
				}
				else{
					art = editQs[0].clone(true);
					artNumber = editQs[0].articlenumber;
				}
			}
			else{
				art = arts[0].clone(true);
				artNumber = arts[0].articlenumber;
			}

			if(art.id != null){
				foundEditArticle = true;
				system.debug('DO WE GET HERE ' + art.PublishStatus);
				system.debug('DO WE GET HERE ' + art.articlenumber);
    			
				if(art.Publish_Date_Future__c != null && art.PublishStatus.toLowerCase() == 'draft'){
					title = 'Published Status: Scheduled for ' + string.valueOf(art.Publish_Date_Future__c).replace('00:00:00', '');
					origPubDATE = string.valueOf(art.Publish_Date_Future__c);
					publishDate = string.valueOf(art.Publish_Date_Future__c);		
				}		
				else
					title = 'Published Status: ' + art.PublishStatus;

				system.debug('TITLE IS ' + title);
			}
		
		}
		catch(Exception ex){
			Apexpages.addmessages(ex);
		}
	}
	
	public PageReference createNewArticle(){
		PageReference pg = Page.NewKnowledgeArticle;
		pg.setRedirect(true);
		pg.getParameters().put('creatingArticle', 'true');
		return pg;
	}

    /*public List<SelectOption> getArticleTypes() {
    	List<SelectOption> Options = new List<SelectOption>();
    	Options.add(new SelectOption('Please select Article Type...', 'Please select Article Type...'));
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
		Set<String> keySet = gd.keySet();
		for (String key : keySet) {
		    Schema.SObjectType objectType = gd.get(key);
		    if (key.endsWith('ka') || key.endsWith('kb')) {
		        Options.add(new SelectOption(objectType.getDescribe().getName(), objectType.getDescribe().getLabel()));
		    }
		}        

        System.debug('Options is' + Options);

        return Options;
    }*/

    public PageReference save(){
    	try{

    		art.urlname = setUrlName();
    		if(publishDate != '' && (origPubDATE == '' || (origPubDATE != null && origPubDATE != publishDate)))
    			art.Publish_Date_Future__c = date.parse(publishDate);
    		upsert art;
    		
    		if((recordID == null || recordID == '') && art.Is_Default_Question__c == true)
    			insertDefaults();
    		else if(recordID != null && recordID != '')
    			updateDefaults();

    		PageReference pg = page.NewKnowledgeArticle;
    		pg.getParameters().put('id', art.id);
    		pg.setRedirect(true);
    		return pg;
    	}
    	catch( Exception ex ) {
	        Apexpages.addmessages( ex );
	        return null;
    	}
    	return null;
    }

    public PageReference saveandPub(){
    	try{

    		PageReference pg = page.NewKnowledgeArticle;
    		pg.getParameters().put('id', art.id);
			
			art.urlname = setUrlName();	
    		upsert art;
    		
    		if((recordID == null || recordID == '') && art.Is_Default_Question__c == true)
    			insertDefaults(); 
    		
    		system.debug('DO WE GET HERE - PRE PUBLISHED' + art.KnowledgeArticleID);

    		if(publishDate != '' && (origPubDATE == '' || (origPubDATE != null && origPubDATE != publishDate))){
    			system.debug('PUBLISH DATE IS ' + publishDate);
    			system.debug('ORIG PUBLISH DATE IS ' + publishDate);
    			
    			art.Publish_Date_Future__c = date.parse(publishDate);
    			update art;
    			KbManagement.PublishingService.scheduleforpublication(art.KnowledgeArticleID, date.parse(publishDate));

    			pg.getParameters().put('scheduled', publishDate);

    		}
    		else{
    			KbManagement.PublishingService.publishArticle(art.KnowledgeArticleID, true);
    			pg.getParameters().put('published', 'true');
    		}

    		system.debug('DO WE GET HERE - POST PUBLISHED' + art.KnowledgeArticleID);

    		if(recordID != null && recordID != '')
    			updateDefaults();

    		pg.setRedirect(true);
    		return pg;

    	}
    	catch( Exception ex ) {
	        Apexpages.addmessages( ex );
	        return null;
    	}
    	return null;
    }

    public PageReference unPublish(){
    	try{    		
    		system.debug('DO WE GET HERE - PRE UNPUBLISHED' + art.KnowledgeArticleID);

    		KbManagement.PublishingService.editOnlineArticle(art.KnowledgeArticleID, true);

    		system.debug('DO WE GET HERE - POST UNPUBLISHED' + art.KnowledgeArticleID);

    		PageReference pg = page.NewKnowledgeArticle;
    		pg.getParameters().put('id', art.KnowledgeArticleID);
    		pg.getParameters().put('unpublished', 'true');
    		pg.setRedirect(true);
    		return pg;

    	}
    	catch( Exception ex ) {
	        Apexpages.addmessages( ex );
	        return null;
    	}
    	return null;
    }

    public PageReference editPublished(){
    	try{    		
    		system.debug('DO WE GET HERE - PRE EDIT PUBLISHED' + art.KnowledgeArticleID);

    		Id tempID = KbManagement.PublishingService.editOnlineArticle(art.KnowledgeArticleID, false);

    		system.debug('DO WE GET HERE - POST EDIT PUBLISHED' + art.KnowledgeArticleID);

    		PageReference pg = page.NewKnowledgeArticle;
    		pg.getParameters().put('id', tempID);
    		pg.getParameters().put('unpublished', 'true');
    		pg.setRedirect(true);
    		return pg;

    	}
    	catch( Exception ex ) {
	        Apexpages.addmessages( ex );
	        return null;
    	}
    	return null;
    }

    public void insertDefaults(){

    	system.debug('ARE WE INSERTING DEFAULTS ' + recordID);

    	List<Knowledge_Group__c> kbGroups = [select id from Knowledge_Group__c where Active__c = true];
    	
    	List<Group_Article__c> newGas = new List<Group_Article__c>();

		for (Knowledge_Group__c kb: kbGroups) {
    		Group_Article__c newGa = new Group_Article__c();
    		newGa.Knowledge_Group__c = kb.id;
    		newGa.Knowledge_Article_ID__c = art.KnowledgeArticleID;
    		newGa.Active__c = true;
    		newGa.Knowledge_Summary__c = art.summary;
    		newGa.Knowledge_Title__c = art.title;
    		newGa.knowledge_description__c = art.RichTextSummary__c;
    		newGa.Is_Default_Question__c = art.Is_Default_Question__c;
    		newGa.Is_Common_Question__c = art.Is_Common_Question__c;
    		newGa.Knowledge_LastPublishedDate__c = date.valueOf(art.LastPublishedDate);
    		newGas.add(newGa);
    	}

    	try{
    		system.debug('DO WE INSERT DEFAULTS ' + newgas.size());
    		insert newGas;
    	}
    	catch( Exception ex ) {
	        Apexpages.addmessages( ex );
	        return;
    	}
    }

    public void updateDefaults(){

    	system.debug('ARE WE UDATING EXISTING RECORDS ' + recordID);

    	List<Group_Article__c> updateGas = [select id,Knowledge_Summary__c,Knowledge_Title__c,knowledge_description__c,Knowledge_LastPublishedDate__c from Group_Article__c where Knowledge_Article_ID__c = : art.KnowledgeArticleID];
    	
		for (Group_Article__c ga: updateGas) {
    		ga.Knowledge_Summary__c = art.summary;
    		ga.Knowledge_Title__c = art.title;
    		ga.knowledge_description__c = art.RichTextSummary__c;
    		ga.Knowledge_LastPublishedDate__c = date.valueOf(art.LastPublishedDate);
    		ga.Is_Default_Question__c = art.Is_Default_Question__c;
    		ga.Is_Common_Question__c = art.Is_Common_Question__c;
    	}

    	try{
    		system.debug('DO WE UPDATE EXISTING RECORDS ' + updateGas.size());
    		update updateGas;
    	}
    	catch( Exception ex ) {
	        Apexpages.addmessages( ex );
	        return;
    	}
    }

    public string setUrlName(){   
    	string urlS = ''; 	
    	if(art.title != null && art.title != '')
    		urlstring = art.title.replace(' ', '-');
    	string rando = string.valueOf(math.round(math.random()*1000));
    	urlstring = urlstring + '_' + rando;
    	return urls;
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

	public void openPublish(){
		publish = true;
	}
}