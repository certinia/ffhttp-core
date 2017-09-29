/**
 * Copyright (c) 2014-2017, FinancialForce.com, inc
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
 * ffhttp_ClientTest
 *
 * Test class for the ffhttp 'package'.
 */
@isTest
private class ffhttp_ClientTest
{
	/**
	 * Check that you can create a valid AccessTokenCredentials object
	 */
	static testMethod void testAccessTokenCredentials()
	{
		ffhttp_Client.AccessTokenCredentials credentials = new ffhttp_Client.AccessTokenCredentials('Bearer', 'Test');

		System.assertEquals(credentials.getTokenType(), 'Bearer');
		System.assertEquals(credentials.getAccessToken(), 'Test');

		credentials.setTokenType('Basic')
			.setAccessToken('Testing');

		System.assertEquals(credentials.getTokenType(), 'Basic');
		System.assertEquals(credentials.getAccessToken(), 'Testing');
	}

	/**
	 * Check the AccessTokenCredentials endpoint is correctly set
	 */
	static testMethod void testAccessTokenCredentialsEndpoint()
	{
		ffhttp_Client.AccessTokenCredentials credentials = new ffhttp_Client.AccessTokenCredentials('Bearer', 'Test');
		credentials.setBaseURL('https://www.financialforce.com');

		System.assertEquals(credentials.getBaseURL(), 'https://www.financialforce.com');
		System.assertEquals(credentials.toEndpoint(), 'https://www.financialforce.com');

		credentials.setBaseURL(null);

		System.assertEquals(credentials.toEndpoint(), '');
	}

	/**
	 * Check the AccessTokenCredentials certificate name is correctly set
	 */
	static testMethod void testAccessTokenCredentialsCertificateName()
	{
		ffhttp_Client.AccessTokenCredentials credentials = new ffhttp_Client.AccessTokenCredentials('Bearer', 'Test');
		credentials.setClientCertificateName('FinancialForce');

		System.assertEquals(credentials.getClientCertificateName(), 'FinancialForce');
	}

	/**
	 * Check that you cannot create a AccessTokenCredentials object with a null AccessToken or TokenType.
	 */
	static testMethod void testInvalidAccessTokenCredentials()
	{
		try
		{
			ffhttp_Client.ICredentials credentials = new ffhttp_Client.AccessTokenCredentials(null, null);
			System.assert(false, 'A ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assertEquals(ex.getMessage(), 'TokenType cannot be null');

			try
			{
				ffhttp_Client.ICredentials credentials = new ffhttp_Client.AccessTokenCredentials('Basic', null);
				System.assert(false, 'SystemException 2 was not thrown');
			}
			catch (ffhttp_SystemException ex2)
			{
				System.assertEquals(ex2.getMessage(), 'AccessToken cannot be null');
			}
		}
	}

	/**
	 * Check that you can create a valid NamedCredentials object
	 */
	static testMethod void testNamedCredentials()
	{
		ffhttp_Client.NamedCredentials credentials = new ffhttp_Client.NamedCredentials('Test');

		System.assertEquals(credentials.getName(), 'Test');

		credentials.setName('Test2');

		System.assertEquals(credentials.getName(), 'Test2');
	}

	/**
	 * Check the NamedCredentials endpoint is correctly set
	 */
	static testMethod void testNamedCredentialsEndpoint()
	{
		ffhttp_Client.NamedCredentials credentials = new ffhttp_Client.NamedCredentials('FinancialForce');

		System.assertEquals(credentials.toEndpoint(), 'callout:FinancialForce');
	}

	/**
	 * Check that you cannot create a NamedCredentials object with a null Name.
	 */
	static testMethod void testInvalidNamedCredentials()
	{
		try
		{
			ffhttp_Client.ICredentials credentials = new ffhttp_Client.NamedCredentials(null);
			System.assert(false, 'A ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assertEquals(ex.getMessage(), 'Named Credential Name cannot be null');
		}
	}

	/**
	 * Check that you cannot set a NamedCredentials name to null.
	 */
	static testMethod void testInvalidNamedCredentialsName()
	{
		ffhttp_Client.NamedCredentials credentials = new ffhttp_Client.NamedCredentials('FinancialForce');

		try
		{
			credentials.setName(null);
			System.assert(false, 'A ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assertEquals(ex.getMessage(), 'Named Credential Name cannot be null');
		}
	}

	/**
	 * Check that to send a ffhttp_Client request the AbstractClient must be set.
	 */
	static testMethod void testRequestNoClient()
	{
		HttpClientRequest request = new HttpClientRequest();

		try
		{
			request.buildHttpRequest();
			System.assert(false, 'A ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assertEquals(ex.getMessage(), 'AbstractClient not set');
		}
	}

	/**
	 * Check that to send a ffhttp_Client request the Credentials must be set.
	 */
	static testMethod void testRequestNoCredentials()
	{
		InvalidCredentialHttpClient client = new InvalidCredentialHttpClient();
		HttpClientRequest request = new HttpClientRequest(client, null, null, null, null);

		try
		{
			request.buildHttpRequest();
			System.assert(false, 'A ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assertEquals(ex.getMessage(), 'AbstractClient.Credentials not set');
		}
	}

	/**
	 * Check that buildHttpRequest correctly builds the request URL.
	 */
	static testMethod void testRequestUrl()
	{
		HttpClientRequest clientRequest = getDefaultClientRequest();
		HttpRequest request = clientRequest.buildHttpRequest();

		System.assertEquals(request.getEndpoint(), 'TestEndpoint');
		System.assertEquals(request.getMethod(), 'POST');
	}

	/**
	 * Test each of the addParam/getParam methods 
	 */
	static testMethod void testRequestStringParameters()
	{
		HttpClientRequest clientRequest = getDefaultClientRequest();
		HttpRequest request = clientRequest.buildHttpRequest();

		String stringtest = clientRequest.getParam('StringTest', 'Test Default');
		System.assertEquals(stringTest, 'Test Default');

		stringtest = clientRequest.getParam('StringTest', (String) null);
		System.assertEquals(stringTest, null);

		clientRequest.addParam('StringTest', 'Test');
		stringtest = clientRequest.getParam('StringTest', 'Testing');
		System.assertEquals(stringTest, 'Test');

		request = clientRequest.buildHttpRequest();
		System.assertEquals(request.getEndpoint(), 'TestEndpoint?StringTest=Test');

		stringtest = clientRequest.getParam('StringTest', 'Test 2');
		System.assertEquals(stringTest, 'Test');
	}

	static testMethod void testRequestBooleanParameters()
	{
		HttpClientRequest clientRequest = getDefaultClientRequest();
		clientRequest.addParam('BooleanTrueTest', true);
		clientRequest.addParam('BooleanFalseTest', false);
		clientRequest.addParam('BooleanNullTest', (Boolean) null);

		boolean booleanTrueTest = clientRequest.getParam('BooleanTrueTest', false);
		System.assertEquals(booleanTrueTest, true);

		boolean booleanFalseTest = clientRequest.getParam('BooleanFalseTest', true);
		System.assertEquals(booleanFalseTest, false);

		boolean booleanNullTest = clientRequest.getParam('BooleanNullTest', false);
		System.assertEquals(booleanNullTest, false);

		HttpRequest request = clientRequest.buildHttpRequest();
		System.assertEquals(request.getEndpoint(), 'TestEndpoint?BooleanTrueTest=true&BooleanFalseTest=false');
	}

	static testMethod void testRequestIntegerParameters()
	{
		HttpClientRequest clientRequest = getDefaultClientRequest();
		clientRequest.addParam('IntegerPositiveTest', 10);
		clientRequest.addParam('IntegerNegativeTest', -10);
		clientRequest.addParam('IntegerNullTest', (Integer) null);

		Integer integerPostiveTest = clientRequest.getParam('IntegerPositiveTest', 50);
		System.assertEquals(integerPostiveTest, 10);

		Integer integerNegativeTest = clientRequest.getParam('IntegerNegativeTest', -50);
		System.assertEquals(integerNegativeTest, -10);

		Integer integerNullTest = clientRequest.getParam('IntegerNullTest', 40);
		System.assertEquals(integerNullTest, 40);

		HttpRequest request = clientRequest.buildHttpRequest();
		System.assertEquals(request.getEndpoint(), 'TestEndpoint?IntegerPositiveTest=10&IntegerNegativeTest=-10');
	}

	static testMethod void testRequestLongParameters()
	{
		HttpClientRequest clientRequest = getDefaultClientRequest();
		clientRequest.addParam('LongPositiveTest', Long.valueOf('10'));
		clientRequest.addParam('LongNegativeTest', Long.valueOf('-10'));
		clientRequest.addParam('LongNullTest', (Long) null);

		Long longPostiveTest = clientRequest.getParam('LongPositiveTest', Long.valueOf('50'));
		System.assertEquals(longPostiveTest, 10);

		Long longNegativeTest = clientRequest.getParam('LongNegativeTest', Long.valueOf('-50'));
		System.assertEquals(longNegativeTest, -10);

		Long longNullTest = clientRequest.getParam('LongNullTest', Long.valueOf('40'));
		System.assertEquals(longNullTest, 40);

		HttpRequest request = clientRequest.buildHttpRequest();
		System.assertEquals(request.getEndpoint(), 'TestEndpoint?LongPositiveTest=10&LongNegativeTest=-10');
	}

	/**
	 * Check that if the paramsAsJson flag is true then the parameters are added to the request body
	 */
	static testMethod void testRequestSetsJSONBodyIfParamsAsJsonIsTrue()
	{
		// Given
		HttpClientRequest clientRequest = getDefaultClientRequest();
		clientRequest.addParam('LongPositiveTest', Long.valueOf('10'));
		clientRequest.addParam('LongNegativeTest', Long.valueOf('-10'));

		clientRequest.setParamsAsJson(true);

		// When
		HttpRequest request = clientRequest.buildHttpRequest();

		// Then
		System.assertEquals(request.getEndpoint(), 'TestEndpoint');
		System.assertEquals(request.getHeader('Content-Type'), 'application/json; charset=UTF-8');
		System.assertEquals(request.getHeader('Content-Length'), '46');
		System.assertEquals(request.getBody(), '{"LongNegativeTest":-10,"LongPositiveTest":10}');
	}

	/**
	 * Check that a request cannot have both a body and JSON parameters
	 */
	static testMethod void testRequestCannotHaveBothABodyAndParamsAsJsonSet()
	{
		// Given
		JsonTest body = new JsonTest();
		NoCredentialHttpClient client = new NoCredentialHttpClient();
		HttpClientRequest request = new HttpClientRequest(client, 'TestEndpoint', 'POST', body, null);
		request.setParamsAsJson(true);
		request.addParam('Test', 'Test');

		// When - Then
		try
		{
			request.buildHttpRequest();
			System.assert(false, 'A ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assertEquals(ex.getMessage(), 'AbstractClientRequest: Invalid State: A request cannot have both a request body and JSON parameters');
		}
	}

	/**
	 * Check that the request body is correctly set for blob content and json content.
	 */
	static testMethod void testRequestBody()
	{
		NoCredentialHttpClient client = new NoCredentialHttpClient();

		Blob b = Blob.valueOf('{ title=Test }');
		ffhttp_BlobContent jsonContent = new ffhttp_BlobContent(b, 'application-json');

		HttpClientRequest clientRequest = new HttpClientRequest(client, 'TestEndpoint', 'POST', jsonContent, null);
		HttpRequest request = clientRequest.buildHttpRequest();

		System.assertEquals(request.getHeader('Content-Type'), 'application-json');
		System.assertEquals(request.getBodyAsBlob(), b);
		System.assertEquals(request.getHeader('Content-Length'), '14');

		JsonTest jsonBody = new JsonTest();
		clientRequest = new HttpClientRequest(client, 'TestEndpoint', 'POST', jsonBody, null);
		request = clientRequest.buildHttpRequest();

		System.assertEquals(request.getHeader('Content-Type'), 'application/json; charset=UTF-8');
		System.assertEquals(request.getBody(), '{"test":"Test"}');
		System.assertEquals(request.getHeader('Content-Length'), '15');
	}

	/**
	 * Check that a request with a valid response is dealt with appropriately.
	 */
	static testMethod void testExecuteValidResponse()
	{
		NoCredentialHttpClient client = new NoCredentialHttpClient();

		Test.setMock(HttpCalloutMock.class, new HttpResponseSuccess());

		HttpClientRequest clientRequest = new HttpClientRequest(client, 'TestEndpoint', 'POST', null, new ffhttp_JsonDeserializer(JsonTest.class));

		Object response = clientRequest.execute();
		System.assert(response != null, 'Response should not be null');
		System.assert(response instanceof JsonTest, 'Response should be an instance of JsonTest');
		System.assertEquals(((JsonTest) response).getTest(), 'Test');
	}

	/**
	 * Check error for invalid responses
	 */
	static testMethod void executeUnparsed_throwsException_ifRedirectionResponseReturned()
	{
		// Given
		Test.setMock(HttpCalloutMock.class, new HttpResponse_RedirectionRequest());

		HttpClientRequest clientRequest = getDefaultClientRequest();

		try
		{
			// When
			clientRequest.executeUnparsed();
			System.assert(false, 'An ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			// Then
			System.assertEquals(ex.getMessage(), System.Label.ffhttp_UnhandledRedirection);
		}
	}

	static testMethod void executeUnparsed_throwsException_ifClientErrorResponseReturned()
	{
		// Given
		Test.setMock(HttpCalloutMock.class, new HttpResponse_BadRequest());

		HttpClientRequest clientRequest = getDefaultClientRequest();

		try
		{
			// When
			clientRequest.executeUnparsed();
			System.assert(false, 'An ffhttp_AppException was not thrown');
		}
		catch (ffhttp_AppException ex)
		{
			// Then
			System.assertEquals(ex.getMessage(), 'Invalid Request');
			System.assertEquals(ex.getStatus(), 'Invalid Request');
			System.assertEquals(ex.getStatusCode(), ffhttp_Client.HTTP_STATUS_CODE_ERROR_BAD_REQUEST);
		}
	}

	/**
	 * Check extra headers are dealt with correctly
	 */
	static testMethod void buildHttpRequest_throwsException_ifContentLengthHeaderInExtraHeaders()
	{
		// Given
		HttpClientRequest clientRequest = getDefaultClientRequest();
		clientRequest.addExtraHeader(ffhttp_Client.HTTP_HEADER_CONTENT_LENGTH, 'Test');

		//When
		try
		{
			clientRequest.buildHttpRequest();
			System.assert(false, 'An ffhttp_AppException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assertEquals(ex.getMessage(), 'AbstractClientRequest: Invalid State: Cannot add protected header');
		}
	}

	static testMethod void buildHttpRequest_throwsException_ifContentTypeHeaderInExtraHeaders()
	{
		// Given
		HttpClientRequest clientRequest = getDefaultClientRequest();
		clientRequest.addExtraHeader(ffhttp_Client.HTTP_HEADER_CONTENT_TYPE, 'Test');

		//When
		try
		{
			clientRequest.buildHttpRequest();
			System.assert(false, 'An ffhttp_AppException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			System.assertEquals(ex.getMessage(), 'AbstractClientRequest: Invalid State: Cannot add protected header');
		}
	}

	static testMethod void buildHttpRequest_addsExtraHeadersCorrectly()
	{
		// Given
		HttpClientRequest clientRequest = getDefaultClientRequest();
		clientRequest.addExtraHeader('Xrfkey', 'Test');

		// When
		HttpRequest request = clientRequest.buildHttpRequest();

		// Then
		System.assertEquals(request.getHeader('Xrfkey'), 'Test');
	}

	/**
	 * Check toCurlCommand returns the correct commands
	 */
	static testMethod void toCurlCommand_createsCommandCorrectly_forSimpleGetEndpoint()
	{
		// Given
		NoCredentialHttpClient client = new NoCredentialHttpClient();
		HttpClientRequest clientRequest = new HttpClientRequest(client, 'https://www.financialforce.com', 'GET', null, null);

		// When
		String curlCommand = clientRequest.toCurlCommand();

		// Then
		System.assertEquals(curlCommand, 'curl -X GET https://www.financialforce.com -H "Content-Length:0"');
	}

	static testMethod void toCurlCommand_createsCommandCorrectly_forAuthenticatedGetEndpoint()
	{
		// Given
		CredentialHttpClient client = new CredentialHttpClient();
		HttpClientRequest clientRequest = new HttpClientRequest(client, 'https://www.financialforce.com', 'GET', null, null);

		// When
		String curlCommand = clientRequest.toCurlCommand();

		// Then
		System.assertEquals(curlCommand, 'curl -X GET https://www.financialforce.com -H "Authorization:Basic Test Credentials" -H "Content-Length:0"');
	}

	static testMethod void toCurlCommand_createsCommandCorrectly_forAuthenticatedPostEndpoint()
	{
		// Given
		JsonTest body = new JsonTest();
		CredentialHttpClient client = new CredentialHttpClient();
		HttpClientRequest clientRequest = new HttpClientRequest(client, 'https://www.financialforce.com', 'POST', body, null);

		// When
		String curlCommand = clientRequest.toCurlCommand();

		// Then
		System.assertEquals(curlCommand, 'curl -X POST https://www.financialforce.com -H "Authorization:Basic Test Credentials" -H "Content-Length:15" -H "Content-Type:application/json; charset=UTF-8" -d "{\\"test\\":\\"Test\\"}"');
	}

	/************************************************************************************************************
	 * Test Helpers
	 ************************************************************************************************************/

	private static HttpClientRequest getDefaultClientRequest()
	{
		CredentialHttpClient client = new CredentialHttpClient();
		return new HttpClientRequest(client, 'TestEndpoint', 'POST', null, null);
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

	class CredentialHttpClient extends ffhttp_Client.AbstractClient
	{
		public CredentialHttpClient()
		{
			setCredentials(new ffhttp_Client.AccessTokenCredentials('Basic', 'Test Credentials'));
			setCredentialsRequired(true);
		}
	}

	class InvalidCredentialHttpClient extends ffhttp_Client.AbstractClient
	{
		public InvalidCredentialHttpClient()
		{
			setCredentialsRequired(true);
		}
	}

	class NoCredentialHttpClient extends ffhttp_Client.AbstractClient
	{
		public NoCredentialHttpClient()
		{
			setCredentialsRequired(false);
		}
	}

	/**
	 * Mock success HTTP response
	 */
	class HttpResponseSuccess implements HttpCalloutMock
	{
		public HttpResponse respond(HTTPRequest req)
		{
			HttpResponse res = new HttpResponse();
			res.setStatus('OK');
			res.setStatusCode(200);
			res.setBody('{"test":"Test"}');
			return res;
		}
	}

	/**
	 * Mock invalid HTTP responses
	 */
	class HttpResponse_RedirectionRequest implements HttpCalloutMock
	{
		public HttpResponse respond(HTTPRequest req)
		{
			HttpResponse res = new HttpResponse();
			res.setStatus('Invalid Request');
			res.setStatusCode(ffhttp_Client.HTTP_STATUS_CODE_REDIRECTION_FOUND);
			return res;
		}
	}

	class HttpResponse_BadRequest implements HttpCalloutMock
	{
		public HttpResponse respond(HTTPRequest req)
		{
			HttpResponse res = new HttpResponse();
			res.setStatus('Invalid Request');
			res.setStatusCode(ffhttp_Client.HTTP_STATUS_CODE_ERROR_BAD_REQUEST);
			return res;
		}
	}

	class HttpClientRequest extends ffhttp_Client.AbstractClientRequest
	{
		public HttpClientRequest()
		{}

		public HttpClientRequest(AbstractClient abstractClient, String endpoint, String requestMethod, ffhttp_IHttpContent httpContent, ffhttp_IDeserialize responseDeserializer)
		{
			super(abstractClient, endpoint, requestMethod, httpContent, responseDeserializer);
		}
	}
}
