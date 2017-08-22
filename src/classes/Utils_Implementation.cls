public class Utils_Implementation {

     public static Map<String, String> getFieldInfoMap_existing(string objectName, List<String> fieldNames, Map<string,string> mappy){
        Map<string,string> tempMap = new Map<string,string>();

        system.debug('OBJECT NAME IN FILD INFO ' + objectName);
        system.debug('OBJECT MAP ' + mappy);

        for(Field_Info__c fi : [select id, name, info__c from Field_Info__c where object_api_name__c = :objectName]){
            system.debug('OBJECT INFO IN LOOP ' + fi.name + ' - ' + fi.Info__c);
            string descrip = fi.Info__c != null ? fi.Info__c : 'N/A';
            tempMap.put(fi.name, descrip);
        }

        for(string mapp : mappy.keySet()){
            if(!tempMap.containsKey(mapp))
                tempMap.put(mapp,mappy.get(mapp));
        }

        for(string fieldName : fieldNames){
            if(!tempMap.containsKey(fieldName))
                tempMap.put(fieldName,'N/A');
        }

        return tempMap;
    }

    public static Map<String, String> getFieldInfoMap(string objectName, List<String> fieldNames){
        Map<string,string> tempMap = new Map<string,string>();

        system.debug('OBJECT NAME IN FILD INFO ' + objectName);
        for(Field_Info__c fi : [select id, name, info__c from Field_Info__c where object_api_name__c = :objectName]){
            system.debug('OBJECT INFO IN LOOP ' + fi.name + ' - ' + fi.Info__c);
            string descrip = fi.Info__c != null ? fi.Info__c : 'N/A';
            tempMap.put(fi.name, descrip);
        }

        for(string fieldName : fieldNames){
            if(!tempMap.containsKey(fieldName))
                tempMap.put(fieldName,'N/A');
        }

        return tempMap;
    }

    public static Map<String, String> getFieldHeaderMap_existing(string objectName, List<String> fieldNames, Map<string,string> mappy){
        system.debug('FIELDNAMES ARE ' + fieldNames);
        system.debug('MAP IS ' + mappy);
        Map<string,string> tempMap = new Map<string,string>();

        for(Field_Info__c fi : [select id, name, header__c from Field_Info__c where object_api_name__c = :objectName]){
            string header = fi.header__c != null ? fi.header__c : 'N/A';
            tempMap.put(fi.name, header);
        }

        for(string fieldName : fieldNames){
            if(!tempMap.containsKey(fieldName))
                tempMap.put(fieldName,'N/A');
        }

        for(string mapp : mappy.keySet()){
            if(!tempMap.containsKey(mapp))
                tempMap.put(mapp,mappy.get(mapp));
        }
        
        return tempMap;
    }

    public static Map<String, String> getHeaderMap(string objectName, List<String> fieldNames){
        system.debug('FIELDNAMES ARE ' + fieldNames);
        Map<string,string> tempMap = new Map<string,string>();

        for(Field_Info__c fi : [select id, name, header__c from Field_Info__c where object_api_name__c = :objectName]){
            string header = fi.header__c != null ? fi.header__c : 'N/A';
            tempMap.put(fi.name, header);
        }

        for(string fieldName : fieldNames){
            if(!tempMap.containsKey(fieldName))
                tempMap.put(fieldName,'N/A');
        }

        return tempMap;
    }

  public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName().toLowerCase();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }

     public static Map<String, String> getFieldInfoMap_ROF(string objectName, List<String> fieldNames, Map<String, string> mappy){
        Map<string,string> tempMap = new Map<string,string>();

        system.debug('OBJECT NAME IN FILD INFO ' + objectName);
        for(Field_Info__c fi : [select id, name, info__c from Field_Info__c where object_api_name__c = :objectName]){
            if(!mappy.containsKey(fi.name)){
            system.debug('OBJECT INFO IN LOOP ' + fi.name + ' - ' + fi.Info__c);
            string descrip = fi.Info__c != null ? fi.Info__c : 'N/A';
            tempMap.put(fi.name, descrip);
            }
        }

        for(string fieldName : fieldNames){
            if(!tempMap.containsKey(fieldName)&& !mappy.containsKey(fieldname))
                tempMap.put(fieldName,'N/A');
        }

        return tempMap;
    }

  
  public static Schema.sObjectType getsObjectType(string objectName){
    Schema.sObjectType oType;
    Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
    
    for(String s : gd.keySet()){
      if(s == objectName){
        oType = gd.get(s);
      }
    }
    return oType;
  }

    public static Map<String, List<String>> catalogQuestions(){
        Map<String, List<String>> mappy = new Map<String, List<String>>();

        for(Catalog_Question__mdt q : [select id, question__c, answers__c from Catalog_Question__mdt where active__c = true]){  
           
            system.debug('ANSWER IS ' + q.Answers__c);

            if(q.answers__c != null && q.answers__c.contains(',')){
                List<String> tempList = q.answers__c.split(',');  
                mappy.put(q.question__c,tempList);
            }
        }

        return mappy;
    }

    public static void createNewRecords(Map<string,string> valuesMap, Map<String,String> joinMap, List<string> objIDs, Map<string,string> objNameMap, Map<string,string> parentMap){
        
        //ONLY TO BE CALLED ON ONE IMPLEMENTATION OBJECT AT A TIME!!!
        List<sObject> newObjects = new List<sObject>();
        Map<String, List<String>> mappy = new Map<String, List<String>>();
        Set<string> setCheck = new Set<String>();

        for(string joinCheck : joinMap.values()){
            if(setCheck.isEmpty() || setCheck.contains(joinCheck))
                setCheck.add(joinCheck);
        }

        system.debug('CHECKING IMPLEMENTATION SIZE ' + setCheck);
        
        if(setCheck.size() == 1){
            for(string s : valuesMap.keySet()){
                string[] keyss = valuesMap.get(s).split(';');
                string objectName = objNameMap.get(s);

                system.debug('RECORD ID IS ' + s);
                system.debug('IMP ID IS ' + joinmap.get(s));
                system.debug('Records for Insert are ' + keyss);
                system.debug('TYPE OF OBJECT IS ' + objectName);

                for(string s2 : keyss){
                    sObject newObject = Schema.getGlobalDescribe().get(objectName).newSObject();
                    
                    system.debug('NEW OBJECT IS ' + newObject);

                    newObject.put('implementation__c', joinmap.get(s));
                    newObject.put('name',s2);
                    newObject.put('Referring_Object_ID__c',s);
                    newObjects.add(newObject);
                    
                    system.debug('NewObjects are ' + newObjects);

                }
            }

            if(!newObjects.isEmpty()){
                insert newObjects;
            }
        }
    }

    public static void createNewRecords2(Map<string,string> valuesMap, Map<String,String> joinMap, List<string> objIDs, Map<string,string> objNameMap, Map<string,string> parentMap){
        
        //ONLY TO BE CALLED ON ONE IMPLEMENTATION OBJECT AT A TIME!!!
        List<sObject> newObjects = new List<sObject>();
        Map<String, List<String>> mappy = new Map<String, List<String>>();
        Set<string> setCheck = new Set<String>();

        for(string joinCheck : joinMap.values()){
            if(setCheck.isEmpty() || setCheck.contains(joinCheck))
                setCheck.add(joinCheck);
        }

        system.debug('CHECKING IMPLEMENTATION SIZE ' + setCheck);
        
        if(setCheck.size() == 1){
            for(string s : valuesMap.keySet()){
                string[] keyss = valuesMap.get(s).split(';');
                string objectName = objNameMap.get(valuesMap.get(s));

                system.debug('RECORD ID IS ' + s);
                system.debug('IMP ID IS ' + joinmap.get(s));
                system.debug('Records for Insert are ' + keyss);
                system.debug('TYPE OF OBJECT IS ' + objectName);

                for(string s2 : keyss){
                    sObject newObject = Schema.getGlobalDescribe().get(objectName).newSObject();
                    
                    system.debug('NEW OBJECT IS ' + newObject);

                    newObject.put('implementation__c', joinmap.get(s));
                    newObject.put('name',s2);
                    newObject.put('Referring_Object_ID__c',s);
                    newObjects.add(newObject);
                    
                    system.debug('NewObjects are ' + newObjects);

                }
            }

            if(!newObjects.isEmpty()){
                insert newObjects;
            }
        }
    }

    @future
    public static void deleteObjects(List<String> objIds){

        //Only to be called for one list of objects at a time
        List<sObject> delObjs = new List<sObject>();
        Map<string, string> objMap = new Map<string, string>();

        string objectName = Utils_Implementation.findObjectNameFromRecordIdPrefix(objIds[0]);

        for(String s : objIds){
            sObject sobj = Schema.getGlobalDescribe().get(objectName).newSObject();
            sobj.put('ID', s);
            delObjs.add(sobj);
        }

        if(!delObjs.isEmpty())
            delete delObjs;
    }

    public static Rally_Order_Form_FS_Mapping__mdt[] findFormfromID(string formID){
       List<Rally_Order_Form_FS_Mapping__mdt> templist = [select record_type_id__c,
                                                                  DeveloperName,
                                                                  Page_Title__c,
                                                                  Header_Name__c,
                                                                  Number_Of_Affiliations__c,
                                                                  Form_ID__c,
                                                                  Show_Continue_Link__c,
                                                                  Show_Comments__c
                                                                  FROM Rally_Order_Form_FS_Mapping__mdt
                                                                  WHERE Form_ID__c LIKE : formID];
        return templist;
    }

}