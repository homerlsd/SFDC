public without sharing class CC_KnowledgeDetailController {
    

    public String DataCategoryName {get;set;}
    public Question__kav Article{get;set;}
    public Group_Article__c gArticle{get;set;}
    
    public String LastPublishedDate {get;set;}
    private String knowledgeId;
    private String groupName;

    public CC_KnowledgeDetailController() {
         groupName = ApexPages.currentPage().getParameters().get('DataCategoryGroupName');
         knowledgeId = ApexPages.currentPage().getParameters().get('KnowledgeId');
         
         if(!String.IsEmpty(knowledgeId)){

            if(!String.isEmpty(groupName))
                groupName = String.escapeSingleQuotes(groupName);   
            else
                groupName = CC_Constants.DEFAULT_GROUP_NAME;

            system.debug('WHAT IS THE GROUP NAME ' + groupName);
            system.debug('WHAT IS THE ARTICLE ID ' + knowledgeId);                                       
                                                          
            List<Question__kav> kArticles = Database.query(CC_Constants.BASE_QUERY +' AND Id = \'' + knowledgeId +'\'');


            if(kArticles.size()>0){
                system.debug('ARTICLE KNOWLEDGE ID IS ' + kArticles[0].KnowledgeArticleID);
                
                List<Group_Article__c> groupArticle = [select id,
                                                          Custom_URL__c
                                                          from Group_Article__c
                                                          where Knowledge_Group__r.Group_Name__c = : groupName
                                                          AND Knowledge_Article_ID__c = :kArticles[0].KnowledgeArticleID];
                if(groupArticle.size()>0){
                    gArticle = groupArticle[0];
                }      

                Article = kArticles[0];

                DataCategoryName = Article.Category__c;
                LastPublishedDate = Article.LastPublishedDate.format('MMM dd, yyyy hh:mma z','America/New_York');

            }  
        }     
    }
    
     /**
     * actions
     */

    public PageReference NavigatesToKnowlegeByDataCat (){
        return new PageReference('/CC_KnowledgeByDataCategory?DataCategoryName='+DataCategoryName +'&DataCategoryGroupName='+groupName);
    }
    
    
    public PageReference NavigatesToHome (){
        return new PageReference('/?DataCategoryGroupName='+groupName );
    }
}