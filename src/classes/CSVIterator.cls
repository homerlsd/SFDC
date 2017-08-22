global with sharing class CSVIterator implements Iterator<String>, Iterable<String>
{
   private String m_CSVData;
   private String m_introValue;
   private string finalRow {get;set;}
   
    public CSVIterator(String fileData, String introValue)
    {
     	m_CSVData = fileData;
      	m_introValue = introValue; 
      	finalRow = ''; 
    }

    global Boolean hasNext()
    {
   	    system.debug('DO WE MOVE ONTO NEXT OR FINISH? ' + finalRow);

   		return finalRow == 'true' ? false : true;
    }
    
    global String next()
    {   
        String row = m_CSVData.contains(m_introValue) ? m_CSVData.subString(0, m_CSVData.indexOf(m_introValue)) : m_CSVData;
      	system.debug('row is ' + row);
      	m_CSVData = m_CSVData.subString(m_CSVData.indexOf(m_introValue) + m_introValue.length(),m_CSVData.length());
      	system.debug('all data is ' + m_CSVData);
      	
      	if(row==m_CSVData)
      		finalRow = 'true';
      	return row;
    }
    
    global Iterator<String> Iterator()
    {
      	return this;   
    }
}