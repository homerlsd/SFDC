public class RequirementFormController {
    
    public string impID                                                     {get;set;}
    public string recPrefix                                                 {get;set;}
    public string objName                                                   {get;set;}
    public string fieldsetName                                              {get;set;}
    public string rtype                                                     {get;set;}
    public string fielddescription                                          {get;set;}
    public string header                                                    {get;set;}
    public string pageTitle                                                 {get;set;}
    public string rtName                                                    {get;set;}
    public string rewardType                                                {get;set;}
    public string entryType                                                 {get;set;}
    public string entryMethod                                               {get;set;}
    
    public boolean hasAffils                                                {get;set;}
    public boolean hasRtypes                                                {get;set;}
    public boolean showSuccess                                              {get;set;}
    public boolean hideFieldInfo                                            {get;set;}

    public sObject newObject                                                {get;set;}

    public List<selectOption> allAffiliations                               {get;set;}
    public List<selectOption> selectedAffiliation                           {get;set;}
    public List<sObject> childObjs                                          {get;set;}
    public List<Schema.FieldSetMember> objFields                            {get;set;}
    public List<Schema.FieldSetMember> rewardFields2                        {get;set;}
    public List<Schema.FieldSetMember> rewardFields3                        {get;set;}
    public List<Schema.FieldSetMember> rewardFields4                        {get;set;}

    public Map<id, id> affilMap                                             {get;set;}
    public Map<string, string> descriptionMap                               {get;set;}
    public Map<string, string> headermap                                    {get;set;}
    public Map<string, Integer> lengthMap                                   {get;set;}

    public Attachment att                                                   {get;set;}

    public List<String> fieldNames                                          {get;set;}

    public integer fieldCount                                               {get;set;}
    public Milestone1_Project__c imp                                        {get;set;}

    public RequirementFormController() {
        impID = Apexpages.currentPage().getParameters().get('impID');
        recPrefix = Apexpages.currentPage().getParameters().get('recPrefix');
        rtype = Apexpages.currentPage().getParameters().get('rtype');

        showSuccess = false;
        hasAffils = false;
        hasRtypes = false;
        hideFieldInfo = false;

        fielddescription = '';
        header = '';
        
        rewardType = '';
        entrytype = '';
        entryMethod = '';

        fieldCount = 0;

        fieldNames = new List<string>();
        
        selectedAffiliation = new List<SelectOption>();
        allAffiliations = new List<SelectOption>();
        affilMap = new Map<id, id>();

        objFields = new List<Schema.Fieldsetmember>();
        rewardFields2 = new List<Schema.Fieldsetmember>();
        rewardFields3 = new List<Schema.Fieldsetmember>();
        rewardFields4 = new List<Schema.Fieldsetmember>();

        att = new Attachment();

        try{
            imp = [select id, OwnerId, Partner__c from Milestone1_Project__c where ID = :impID];
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.RequirementForm_BadFormID));
            return;
        }
        
        objName = Utils_Implementation.findObjectNameFromRecordIdPrefix(recPrefix);

        system.debug('object name ' + objName);
        system.debug('Partner ID  ' + imp.Partner__c);
        system.debug('Partner Label ' + Label.ManageAffiliations_BCBSPartnerID);

        if(objName == 'post_launch_change__c' && string.valueOf(imp.Partner__c).contains(Label.ManageAffiliations_BCBSPartnerID)){
            hideFieldInfo = true;
        }

        External_Field_Set_Map__c f = External_Field_Set_Map__c.getInstance(objName);  
        fieldsetName = f.Field_Set_Name__c;

        system.debug('FIELD SET NAME IS ' + fieldSetName);
        pageTitle = 'Rally ';

        if(f.Object_Label__c != null)
            pageTitle += f.Object_Label__c+' ';
        
        rtName = '';

        if(rtype != null && rtype != ''){
            recordType[] rt = [select id, name from RecordType where ID =:rtype];
            if(rt != null){
                pageTitle += rt[0].Name+' ';
                rtName = rt[0].name.remove(' ');
                system.debug('RT NAME REMOVED SPACES ' + rtName); 
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.RequirementForm_BadFormID));
                return;
            }
        } 

        pageTitle += 'Order Form';

        if(fieldsetName != null){

            if(rtName != ''){
                fieldSetName = fieldSetName+'_'+rtName;
            }

            string labelName = fieldsetName+'_header';

            system.debug('FIELD SET FINAL NAME IS ' + fieldSetName);
            system.debug('LABEL FINAL NAME IS ' + labelName);

            if(!test.isRunningTest()){
                Component.Apex.OutputText output;
                output = new Component.Apex.OutputText();
                output.expressions.value = '{!$Label.' + labelName + '}';
                header = string.valueOf(output.value);
            }
        }
            
        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 

        Schema.SObjectType sobjType = gd.get(objName); 

        newObject = Schema.getGlobalDescribe().get(objName).newSObject();

        Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 

        List<Schema.ChildRelationship> Childs = describeResult.getChildRelationships(); 

        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();

        Map<String, Schema.RecordTypeInfo> TypeInfoMap = describeResult.getRecordTypeInfosByName();

        if(!TypeInfoMap.isEmpty() && TypeInfoMap.size() > 1){
            hasRtypes = true;
            if(rtype != null){
                newObject.put('RecordTypeID',rtype);
            }
        }

        Set<String> childStrings = new Set<String>();
        
        for(Schema.ChildRelationship Child : childs){
            childStrings.add(child.getRelationshipname());
        }
        
        if(!childStrings.isEmpty() && childStrings.contains('Affiliation_Joins__r')){
            hasAffils = true;
            for (Client_Affiliation__c seg : [select id, name from Client_Affiliation__c where Implementation__c = :impID AND Affiliation_type__c = 'Production']) {
                if(seg.name != null && seg.name != '')
                    allAffiliations.add(new SelectOption(seg.id,seg.name));
            }
        }

        findObjfields();
    }

    public void findObjfields() {
        
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);

        lengthMap = new Map<string,integer>();

        for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
            fieldNames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }
        objFields.addAll(fieldSetObj.getFields()); 
        findFieldDescription();

    }

    public void findFieldDescription(){

        try{
            string removeMe = objName+'.';
            descriptionMap = new Map<String, String>();
            headerMap = new Map<String, String>();

            descriptionMap = Utils_Implementation.getFieldInfoMap(objName,fieldNames);
            headerMap = Utils_Implementation.getHeaderMap(objName,fieldNames);
            /*MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();

            system.debug('SESSION ID IS ' + UserInfo.getSessionId());

            MetadataService.CustomObject customObject = (MetadataService.CustomObject) service.readMetadata('CustomObject', new String[] { objName }).getRecords()[0];
            
            system.debug('METADATA FIELDS ARE ' + customObject.fields);

            for(MetadataService.CustomField field : customObject.fields)
            {
                string tempName = field.fullname.remove(removeMe);
                system.debug('TEMP NAME IS ' + tempName);
                string descrip = field.description != null ? field.description : 'N/A';
                descriptionMap.put(tempName, descrip);
            }*/

            system.debug('DESC MAP IS ' + descriptionMap);
            system.debug('HEADER MAP IS ' + headerMap);
            system.debug('LENGTH MAP IS ' + lengthMap);
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return;
        }
        
    }

    public void setRewardType(){
        if(!rewardFields2.isEmpty())
            rewardFields2.clear();
        if(rewardFields3.isEmpty())
            rewardFields3.clear();
        if(rewardFields4.isEmpty())
            rewardFields4.clear();

        rewardType=string.valueOf(newObject.get('Reward_Type__c'));
        system.debug('REWARD TYPE IS ' + rewardType);
        String tempFieldSet = fieldSetName+'_'+rewardType.remove(' ');
        system.debug('2nd Field set name is ' + tempFieldSet);

        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(tempFieldSet);

        for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
            fieldNames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }

        descriptionMap = Utils_Implementation.getFieldInfoMap(objName,fieldNames);
        headerMap = Utils_Implementation.getHeaderMap(objName,fieldNames);

        rewardFields2.addAll(fieldSetObj.getFields());
    }

    public void setEntryMethod(){

        if(rewardFields3.isEmpty())
            rewardFields3.clear();
        if(rewardFields4.isEmpty())
            rewardFields4.clear();
            
        entryMethod=string.valueOf(newObject.get('Reward_Entry_Method__c'));
        
        system.debug('REWARD ENTRY METHOD IS ' + entryMethod);

        String tempFieldSet = fieldSetName+'_'+entryMethod.remove(' ');

        system.debug('3rd FIELD SET NAME IS ' + tempFieldSet);
        
        if(tempFieldSet != ''){
            Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(tempFieldSet);

            for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
                fieldNames.add(fsm.getFieldPath());
                Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
                lengthMap.put(fsm.getFieldPath(),TestField.getLength());
            }

            descriptionMap = Utils_Implementation.getFieldInfoMap(objName,fieldNames);
            headerMap = Utils_Implementation.getHeaderMap(objName,fieldNames);

            rewardFields3.addAll(fieldSetObj.getFields());
        }
    }

    public void setEntryType(){
        if(!rewardFields4.isEmpty())
            rewardFields4.clear();

        entryType=string.valueOf(newObject.get('Reward_Entry_Type__c'));
        string entryActivity=string.valueOf(newObject.get('Reward_Entry_Activity__c'));

        system.debug('REWARD ENTRY Type IS ' + entrytype);
        system.debug('REWARD ENTRY Activity IS ' + entryActivity);

        String tempFieldSet = '';

        if(entryMethod==Label.RequirementForm_RewardEntryMethod_Coins){
            if(entrytype != null){
                tempFieldSet = entryMethod.remove(' ')+'_'+entryType.remove(' ');
            }
        }
        else{
            if(entryActivity != null && newObject.get('Activity_Type__c') != null){
                string activityType = string.valueOf(newObject.get('Activity_Type__c'));

                tempFieldSet = entryActivity.remove(' ')+'_'+activityType.remove(' ');
                
                if(tempFieldSet.length() > 40)
                    tempFieldSet = tempFieldSet.substring(0,40);
            }
        }

        system.debug('3rd FIELD SET NAME IS ' + tempFieldSet);
        
        if(tempFieldSet != ''){
            Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(tempFieldSet);

            for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
                fieldNames.add(fsm.getFieldPath());
                Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
                lengthMap.put(fsm.getFieldPath(),TestField.getLength());
            }

            descriptionMap = Utils_Implementation.getFieldInfoMap(objName,fieldNames);
            headerMap = Utils_Implementation.getHeaderMap(objName,fieldNames);

            rewardFields4.addAll(fieldSetObj.getFields());
        }
    }

    public void submitResults(){

        try{
            system.debug('DO WE GET INTO SUBMIT ' + objfields);

            for(schema.fieldsetmember fm : objfields){
                string tempField = fm.getFieldPath();
                if(tempField.contains('DateString__c')){
                    system.debug('DATE VALUE IS ' + String.valueOf(newObject.get(tempField)));
                    string dt = String.valueOf(newObject.get(tempField));
                    if(dt != null && dt != ''){
                        String[] str = dt.split('/');
                        date dtTemp = date.newInstance(integer.valueOf(str[2]),integer.valueOf(str[0]),integer.valueOf(str[1]));
                        string dateFieldPath = tempField.remove('String__c');
                        dateFieldPath = dateFieldPath + '__c';
                        try {
                            newObject.put(dateFieldPath,dtTemp);
                        } catch (Exception ex) {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error saving record - please remove and email jon.wu@rallyhealth.com with the following message:' + ex.getMessage()));
                            return;
                        }
                    }
                }
            }
            
            newObject.put('Implementation__c', impID);

            try{
                insert newObject;
            }
            catch(exception ex){
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0) );
                ApexPages.addMessage(msg);
                return ;
            }

            system.debug('ATTACHMENT BODY ' + att.body);

            //insert an attachment
            if(att.body != null){
                att.OwnerId = imp.OwnerId;
                att.ParentId = newObject.id; 

                try {
                   //if(!Test.isRunningTest()) {
                     insert att;
                  //}
                } catch (DMLException de) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment - please remove and email kate.tompkins@rallyhealth.com the client logo.'));
                    return;
                } finally {
                    att = new Attachment();
                }
            }

            if(hasAffils && !selectedAffiliation.isEmpty()){
                childObjs = new List<sObject>();
    
                for ( SelectOption so : selectedAffiliation ) {
                    Sobject o = Utils_Implementation.getsObjectType('Affiliation_Join__c').newSObject();
                    o.put('Client_Affiliation__c', so.getValue());
                    o.put(ObjName, newObject.id);
                    childObjs.add(o);
                }

                if(!childObjs.isEmpty()){
                    insert childObjs;
                }
            }


            showSuccess = true;

        }
        catch(exception ex){
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getmessage());
            ApexPages.addMessage(msg);
            return ;
        }
    }
}