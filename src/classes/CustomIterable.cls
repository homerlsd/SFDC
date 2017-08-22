global class CustomIterable implements Iterator<OldNewId>
{
   List<OldNewId> listSobjects {get; set;}
   Integer i {get; set;}
   
   public CustomIterable(List<OldNewId> sObjList)
   {
       listSobjects = new List<OldNewId>();
       listSobjects.addAll(sObjList);
       i=0;
   }
   global boolean hasNext()
   {
       if(i >= listSobjects.size()) {
           return false;
       } else {
           return true;
       }
   }
   global OldNewId next(){
       if(i == listSobjects.size())
           return null;
       
       i++;
       return listSobjects[i-1];
   }
}