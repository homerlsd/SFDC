/*
Custom iterator for ARPrintBatchFillData Batch class.
*/
global class IterateFillData implements iterable<OldNewId>
{
   public List<OldNewId> sObjectList = new List<OldNewId>();
   global Iterator<OldNewId> Iterator()
   {
      return new CustomIterable(sObjectList);
   }
}