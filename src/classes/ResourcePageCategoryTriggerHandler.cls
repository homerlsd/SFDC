public class ResourcePageCategoryTriggerHandler{
  
  

  public static void AfterUpsert(Resource_Page_Category__c[] rpc) {

    /*Set<id> rprids = new Set<ID>();
    Map<Id, Resource_Page_Requirement__c> Maprpq=new Map<Id, Resource_Page_Requirement__c>();
    List<Resource_Page_Requirement__c> lstrpq=new List<Resource_Page_Requirement__c>();
    Map<Id, List<Resource_Page_Category__c>> Maprpc=new Map<Id, List<Resource_Page_Category__c>>();
    List<Resource_Page_Requirement__c> lstrpqemp=new List<Resource_Page_Requirement__c>();

    string 
    for(Resource_Page_Category__c rpcits : rpc){
        Categories
    }

    system.debug('rprids' +rprids);
    
    for(Resource_Page_Requirement__c rpq:[select Id, Catalog_Title__c from Resource_Page_Requirement__c where Id IN:rprids]){
        if(!maprpq.containsKey(rpq.Id)){
            maprpq.put(rpq.Id, rpq);
        }
        rpq.Catalog_Title__c='';
        lstrpqemp.add(rpq);
    }   
    
    if(lstrpqemp.size()>0){
      update lstrpqemp;
    }
    
    for(Resource_Page_Category__c rp:[select Id, Category_Title__c, Resource_Page_Requirement__c from Resource_Page_Category__c where Resource_Page_Requirement__c IN:rprids order by createddate]){
      if(!maprpc.containsKey(rp.Resource_Page_Requirement__c)){
         maprpc.put(rp.Resource_Page_Requirement__c, new List<Resource_Page_Category__c>());
      }
      maprpc.get(rp.Resource_Page_Requirement__c).add(rp);
    }
    
    
   for(id idite:maprpc.Keyset()){
   
    Resource_Page_Requirement__c rpqu=maprpq.get(idite);
    string f='';
    Integer i =maprpc.get(idite).size();
    integer j=0;
      if(maprpc.get(idite).size()>0){
       for(Resource_Page_Category__c rpcite:maprpc.get(idite)){
         if(rpcite.category_title__c!=Null){
         j++;
         if(j<=i){
           
            f+= 'Title #' + j+ ': ' + rpcite.category_title__c + '\n';
             } 
           }
         }  
          rpqu.catalog_Title__c+=f; 
       } 
       lstrpq.add(rpqu); 
      }
   
  
        if(lstrpq.size()>0){
          update lstrpq;
        }*/
    }
}