@isTest
public class LA_ChatControllerTest {

    public static testMethod void testOne() {
        String testField = 'Issue_Bug__c';
        PageReference pageRef = Page.LA_PreChatForm;
        Test.setCurrentPage(pageRef);
           
          String selectList = '';
          Schema.sObjectType sobject_type = Case.getSObjectType(); 
          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
          List<Schema.PicklistEntry> pick_list_values = field_map.get(testField).getDescribe().getPickListValues(); 
          for (Schema.PicklistEntry a : pick_list_values) {   
              selectList = selectList + ';'+a.getValue();                 
                
          }   
   
        LA_ChatController controller = new LA_ChatController();

        Test.startTest();
        String pkVals = LA_ChatController.getTopicPickValues(testField) ;
        Test.stopTest();
 
        System.assertEquals(selectList,pkVals);
    }
}