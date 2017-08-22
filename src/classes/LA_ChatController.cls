/************************************************
* 
*       Apex Class LA_ChatController
*       @Date: Dec 1, 2016
*       @Author Andrew Knapp (Magnet 360)
*       @JIRA: https://reside.jira.com/browse/
*
*       Usage:
*   
***********************************************/
global without sharing class LA_ChatController {
    

    @RemoteAction
    global static String getTopicPickValues(String fieldName) {
          String selectList = '';
          Schema.sObjectType sobject_type = Case.getSObjectType(); 
          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
          List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues(); 
          for (Schema.PicklistEntry a : pick_list_values) {   
              selectList = selectList + ';'+a.getValue();                 
                
          }
          return selectList;
    }        

}