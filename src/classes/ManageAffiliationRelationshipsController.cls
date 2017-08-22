public class ManageAffiliationRelationshipsController {

    public SelectOption[] selectedAffiliation { get; set; }
    public SelectOption[] allAffiliation { get; set; }
    
    public string message { get; set; }
    public string recID { get; set; }
    public string impID { get; set; }
    public string sObjName { get; set; }

    public List<sObject> newObjects {get;set;}
    public sObject parentObject {get;set;}

    public Set<string> initialAffils {get;set;}

    public Map<string,string> affilMap {get;set;}    
    public Map<string,string> initialMap {get;set;}  

    public Milestone1_Project__c imp {get;set;}  

    public Set<string> recs {get;set;}

    public ManageAffiliationRelationshipsController() {

        impID = Apexpages.currentPage().getParameters().get('impID');
        recID = Apexpages.currentPage().getParameters().get('recID');
        sObjName = Utils_Implementation.findObjectNameFromRecordIdPrefix(recID);

        recs = new Set<String>{recID};

        initialAffils = new Set<string>();
        affilMap = new Map<string,string>();
        initialMap = new Map<string,string>();

        Set<String> joinFields = Schema.SObjectType.Affiliation_Join__c.fields.getMap().keySet();
        for(string s : joinFields){
            system.debug('JOIN FIELDS ARE ' + s);
        }

        imp = [select id, Initial_Approval_Date__c from Milestone1_Project__c where ID=:impID];

        system.debug('PARENT OBJECT TYPE IS ' + sObjName);

        if(joinFields.contains(sObjName)){

            String queryString = 'select Id, Client_Affiliation__c, Affiliation_Display_Name__c, Client_affiliation__r.name, Client_affiliation__r.createdDate,' + sObjName;
            queryString += ' from Affiliation_Join__c WHERE ' + sObjName + ' IN : recs AND Client_affiliation__r.Implementation__c = \'' + impID +'\' ORDER BY Client_affiliation__r.createdDate';
            
            system.debug('QUERY  IS ' + queryString);

            newObjects = database.query(queryString);

            for(sObject sobj : newObjects){
                initialAffils.add(string.valueOf(sobj.get('Affiliation_Display_Name__c')));
                initialMap.put(string.valueOf(sobj.get('Affiliation_Display_Name__c')), string.valueOf(sobj.get('id')));
            }

            system.debug('INITIAL AFFILIATION JOINS ARE ' + initialAffils);

            selectedAffiliation = new List<SelectOption>();
            allAffiliation = new List<SelectOption>();

            List<Client_Affiliation__c> cas = [select id, name from Client_Affiliation__c WHERE Implementation__c = :impID];

            Set<ID> clientAffilIDs = new Set<ID>();

            for(Client_Affiliation__c c : cas){
                affilMap.put(c.name, c.id);

                if(initialAffils.isEmpty() || !initialAffils.contains(c.name))
                    allAffiliation.add(new SelectOption(c.Id, c.Name));
                else if(initialAffils.contains(c.name))
                    selectedAffiliation.add(new SelectOption(c.id, c.name));
            }
        }
        else{
            message = Label.ManageAffiliationRelationship_Message;
            return;
        }
    }

    public PageReference cancel(){
        PageReference pg = new PageReference('/'+recID);
        pg.setRedirect(true);
        return pg;
    }

    public PageReference save() {

        Set<string> deleteAffils = new Set<String>();

        system.debug('ALL NON SELECTED AFFILIATIONS ' + allAffiliation);

        for ( SelectOption so : allAffiliation ) {
            system.debug('ARE WE DELETING ' + so.getLabel());

            if(!initialAffils.isEmpty() && initialAffils.contains(so.getLabel())){
                system.debug('DO WE FIND A DELETE ROW ' + initialMap.get(so.getLabel()));
                deleteAffils.add(initialMap.get(so.getLabel()));
            }
        }

        for ( SelectOption so : selectedAffiliation ) {
            if(initialAffils.isEmpty() || (!initialAffils.isEmpty() && !initialAffils.contains(so.getLabel()))){
                Sobject o = Utils_Implementation.getsObjectType('Affiliation_Join__c').newSObject();
                o.put('Client_Affiliation__c', affilMap.get(so.getLabel()));
                o.put(sObjName, recID);
                newObjects.add(o);
            }
        }

        if(!newObjects.isEmpty())
            upsert newObjects;
        
        if(!deleteAffils.isEmpty()){

            List<Affiliation_Join__c> caDel = [select Id from Affiliation_Join__c where ID IN : deleteAffils];
            delete caDel;
        }

        if(imp.Initial_Approval_Date__c != null){

            newObjects.clear();

            String queryString1 = 'select Id, Client_Affiliation__c, Affiliation_String__c, Affiliation_Display_Name__c, Client_affiliation__r.name, Client_affiliation__r.createdDate,' + sObjName;
            queryString1 += ' from Affiliation_Join__c WHERE ' + sObjName + ' IN : recs AND Client_affiliation__r.Implementation__c = \'' + impID +'\' ORDER BY Client_affiliation__r.createdDate';
            
            system.debug('QUERY  IS ' + queryString1);

            newObjects = database.query(queryString1);

            string parentObjectQuery = 'select Id, Post_Approval_Change_Control__c from ' + sObjName + ' WHERE ID IN :recs';

            parentObject = database.query(parentObjectQuery);

            string ccontrol = 'Updated Affiliations related to this record:' +'\n';
            integer index = 0;

            for(sObject o : newObjects){
                index++;
                ccontrol += 'Affiliation #' + index + ': ' + (o.get('Affiliation_String__c') != null ? string.valueOf(o.get('Affiliation_String__c')) : string.valueOf(o.get('Affiliation_Display_Name__c'))) +'\n';
            }

            parentObject.put('Post_Approval_Change_Control__c', ccontrol);
            update parentObject;
        }
        
        PageReference pg = new PageReference('/'+recID);
        pg.setRedirect(true);
        return pg;       
    }
}