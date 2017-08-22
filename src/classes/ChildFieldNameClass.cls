global class ChildFieldNameClass {
    global Map<String,String> chidlObjAPIName_FieldAPIName;
    global Map<string,string> childFieldsName;
    
    global ChildFieldNameClass(Map<String,String> chidlObjAPIName_FieldAPIName,Map<string,string> childFieldsName) {
        this.chidlObjAPIName_FieldAPIName = chidlObjAPIName_FieldAPIName;
        this.childFieldsName = childFieldsName;
    }
}