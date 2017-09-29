/**
 * Copyright (c) 2017, FinancialForce.com, inc
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
 * ffhttp_JsonDeserializerTest
 *
 * Test class for ffhttp_JsonDeserializer.
 */
@isTest
private class ffhttp_JsonDeserializerTest
{
	/**
	 * Check that ffhttp_JsonDeserializer correctly deserializes an object
	 */
	static testMethod void testJsonDeserializer()
	{
		JsonTest test = new JsonTest();

		ffhttp_JsonDeserializer jds = new ffhttp_JsonDeserializer(JsonTest.class);
		System.assert(jds != null, 'ffhttp_JsonDeserializer should not be null');

		JsonTest test2 = (JsonTest) jds.deserialize('{"test":"Test"}');
		System.assertEquals(test2.getTest(), 'Test');
	}

	/**
	 * Check that ffhttp_JsonDeserializer throws an exception for invalid JSON
	 */
	static testMethod void testJsonDeserializerWithInvalidJson()
	{
		JsonTest test = new JsonTest();

		ffhttp_JsonDeserializer jds = new ffhttp_JsonDeserializer(JsonTest.class);
		System.assert(jds != null, 'ffhttp_JsonDeserializer should not be null');

		try
		{
			JsonTest test2 = (JsonTest) jds.deserialize('{"invalid json test}');
			System.assert(false, 'A ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assertEquals(ex.getMessage(), 'Could not deserialize JSON');
		}
	}

	/**
	 * Check that ffhttp_JsonDeserializer correctly deserializes a string with a field to replace
	 */
	static testMethod void testJsonDeserializerWithAFieldToReplace()
	{
		Map<String, String> fieldsToReplace = new Map<String, String>();
		fieldsToReplace.put('testing', 'test');

		ffhttp_JsonDeserializer jds = new ffhttp_JsonDeserializer(JsonTest.class, fieldsToReplace);

		JsonTest test = (JsonTest) jds.deserialize('{"testing":"Test"}');
		System.assertEquals(test.getTest(), 'Test');
	}

	/**
	 * Check that ffhttp_JsonDeserializer correctly deserializes a string with multiple fields to replace
	 */
	static testMethod void testJsonDeserializerWithMultipleFieldsToReplace()
	{
		Map<String, String> fieldsToReplace = new Map<String, String>();
		fieldsToReplace.put('testing', 'test');
		fieldsToReplace.put('testing2', 'test2');

		ffhttp_JsonDeserializer jds = new ffhttp_JsonDeserializer(JsonTest2.class, fieldsToReplace);

		JsonTest2 test = (JsonTest2) jds.deserialize('{"testing":"Test","testing2":"Test2"}');
		System.assertEquals(test.getTest(), 'Test');
		System.assertEquals(test.getTest2(), 'Test2');
	}

	/**
	 * Check that ffhttp_JsonDeserializer replaces all fields with the same name
	 */
	static testMethod void testJsonDeserializerWithFieldsToReplaceCreatingDuplicate()
	{
		Map<String, String> fieldsToReplace = new Map<String, String>();
		fieldsToReplace.put('testing', 'test');

		ffhttp_JsonDeserializer jds = new ffhttp_JsonDeserializer(JsonTest.class, fieldsToReplace);

		try
		{
			JsonTest test = (JsonTest) jds.deserialize('{"testing":"Test","testing":"Test"}');
			System.assert(false, 'A ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assert(ex.getCause() instanceOf System.JSONException, 'System.JSONException should be the cause');
		}
	}

	/************************************************************************************************************
	 * Test classes
	 ************************************************************************************************************/

	class JsonTest extends ffhttp_AbstractJsonSerializable
	{
		private String test = 'Test';

		public String getTest()
		{
			return test;
		}
	}

	class JsonTest2 extends ffhttp_AbstractJsonSerializable
	{
		private String test = 'Test';
		private String test2 = 'Test2';

		public String getTest()
		{
			return test;
		}
		public String getTest2()
		{
			return test2;
		}
	}
}
