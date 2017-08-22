public with sharing class ManageAffiationController {

    /*public List<Affiliation> affiliationWrapperList {get;set;}
    
    public List<sObject> newStuff {get;set;}
    
    public List<Affiliation__c> newAffils {get;set;}
    public List<Affiliation__c> updateAffils {get;set;}
    public List<Client_Affiliation__c> newClientAffils {get;set;}
    public List<Segmentation_ID__c> newSegIDs {get;set;}

    public Milestone1_Project__c impl {get;set;}

    public string implId {get;set;}
    
    public List<Affiliation__c> affiliations {get;set;}
    public List<String> newAffilStrings {get;set;}
    public Set<string> affiliationNames {get;set;}
    public Map<string,Affiliation__c> affmap {get;set;}
    public boolean showSegmentPanel {get;set;}
    public String selectedRecordId {get;set;}

    public ManageAffiationController() {
        implId = Apexpages.currentPage().getParameters().get('id');

        affiliations = new List<Affiliation__c>();
        affmap = new Map<string,Affiliation__c>();
        newAffilStrings = new List<string>();

        showSegmentPanel = false;

        impl = [select id, account__c, account__r.name, Partner__c, Initial_Approval_Date__c from Milestone1_Project__c where ID = : implid];

        affiliationWrapperList = new List<affiliation>();
        Affiliation__c aff = new Affiliation__c();
        affiliationWrapperList.add(new affiliation(aff));

        affiliationNames = findAffiliationName();

        if(impl.Partner__c == Label.ManageAffiliations_BCBSPartnerID)
            showSegmentPanel = true;


    }

    @RemoteAction
    public static List<Affiliation__c> getAffiliation(String searchString, String impid) {
        searchString = '%'+searchString+'%';
        system.debug('searchstring'+searchstring);
        Milestone1_Project__c impl=[select Id, Name, Partner__c from Milestone1_Project__c where Id=:impid];
        system.debug('impl' +impl);
        List<Affiliation__c> lstaff = [select id, name, Affiliation_String__c, Affiliation_Roles__c from Affiliation__c  where Partner__c = :impl.Partner__c and Name LIKE :searchstring];
        system.debug('lastaff' +lstaff);
        return lstaff;
    }



    public void AddHashtagSuggs() {
        String typedword = Apexpages.currentPage().getParameters().get('word');
    }

    public class affiliation{
        public affiliation__c affil {get;set;}
        public string postAppChange {get;set;}
        public List<segmentID> segmentList {get;set;}

        public affiliation(affiliation__c affilParam){
            this.affil = affilParam;
            this.postAppChange = '';
            Segmentation_ID__c segid = new Segmentation_ID__c();
            this.segmentList = new List<segmentID>();
            this.segmentList.add(new segmentID(new Segmentation_ID__c()));
            system.debug('SEGMENT LIST IS ' + this.segmentList);
        }

    }

    public class segmentID{
        public Segmentation_ID__c segID          {get;set;}
        public String segPrefix                  {get;set;}
        public String segSuffix                  {get;set;}
        public String segRangeorNumber           {get;set;}

        public segmentID(Segmentation_ID__c segParam){
            this.segID = segParam;
        }
    }

    public void addAffiliationRow(){
        Affiliation__c afnew = new affiliation__c();
        affiliationWrapperList.add(new affiliation(afnew));
        findAffiliationName();
    }

    public void removeAffiliation(){
        integer i = affiliationWrapperList.size();
        affiliationWrapperList.remove(i-1);
    }

    public void addSegmentIDRow(){
        system.debug('ARE WE ADDING SEGIDS ' + Apexpages.currentPage().getParameters().get('g'));
        integer indexSeg = integer.valueOf(Apexpages.currentPage().getParameters().get('g'));
        system.debug(affiliationWrapperList[indexSeg].segmentList.size());
        affiliationWrapperList[indexSeg].segmentList.add(new SegmentID(new Segmentation_ID__c()));
        system.debug(affiliationWrapperList[indexSeg].segmentList.size());
    }

    public void removeSegmentIDRow(){
        Affiliation__c afnew = new affiliation__c();
        affiliationWrapperList.add(new affiliation(afnew));
    }

    public PageReference saveAffils(){
        newStuff = new List<sObject>();
        newAffils = new List<Affiliation__c>();
        newClientAffils = new List<Client_Affiliation__c>();
        newSegIDs = new List<Segmentation_ID__c>();
        updateAffils = new List<Affiliation__c>();

        Map<String, List<Segmentation_ID__c>> segmap = new Map<String, List<Segmentation_ID__c>>();
        Map<String,String> newStringMap = new Map<String,String>();
        Map<String,String> newStringMapRole = new Map<String,String>();
        Map<String,String> postAppChangeMap = new Map<String,String>();

        for(affiliation af : affiliationWrapperList){
            system.debug('AFF MAP IS BEFORE INSERT ' + affMap);
            system.debug('affiliationWrapperList' +affiliationWrapperList);
            system.debug('af.affil.name' +af.affil.name);
            if(!affMap.containsKey(af.affil.name)){
                system.debug('DO WE INSERT A NEW AFFILIATION STRING ' + af.affil.name);
                system.debug('DO WE INSERT A NEW AFFILIATION STRING FRIENDLY NAME ' + af.affil.Affiliation_String__c);
                
                af.affil.Partner__c = impl.Partner__c;
                newAffils.add(af.affil);
            }
            else{
                newStringMap.put(af.affil.name,af.affil.Affiliation_String__c);
                newStringMapRole.put(af.affil.name, af.affil.Affiliation_Roles__c);
                Affiliation__c affite=affmap.get(af.affil.name);
                affite.Affiliation_Roles__c=newStringMapRole.get(af.affil.Name);
                updateAffils.add(affite);
            }

            if(af.postAppChange != null && af.postAppChange != '')
                postAppChangeMap.put(af.affil.name, af.postAppChange);
            
            newAffilStrings.add(af.affil.name);

            for(segmentID s : af.segmentList){
                if(s.segID.name != null && s.segID.name != ''){
                    if(segMap.isEmpty() || !segMap.containsKey(af.affil.name)){
                        segMap.put(af.affil.name, new List<Segmentation_ID__c>{s.segID});
                    }
                    else if(segMap.containsKey(af.affil.name)){
                        segMap.get(af.affil.name).add(s.segID);
                    }
                }
            }
        }

        system.debug('SEG MAP IS ' + segMap);
        system.debug('POST CHANGE MAP IS ' + postAppChangeMap);

        insert newAffils;
        
        if(updateAffils.size()>0){
          update updateAffils;
        }

        for(Affiliation__c a1 : [select id, name,Affiliation_String__c, Affiliation_Type__c,affiliation_Roles__c from Affiliation__c where Name IN : newAffilStrings]){

                system.debug('AFFILIATION TO BE JOINED WITH CLIENT IS  ' + a1.name);

                Client_Affiliation__c ca = new Client_Affiliation__c(Implementation__c = implid);
                ca.affiliation__c = a1.id;
                ca.affiliation_Roles__c =(!newStringMapRole.isEmpty() && newStringMapRole.containsKey(a1.name)) ? newStringMapRole.get(a1.name) : a1.Affiliation_Roles__c;
                ca.Affiliation_Type__c =a1.Affiliation_Type__c;
                ca.name = (!newStringMap.isEmpty() && newStringMap.containsKey(a1.name)) ? newStringMap.get(a1.name) : a1.Affiliation_String__c;
                if(postAppChangeMap.containsKey(a1.name))
                    ca.Post_Approval_Change_Control__c = postAppChangeMap.get(a1.name);
                ca.Account__c = impl.account__c;

                newClientAffils.add(ca);
        }


        if(!newClientAffils.isEmpty()){

            system.debug('CLIENT AFFILIATIONS ARE ' + newClientAffils);

            insert newClientAffils;

            for(Client_Affiliation__c ca1 : [select id, name, Affiliation__r.name from Client_Affiliation__c where ID IN : newClientAffils]){
                if(segMap.containsKey(ca1.Affiliation__r.name)){
                    for(Segmentation_ID__c seg1 : segMap.get(ca1.Affiliation__r.name)){
                        seg1.Client_Affiliation__c = ca1.id;
                        newSegIDs.add(seg1);
                    }   
                }
            }
            
            system.debug('newSegIds' +newSegIDs);

            if(!newSegIDs.isEmpty())
                insert newSegIDs;
        }

        PageReference pg = new PageReference('/'+impl.id);
        pg.setRedirect(true);
        return pg;
    }

    public set<string> findAffiliationName() {

        affiliations = [select id, name, Affiliation_String__c, Affiliation_Roles__c from Affiliation__c  where Partner__c = :impl.Partner__c];
        for(Affiliation__c af : affiliations){
            affMap.put(af.name,af);
        }

        system.debug('AFFILIATIONS ARE ' + affMap);
        return affMap.keyset();
    }  */
}