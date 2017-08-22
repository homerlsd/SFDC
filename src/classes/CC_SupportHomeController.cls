/**
    @author 7S
    @version Nov 4 2014 
*/
public without sharing class CC_SupportHomeController {


//public DataCategoryWrapper CommonQuestions {get;set;}
public List<Question__kav> CommonQuestions {get;set;}
public List<DataCategoryWrapper> BrowseByTopics{get;set;}

public String TargetKnowledgeId {get;set;}
public String TargetDataCategoryName {get;set;}
public String TargetDataCategoryLabel {get;set;}

private String paramClient;
private String paramPartner;
private String paramAffiliation;

private String groupName;
private String channel;
public String siteMessage {get;set;}




public CC_SupportHomeController() {
    paramClient = ApexPages.CurrentPage().getparameters().get('Client');
    paramPartner = ApexPages.CurrentPage().getparameters().get('Partner');
    paramAffiliation = ApexPages.CurrentPage().getparameters().get('Affiliation');
    groupName = ApexPages.CurrentPage().getparameters().get('DataCategoryGroupName');
    channel = ApexPages.CurrentPage().getparameters().get('channel');
    getCategories();
}


/**
 * 
 */
private void getCategories() {
    List<String> groupIds = new List<String>();

    system.debug('DO WE GET CATEGORIES FOR FAQ ');

    SSU__c SiteUtility = SSU__c.getInstance('Rally Support');

    if(SiteUtility.active__c){

      if(groupName == null || groupName == '')
        groupName = CC_Util.getGroupName(paramClient,paramPartner,paramAffiliation,channel);

      system.debug('GROUP NAME IS ' + groupName);
    }
    else{
      groupName = Label.DEFAULT_Site_Down_Group_Name;
      siteMessage = SiteUtility.Error_Message__c;
    }

    groupIds = CC_Util.getGroupIDs(groupName);

    system.debug('GROUP ID IS ' + groupIds);

    List<Question__kav> lisKAV = Database.query(CC_Constants.BASE_QUERY + ' AND KnowledgeArticleID IN : groupIds order by Category__c');

    system.debug('LIST QUESTIONS ARE ' + lisKAV);

    CommonQuestions = Database.query(CC_Constants.BASE_QUERY + ' AND KnowledgeArticleID IN : groupIds AND Is_Common_Question__c = true order by Category__c');

    BrowseByTopics = new List<DataCategoryWrapper>();
    Map<String,List<Question__kav>> mapCatAndKA = new Map<String,List<Question__kav>>();

    for(Question__kav ka : lisKAV){
      if(!String.isEmpty(ka.Category__c)){
          if(!mapCatAndKA.containsKey(ka.Category__c)){
              List<Question__kav> lisQ = new List<Question__kav>();
              lisQ.add(ka);
              mapCatAndKA.put(ka.Category__c, lisQ);
          }else {
              mapCatAndKA.get(ka.Category__c).add(ka);
          }  
      }
    }
    // here keep the picklist order 
    Schema.DescribeFieldResult fieldResult =
    Question__kav.Category__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

    List<String> picklistValues = new List<String>();  
      
    for( Schema.PicklistEntry p : ple)
    {
        picklistValues.add(p.getValue());
    }       

      
      //for(String g: mapCatAndKA.keySet()){
    for(String g: picklistValues){
        if(mapCatAndKA.containsKey(g)){
            DataCategoryWrapper w = new DataCategoryWrapper();

            w.CategoryName = g;

            w.Questions= mapCatAndKA.get(g);
            w.FirstFiveQuestions = new List<Question__kav>();

            Integer count = 0;
            for(Integer i=0;i<5;i++){
                if(i<w.Questions.size()){
                    w.FirstFiveQuestions.add(w.Questions[i]);
                }
            }
            BrowseByTopics.add(w);
        }
    }
}



/**
 * actions
 */
 
public PageReference NavigatesToKnowlegeByDataCat (){
    return new PageReference('/CC_KnowledgeByDataCategory?DataCategoryName='+TargetDataCategoryName +'&DataCategoryGroupName='+groupName);
}

 public PageReference NavigatesToDetail (){
       // return new PageReference('/CC_KnowledgeDetail?KnowledgeId='+TargetKnowledgeId + '&DataCategoryLabel='+ DataCategoryLabel );
        return new PageReference('/CC_KnowledgeDetail?KnowledgeId='+TargetKnowledgeId +'&DataCategoryGroupName='+groupName  );
}

/**
 * Data Category Wrapper
 */
 
 public class DataCategoryWrapper{

     public String CategoryName{get;set;}
     public List<Question__kav> FirstFiveQuestions{get;set;}
     public List<Question__kav> Questions{get;set;}
     public Integer QuestionsSize {
         get{
             return Questions.size();
         }
     }
     
 }

}