public with sharing class ExportClass {
public String parentRecordId;
public String nameFile {get;set;}
public List<ChildObjToImp> ChildObjList { get; set; }
public Map<string,List<string>> fieldList_imp;
public Milestone1_Project__c imp{get; set;}
public Set<string> Impfieldlabel{get; set;}

public List<Schema.FieldSetMember> getClientoverviewFields() {
    return SObjectType.Milestone1_Project__c.FieldSets.ExportPDF.getFields();
}

public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
 
public string endfile{get; set;}
    public ExportClass(ApexPages.StandardController stdController) {
        parentRecordId = stdController.getRecord().Id;
        Milestone1_Project__c impPage = [select Account__r.Name,version_number__c from Milestone1_Project__c where id =: parentRecordId];
        boolean isblzzy = impPage.version_number__c == null || impPage.version_number__c == 0;
        nameFile = impPage.Account__r.Name.toUpperCase().replace(' ','_z')+'_ROF_'+string.valueOf(Date.today()).replace('-','')+'_V'+(isblzzy ? '1' : string.valueOf(impPage.version_number__c+1));
        endfile = '</Workbook>';
    }

    public Pagereference Export() {
        //Savepoint sp = Database.setSavepoint();
        ChildObjList = new List<ChildObjToImp>();
        string queryString_impl;
        Impfieldlabel = new set<string>();

        
        try { 
            List<string> impStandardField = new List<string>{'id'};
            String parentObjAPIName=CloneCtrl.returnAPIObjectName(parentRecordId);

             for(Schema.FieldSetMember fsmc: this.getClientoverviewFields()){
                impStandardField.add(fsmc.getfieldPath());
            }

            Set<string> ImpfieldSet = new Set<string>();
            for(string s: impStandardField){
                ImpfieldSet.add(s.toLowerCase());
            }

            List<string> ImpfieldList = new List<string>(ImpfieldSet);
            for (Integer i=0; i<ImpfieldList.size(); i++) {
                if(i == 0) {
                        queryString_impl = 'select ' + ImpfieldList[i];
                } else {
                        queryString_impl += ', ' + ImpfieldList[i];
                }
            }

            querystring_impl+=', version_number__c from Milestone1_Project__c where Id' +' = '+'\''+parentRecordId+'\'';

            imp = Database.Query(queryString_impl);

            system.debug('DO WE GET HERE ' + imp);

            //Getting all childs
            ChildFieldNameClass obj = CloneCtrl.getAllChildObjNames(parentObjAPIName,parentRecordId); 
            Map<String,String> objAPIobjlabel = obj.childFieldsName;
            Map<String,String> chidlObjAPIName_FieldAPIName  = obj.chidlObjAPIName_FieldAPIName;


            Map<string, string> querymap=new Map<string, string>();
            Map< string, List<Schema.FieldSetMember>> fsmmap = new Map<string, List<Schema.FieldSetMember>>();
            
            //custom logic for client_affiliation__c
            for(Export_Grandchildren__mdt grands : [select object_name__c, where_clause__c from Export_Grandchildren__mdt]){
                chidlObjAPIName_FieldAPIName.put(grands.object_name__c, grands.where_clause__c);
            }

            for(string str: chidlObjAPIName_FieldAPIName.Keyset()){

                //system.debug('OBJECT IS ' + str);

                List<string> impChildFieldList = new List<string>{};
                string queryString_imp = '';
                List<Schema.FieldSetMember> fsmlst=new List<Schema.FieldSetMember>();
                List<sobject> objlst=new List<sobject>();

                if(readFieldset('ExportPDF', str)!=Null){
                    fsmlst=readFieldset('ExportPDF', str).getfields();

                    //system.debug('FIELD SET MEMBERS ARE  ' + fsmlst);

                    if(!fsmmap.containsKey(str)){
                        fsmmap.put(str, new List<schema.Fieldsetmember>());
                    }

                    fsmmap.get(str).addall(fsmlst);

                    for(Schema.FieldSetMember fsm:fsmlst){
                        impChildFieldList.add(fsm.getfieldPath());
                    }
                        
                    // Add to set to de-dup field listing
                    Set<string> fieldSetImp = new Set<string>();
                    for(string s: impChildFieldList){
                        fieldSetImp.add(s.toLowerCase());
                    }

                    List<string> fieldList_imp2 = new List<string>(fieldSetImp);

                    for (Integer i=0; i<fieldList_imp2.size(); i++) {
                        if(i == 0) {
                                queryString_imp = 'select Id,' + fieldList_imp2[i];
                        } else {
                                queryString_imp += ', ' + fieldList_imp2[i];
                        }
                    }

                    queryString_imp+= ' from '+str+' where ';
                    queryString_imp+= chidlObjAPIName_FieldAPIName.get(str)+' = '+'\''+parentRecordId+'\'';

                    //system.debug('CHILD QUERY IS ' + queryString_imp);

                    if(!querymap.containskey(str)){
                        querymap.put(str, querystring_imp);
                    }
                }
            }
            
            //Querying on all sobjects
            Map<string, List<sobject>> mapobj= new Map<string, List<sobject>>();
            for(string str:querymap.keyset()){
                system.debug('QUERY IS ' + querymap.get(str));

                List<sobject> objlst=Database.Query(querymap.get(str));
                
                system.debug('QUERY RESULTS ARE ' + objlst);

                if(!objlst.isEmpty()){
                    if(!mapobj.containsKey(str)){
                        system.debug('PUTTING EXPORT TAB IN MAP FOR ' + str); 
                        mapobj.put(str, new List<sobject>());
                    }

                    mapobj.get(str).addall(objlst);
                }
            }

            system.debug('FINAL EXPORT MAP OBJECTS ARE ' + mapobj.keySet());

            //Assigning the values to wrapper class
            for(string sapi: mapobj.Keyset()){
                ChildObjList.add(new ChildObjToImp(CloneCtrl.returnObjectName(mapobj.get(sapi)[0].id), fsmmap.get(sapi), mapobj.get(sapi)));
            }

            system.debug('ChildObjList' +ChildObjList);

            imp.version_number__c = (imp.version_number__c == null || imp.version_number__c == 0) ? 1 : imp.version_number__c+1;
            update imp;

            PageReference pageRef = new PageReference('/'+imp.id);
            return null;


        }
        catch(Exception e){
            system.debug('error' +e.getLineNumber());
            return null;
        }   
    }

    public static Schema.FieldSet readFieldSet(String fieldSetName, String ObjectName)
    {
    Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
    Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
    return fieldSetObj; 
    }

    public class ChildObjToImp{
        public string objectlabel {get; set;}
        public List<Schema.FieldSetMember> Listfieldset  {get; set;}
        public List<sobject> lstobj{get; set;}
        
        public ChildObjToImp(string label, List<Schema.FieldSetMember> lstf, list<sobject> lstobjs){
            this.objectlabel = label;
            this.ListFieldset  = new List<Schema.FieldSetMember>();
            this.ListFieldset.addall(lstf);
            this.lstobj  = new List<sobject>();
            this.lstobj.addall(lstobjs);
            
        } 
    }

    /*public List<Schema.FieldSetMember> getImpFields() {
        return SObjectType.Milestone1_Project__c.FieldSets.ExportPDF.getFields();
    }*/
            
}