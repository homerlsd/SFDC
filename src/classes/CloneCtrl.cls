global class CloneCtrl {
    //Return the object API name for a given record
    global static String returnAPIObjectName (string myRecordID){
        String objectName = '';
        
        String prefix = myRecordID.substring(0,3);
    
        Map<String, Schema.SObjectType> gd = Schema.getglobalDescribe();

        for(SObjectType s :gd.values()) {
            DescribeSObjectResult r = s.getDescribe();     
            if(r.getKeyPrefix()!=null) {
                if(r.getLocalName()!=null && r.getKeyPrefix().equals(prefix)) {
                    objectName=r.getLocalName();
                    break;
                } 
             }
        }        
        return objectName;
    }

    global static String returnObjectName (string myRecordID){
        String objectName = '';
        
        String prefix = myRecordID.substring(0,3);
    
        Map<String, Schema.SObjectType> gd = Schema.getglobalDescribe();

        for(SObjectType s :gd.values()) {
            DescribeSObjectResult r = s.getDescribe();     
            if(r.getKeyPrefix()!=null) {
                if(r.getLocalName()!=null && r.getKeyPrefix().equals(prefix)) {
                    objectName=r.getLabel();
                    break;
                } 
             }
        }        
        return objectName;
    }
    
    //Get all creatable fields for a given object
    global static list<String> getCreatableFields(String objAPIName){
        Map<string,string> childFieldsName = new Map<string,string>{};
        
        Map<String, Schema.SObjectType> gd = Schema.getglobalDescribe();
        SObjectType sot = gd.get(objAPIName);
      
        //Get all non-creatable fields name except
        //Get the field tokens map
        Map<String, SObjectField> fields = new Map<String, SObjectField>{};
        if(sot.getDescribe().fields.getMap().keyset().size()>0)
            fields = sot.getDescribe().fields.getMap();
        
        //And drop those tokens in a List
        List<SObjectField> fieldtokens = fields.values();
        
        List<string> objectFields = new List<String>();
        
        for(SObjectField fieldtoken:fieldtokens) {
            DescribeFieldResult dfr = fieldtoken.getDescribe();
            
            //remove date and date time from cloned records
            //if(dfr.isCreateable() ){
            if(dfr.isCreateable() && string.valueOf(dfr.getType()) != 'Date'){
                objectFields.add(dfr.getLocalName());    
            }
                                 
        }
        
        return objectFields;
    }
    
    //Get all child object API names for a given parent object API name
    //return Map<object label,object local name>,
    global static ChildFieldNameClass getAllChildObjNames(String parentObj,String parentRecordID) { 
        Map<String,String> chidlObjAPIName_FieldAPIName = new Map<String,String>{};       
        Map<string,string> childFieldsName = new Map<string,string>{};        
        Map<String, Schema.SObjectType> gd = Schema.getglobalDescribe();
        SObjectType sot = gd.get(ParentObj);
       
        //Get all child fields
        Schema.DescribeSObjectResult fieldResult2 = sot.getDescribe();
        List<Schema.ChildRelationship> children = fieldResult2.getChildRelationships();

        //Get all Do Not Clone (DNC) Objects for filtering
        Set<String> dncs = new Set<String>();
        for(Do_Not_Clone_Object__mdt dnc : [select id, label from Do_Not_Clone_Object__mdt]){
            dncs.add(dnc.label);
        }

        for(Schema.ChildRelationship child:children) {
            //Exclude following objects
            if(child.getChildSObject().getDescribe().getLocalName() <> 'ProcessInstance' 
            && child.getChildSObject().getDescribe().getLocalName() <> 'ProcessInstanceHistory' 
            && child.getChildSObject().getDescribe().getLocalName() <> 'ContentVersion'
            && child.getChildSObject().getDescribe().getLocalName() <> 'ContentDocument'   
            && child.getChildSObject().getDescribe().getLocalName() <> 'ContentDocumentLink'   
            && child.getChildSObject().getDescribe().getLocalName() <> 'Note'   
            && child.getChildSObject().getDescribe().getLocalName() <> 'ActivityHistory'
            && child.getChildSObject().getDescribe().getLocalName() <> 'OpenActivity'
            && child.getChildSObject().getDescribe().getLocalName() <> 'Event'
            && child.getChildSObject().getDescribe().getLocalName() <> 'Task'
            && child.getChildSObject().getDescribe().getLocalName() <> 'User'
            && child.getChildSObject().getDescribe().getLocalName() <> 'FeedComment'
            && child.getChildSObject().getDescribe().getLocalName() <> 'FeedPost'
            && child.getChildSObject().getDescribe().getLocalName() <> 'EntitySubscription'
            && child.getChildSObject().getDescribe().getLocalName() <> 'NoteAndAttachment'
            && child.getChildSObject().getDescribe().getLocalName() <> 'UserRole'
            && child.getChildSObject().getDescribe().getLocalName() <> 'Partner'
            && child.getChildSObject().getDescribe().getLocalName() <> 'CampaignMemberStatus'
        
            //Do not take parent record which is the same object
            && child.getChildSObject().getDescribe().getLocalName() <> returnAPIObjectName(parentRecordID)

            //exclude obj created for sharing purpose
            && child.getChildSObject().getDescribe().getLocalName() <> returnAPIObjectName(parentRecordID) + 'share'
            && child.getChildSObject().getDescribe().getLocalName().endsWith('__Share')==false

            && !dncs.contains(child.getChildSObject().getDescribe().getLocalName())
            //has to be creatable
            && child.getChildSObject().getDescribe().isCreateable() == true) {
                string a=string.valueof(child.getChildSObject().getdescribe().getLocalName());
                string b=string.valueof(child.getField());
                chidlObjAPIName_FieldAPIName.put(string.valueof(child.getChildSObject().getdescribe().getLocalName()), string.valueof(child.getField()));
                childFieldsName.put(child.getChildSObject().getDescribe().getLabel(), child.getChildSObject().getDescribe().getLocalName());
            }
        }

        return new ChildFieldNameClass(chidlObjAPIName_FieldAPIName,childFieldsName);
    }
    
    //Clone parent record and return new parent record ID
    global static String cloneParentRecord(String objAPIName, List<String> createableFields,string parentRecordID) {
        String fields = '';
        for(string s:createableFields) {
            //Remove all contact mirror fields from person account
            if(s.contains('__pc') == false)
                fields = fields + s + ',';          
        }
        fields = fields.substring(0, fields.lastIndexOf(','));

        String queryString = 'select ' + String.escapeSingleQuotes(fields) + ' from ' + String.escapeSingleQuotes(objAPIName) + ' where id=\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
        SObject result = Database.query(queryString);       
        Sobject copy = result.clone(false, true);
        string dupe ='dupe';
        if(copy.getsobjectType() == Schema.Knowledge_Group__c.getsobjectType()){
        copy.put('Group_Name__c', copy.get('Group_Name__c')+dupe);
        copy.put('Apply_Defaults__c', False);
        }
        insert copy;
        return copy.id ;
    }
    
    
    
    //Clone all child records
    global static List<OldNewId> cloneChildRecords(Map<String,String> chidlObjAPIName_FieldAPIName ,String objAPIName, list<String> createableFields, String parentObjAPIName, string newParentRecordID, string parentRecordID){
        List<OldNewId> recIdNewIdObj = new List<OldNewId>();
        String fields = '';

        system.debug('objAPIName' +objAPIName);
        Set<String> filteredLookupObjects = Utils.getfilteredLookupObjects();

        if(objAPIName != 'Knowledge_Group__c'){
            Set<String> filteredLookups = Utils.getFilteredLookups(objAPIName);
            Set<String> filteredObjects = Utils.getFilteredObjects();
            Set<String> dncfields = Utils.getDNCFields(objAPIName);
            
            //system.debug('filteredLookups' +filteredLookups);
            //system.debug('FilteredObjects' +filteredObjects);

            for(string s:createableFields)
                fields = fields + s + ',';

            //system.debug('FIELDS ARE ' + fields);
            
            fields=fields.substring(0, fields.lastIndexOf(','));
            
            //system.debug('FIELDS ARE AFTER SUBSTRING ' + fields);

            String queryString;

            //system.debug('SELECT FIELDS' +String.escapeSingleQuotes(fields));
            //system.debug('WHERE FIELD ' +String.escapeSingleQuotes(chidlObjAPIName_FieldAPIName.get(objAPIName)));
            
            queryString = 'select ' + String.escapeSingleQuotes(fields) + ' from ' + String.escapeSingleQuotes(objAPIName) + ' where ' + String.escapeSingleQuotes(chidlObjAPIName_FieldAPIName.get(objAPIName)) + '=\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
            
            if(objAPIName == 'Group_Article__c')
                querystring+='AND Active__c = true order by Active__c Desc';

            //system.debug('FINAL QUERY STRING ' + querystring);
          
            list<SObject> result = Database.query(queryString);
            system.debug('result from batch' +result);         
            list<SObject> copy = result.deepclone(true);
            system.debug('copy from Batch' +copy); 
            
            Integer i = -1;

            for(SObject obj :copy) {
                i++;
                
                if(objAPIName.substring(objAPIName.length()-3,objAPIName.length()) == '__c')
                    obj.put('Cloned_Record_ID__c', obj.id);
                
                obj.put('id', null);
              
                for(string s : dncfields){
                    try{
                        if(obj.get(s) != null){
                            obj.put(s,NULL);
                        }
                    }
                    catch(exception ex){
                        continue;
                    }
                }
                //LOGIC WITH FILTERED LOOKUPS
                for(string s : filteredLookups){
                    
                    //system.debug('VALUE OF FILTERED LOOKUP IS ' + obj.get(s));
                    string tempy = s.replace('__c','ex__c');

                    if(obj.get(s) != null){
                        obj.put(tempy,string.valueOf(obj.get(s)));

                        obj.put(s,NULL);

                        //system.debug('DO WE NULL OUT THE LOOKUP ' + obj.get(s));
                    }
                }

                if(filteredObjects.contains(objAPIName)){
                    string temp2 = objAPIName.replace('__c','ex__c');
                    obj.put(temp2, string.valueOf(result[i].get('id')));
                }

                obj.put(chidlObjAPIName_FieldAPIName.get(objAPIName), newParentRecordID);
    
            }

            insert copy;
            
            system.debug('copy from batch2' +copy);

            if(objAPIName.substring(objAPIName.length()-3,objAPIName.length()) == '__c'){
                for(SObject obj : copy){
                    recIdNewIdObj.add( new OldNewId(string.valueOf(obj.get('Cloned_Record_ID__c')), string.valueOf(obj.get('id'))));
                }

                return recIdNewIdObj;
            }
        }

        return recIdNewIdObj;
    }
    
    global static Map<String, list<String>> getChildObjWithCreateableField(String parentRecordID,List<String> childObjAPINames,Map<String,String> chidlObjAPIName_FieldAPIName) {
        string fieldsNames=''; 

        
        //Loop through all child object names
        for(string objAPIName: childObjAPINames) {
            //if(objAPIName == 'Group_Article__c'){
            //Check if current child object has records linked with the parent record            
            //Handle Note and Attachement in different way as they use "ParentID" in the query
            if(objAPIName != 'FeedItem' && objAPIName != 'Group_Article__c') {
                if(objAPIName == 'Note' || objAPIName == 'Attachment') {
                    String queryString = 'select count(Id) total from ' + String.escapeSingleQuotes(objAPIName) + ' where ParentId =\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
                    SObject result = Database.query(queryString); 
    
                    //Find note and attachment records, add note & attachment into the list
                    if((Integer)result.get('total') > 0)
                        fieldsNames = fieldsNames + objAPIName + ',';
                }
                else {
                    //if(objAPIName == 'Group_Article__c'){
                    String queryString = 'select count(Id) total from ' + String.escapeSingleQuotes(objAPIName) + ' where ' + String.escapeSingleQuotes(chidlObjAPIName_FieldAPIName.get(objAPIName)) + '=\'' + String.escapeSingleQuotes(parentRecordID) + '\'';
                    system.debug('Query String : '+queryString);
                    
                    SObject result = Database.query(queryString);      

                    system.debug('RESULT OF ' + String.escapeSingleQuotes(objAPIName) + ' QUERY IS: ' + result);             
    
                    //Find child object records linked with the parent record, add the child object API name into the list
                    if((Integer)result.get('total') > 0)
                        fieldsNames = fieldsNames + objAPIName + ',';   
                    //}
                }
            }
            //}
        }    
        
        //Create Child Object API Name and creatable fields map
        Map<String, list<String>> objFields = New Map<String, list<String>>{};
        if(fieldsNames.length()>0) {
            //getCreatableFields(objAPIName) returns all creatable fields name for a given child obj API name        
            for(String objAPIName:fieldsNames.split(','))
                objFields.put(objAPIName,getCreatableFields(objAPIName));
            
        }
        return objFields;
    }
}