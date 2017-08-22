/**
	@author 7S
	@version Nov 11 2014 
*/

public without sharing class CC_KnowledgeSearchController {
    
    // results
    // results
    public List<KnowledgeWrapper> ListOfKnowledge{
        get{
            List<Question__kav> lisKnowledge =  (List<Question__kav>) setController.getRecords(); 
            List<KnowledgeWrapper> lisWrapper = new List<KnowledgeWrapper>();
            for(Question__kav kv : lisKnowledge){
                KnowledgeWrapper k= new KnowledgeWrapper(kv);
                if(kv.summary !=null && kv.summary.length()>110){
                     k.ShortSummary = kv.summary.substring(0, 110) + '...'; 
                }
                else if(kv.summary !=null){
                     k.ShortSummary = kv.summary; 
                }
                lisWrapper.add(k);
            }
            return lisWrapper;    
        }
        set;
    }
    
    // for search   
    public List<string> groupIds {get;set;} 
    public String SearchString{ get;set;}
    public String EscapedSearchString { get; set;}
    // for by data category name
    public String DataCategoryGroupName {get;set;}
    public String DataCategoryName {get;set;}
    public String SearchLogID {get;set;}
 
    // for go to detail link
    public String TargetKnowledgeId {get;set;}
    // for group
    private String paramClient;
    private String paramPartner;
    private String paramAffiliation;
    private String paramChannel;

    private String groupName;
    // for pagination
    public List<Integer> PageNum {get;set;} 
    private final Integer PAGE_SIZE = 10;
    private Integer totalP;
    
    public CC_KnowledgeSearchController(){
        SearchLogID = '';

        SearchString = ApexPages.currentPage().getParameters().get('SearchString');
        DataCategoryName = ApexPages.currentPage().getParameters().get('DataCategoryName');

        DataCategoryGroupName = ApexPages.currentPage().getParameters().get('DataCategoryGroupName');
        
        paramClient = ApexPages.CurrentPage().getparameters().get('Client');
        paramPartner = ApexPages.CurrentPage().getparameters().get('Partner');
        paramAffiliation = ApexPages.CurrentPage().getparameters().get('Affiliation');
        paramChannel = ApexPages.CurrentPage().getparameters().get('Channel');
        // default is one
        SpecifiedPageNumber=1;
        
        if(!String.isEmpty(SearchString)){
            EscapedSearchString = String.escapeSingleQuotes(SearchString);
        }
    }
          
    public ApexPages.StandardSetController setController {
        get {
            if(setController == null) {
                //Assumptions: Knowledge articles no more than 10,000
                //QueryLocator will throw LimitException more than 10,000
                //in case more than 10,000 records exist LIMIT 10,000
                setController = new ApexPages.StandardSetController(Database.getQueryLocator(ConstructQuery()));
            
                setController.setPageSize(PAGE_SIZE);
                 
                PageNum = new List<Integer>();
            
                if(Math.mod(setController.getResultSize(),setController.getPageSize()) == 0){
                        totalP=setController.getResultSize()/setController.getPageSize();
                }else{
                        totalP= setController.getResultSize()/setController.getPageSize()+1; 
                } 
    
                for(Integer i=1; i <= totalP; i++){
                    PageNum.add(i);
                }
            }

            return setController;
        }
        set;
    }
    
   
    private String ConstructQuery(){
        String QUERY = CC_Constants.BASE_QUERY;
        
        if(!String.isEmpty(DataCategoryGroupName)){
            groupName = DataCategoryGroupName;
        }else{
            groupName = CC_Util.getGroupName(paramClient, paramPartner,  paramAffiliation, paramChannel);
        }

        system.debug('GROUP NAME IS ' + groupName);

        groupIDs = CC_Util.getGroupIDs(groupName);

        if(!String.isEmpty(EscapedSearchString)){
            string removeS = (EscapedSearchString.endsWithIgnoreCase('s') ? EscapedSearchString.removeEndIgnoreCase('s') : EscapedSearchString);

            QUERY += ' AND (Keywords__c Like \'%' + removeS + '%\' or Title Like \'%' + removeS + '%\' or Summary Like \'%'+ removeS+ '%\') AND KnowledgeArticleID IN : groupIds order by Title limit 10000'; 
        } else if(!String.isEmpty(DataCategoryName)){
            QUERY += ' AND KnowledgeArticleID IN : groupIds AND Category__c = \'' + DataCategoryName + '\' order by Title limit 10000';

            //System.Debug('#### groupName='+ groupName +',DataCategoryName='+ DataCategoryName);

        } else{
            QUERY += ' limit 0'; 
        }
        
        return QUERY;
    }

    /**
     * actions
     */
     
    
    public PageReference NavigatesToDetail (){
        try{
            createClickThroughLog();
            return new PageReference('/CC_KnowledgeDetail?KnowledgeId='+TargetKnowledgeId +'&DataCategoryGroupName='+groupName  );
        }
        catch(exception ex){
            return new PageReference('/CC_KnowledgeDetail?KnowledgeId='+TargetKnowledgeId +'&DataCategoryGroupName='+groupName  );
        }
    }
    public PageReference NavigatesToHome (){
        return new PageReference('/?DataCategoryGroupName='+groupName );
    }

    /**
    SEARCH/CLICKTHROUGH ANALYTICS STUFF
    */

    public void findSearchLogID(){
        system.debug('SEARCH IS ' + EscapedSearchString);
        if(EscapedSearchString != null && EscapedSearchString != ''){
            
            Integer resultSize = 0;
            Question__kav[] tempList = database.Query(ConstructQuery());
            
            if(!tempList.isEmpty())    
                resultSize = tempList.size();        

            try{
                System_Log__c sl = new System_Log__c();
                sl.recordtypeid = Label.DEFAULT_SEARCH_LOG_RECORDTYPE_ID;
                sl.Search_String__c = EscapedSearchString;
                sl.Number_of_Results__c = resultSize;
                sl.Group_Name__c = groupName;

                insert sl;

                SearchLogID = sl.id;
            }
            catch(exception ex){}
        }
    }
    
    public void createClickThroughLog(){
        System_Log__c sl = new System_Log__c();
        sl.recordtypeid = Label.DEFAULT_CLICKTHROUGH_LOG_RECORDTYPE_ID;
        sl.Article_Id__c = TargetKnowledgeId;
        sl.Article_Name__c = Utils.KnowledgeArticleName(TargetKnowledgeId);
        sl.Parent_Log__c = SearchLogID;
        insert sl;
    }
   
    /**
        Methods for pagenation
    */
 
    public Boolean hasNextSet {
        get {
            return setController.getHasNext();
        }
        set;
    }
 
    public Boolean hasPrevSet {
        get {
            return setController.getHasPrevious();
        }
        set;
    }
 
    public Integer PageNumber {
        get {
            return setController.getPageNumber();
        }
        set;
    }

 	public Integer TotalPages{
 			get{
                return totalP;
 			}
 	}
    
    public  Integer SpecifiedPageNumber{
    	get;
    	set;
    } 

    public void PrevSet() {
            SpecifiedPageNumber-=1;
        	setController.previous();
    }
 
 
    public void NextSet() {
            SpecifiedPageNumber+=1;
    		setController.next();  
    		
    }
    
    public Integer ResultsSize {
        get{
          return setController.getResultSize();
        }
    }
    
    public void GoToPage () {
    
    	if(SpecifiedPageNumber!=null){
    		setController.setpageNumber(SpecifiedPageNumber);
    	}
  }
  /**
  Knowledge Wrapper
 */
 
 public class KnowledgeWrapper{
     KnowledgeWrapper(Question__kav k){
         kv = k;
     }
     public Question__kav kv {get;set;}
     public String ShortSummary {get;Set;}
     public String PublishedDate {get{
         return kv.LastPublishedDate.format('MMM dd, yyyy hh:mma z');
     }}
     
 }

	
}