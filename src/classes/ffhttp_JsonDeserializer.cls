/**
 * Copyright (c) 2014, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * ffhttp_JsonDeserializer
 *
 * Class to allow JSON strings to be deserialized into a given type.
 */
public with sharing class ffhttp_JsonDeserializer implements ffhttp_IDeserialize 
{
	private static final String JSON_DESERIALIZATION_ERROR = 'Could not deserialize JSON';

    private static final String DOUBLE_QUOTE = '"';
    private static final String DOUBLE_QUOTE_COLON = DOUBLE_QUOTE + ':';
    private static final String REGULAR_EXPRESSION = '"\\s{0,}:';

    private System.Type m_apexType;
    private Map<String, String> m_fieldsToReplace;

    public ffhttp_JsonDeserializer(System.Type apexType) 
    {
        this(apexType, null);
    }
    
    public ffhttp_JsonDeserializer(System.Type apexType, Map<String, String> fieldsToReplace)
    {
        m_apexType = apexType;
        m_fieldsToReplace = fieldsToReplace;
    }

    public Object deserialize(String jsonString) 
    {
        try 
        {
            // In some cases, external APIs may use APEX keywords as field names. To make deserialization easier these fields can be renamed using this map.
            if (m_fieldsToReplace != null)
            {
             	Set<String> fields = m_fieldsToReplace.keySet();
             	for (String field : fields)
             	{
             		String replacement = m_fieldsToReplace.get(field);
             		jsonString = jsonString.replaceAll(DOUBLE_QUOTE + field + REGULAR_EXPRESSION, DOUBLE_QUOTE + replacement + DOUBLE_QUOTE_COLON);
             	}
            }
        
            return m_apexType == null ? JSON.deserializeUntyped(jsonString) : JSON.deserialize(jsonString, m_apexType);
        }
        catch (Exception e)
        {
            System.debug(LoggingLevel.ERROR, jsonString);
            throw new ffhttp_SystemException(JSON_DESERIALIZATION_ERROR, e);
        }
    }
}