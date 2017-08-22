public class DeepCloneCtrl {
    public String parentRecordId;
    public DeepCloneCtrl(ApexPages.StandardController stdController) {
        parentRecordId = stdController.getRecord().Id;
        system.debug('Record Id :'+parentRecordId);
    }
    
    public Pagereference deepClone() {
        Savepoint sp = Database.setSavepoint();
        try { 
            String parentObjAPIName=CloneCtrl.returnAPIObjectName(parentRecordId);
            system.debug('parentObjAPIName' +parentObjAPIName);
            List<String> createableFields = CloneCtrl.getCreatableFields(parentObjAPIName);
            system.debug('createableFields' +createableFields);
            string clondedParentRecordID=CloneCtrl.cloneParentRecord(parentObjAPIName,createableFields,parentRecordId);
            system.debug('clondedParentRecordID' +clondedParentRecordID);
            //Clone Child Record
            List<OldNewId> batchProcessData = new List<OldNewId>();
            ChildFieldNameClass obj = CloneCtrl.getAllChildObjNames(parentObjAPIName,parentRecordId); 
            system.debug('ChildFieldNameClass' +obj);
            Map<String,String> objLabelobjAPI = obj.childFieldsName;
            system.debug('objLabelobjAPI' +objLabelobjAPI);
            Map<String,String> chidlObjAPIName_FieldAPIName  = obj.chidlObjAPIName_FieldAPIName;
            system.debug('chidlObjAPIName_FieldAPIName' +chidlObjAPIName_FieldAPIName);
            Map<String, list<String>> objFields = CloneCtrl.getChildObjWithCreateableField(parentRecordId,objLabelobjAPI.values(),chidlObjAPIName_FieldAPIName);
            system.debug('objFields' +objFields);


            for(String childObjAPIName:objFields.keySet()) {
                //system.debug('CHILD OBJECT BEING CLONED IS ' + childObjAPIName);
                if(childObjAPIName != 'Knowledge_Group__c')
                    batchProcessData.addAll(CloneCtrl.cloneChildRecords(chidlObjAPIName_FieldAPIName,childObjAPIName,CloneCtrl.getCreatableFields(childObjAPIName),parentObjAPIName,clondedParentRecordID,parentRecordId));
            }
            // call batch class
            AddInnerChildBatch bc= new AddInnerChildBatch();
            bc.recIdNewIdObj = batchProcessData;
            Database.executeBatch(bc, 1);
            
            system.debug('batchprocessdata : '+batchProcessData);
            return new Pagereference('/'+clondedParentRecordID);
        } catch(Exception e) {
            system.debug(e.getLineNumber());
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
    }
}