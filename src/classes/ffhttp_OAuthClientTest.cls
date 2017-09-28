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
 * ffhttp_OAuthClientTest
 *
 * Test class for ffhttp_OAuthClient.
 */
@isTest
private class ffhttp_OAuthClientTest
{
	static testMethod void generateAuthorizationUrl_generatesCorrectUrl()
	{
		// Given
		ffhttp_OAuthClient client = new ffhttp_OAuthClient();

		// When
		String url = client.generateAuthorizationUrl(new MockConnectorType(), 'teststate');

		// Then
		System.assert(url.equals('https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=35780030306-f9tvdjig5av01uashtnhkkfmtdghh3di.apps.googleusercontent.com&redirect_uri=https%3A%2F%2Feu3.salesforce.com%2Fapex%2Fconnector&state=teststate&access_type=offline&approval_prompt=force'));
	}

	static testMethod void exchangeAuthCodeRequest_buildsHttpRequestCorrectly()
	{
		// Given
		ffhttp_OAuthClient client = new ffhttp_OAuthClient();

		ffhttp_OAuthClient.ExchangeAuthCodeRequest authCodeRequest = client.exchangeAuthCodeRequest(new MockConnectorType(), 'testcode');

		// When
		HttpRequest request = authCodeRequest.buildHttpRequest();

		// Then
		System.assertEquals(request.getEndpoint(), 'https://accounts.google.com/o/oauth2/token');
		System.assertEquals(request.getMethod(), 'POST');
		System.assertEquals(request.getHeader('Content-Type'), 'application/x-www-form-urlencoded');
		System.assertEquals(request.getBody(), 'code=testcode&grant_type=authorization_code&client_id=35780030306-f9tvdjig5av01uashtnhkkfmtdghh3di.apps.googleusercontent.com&client_secret=Exd29I0NjExkm6RDFR-MY-Gx&redirect_uri=https%3A%2F%2Feu3.salesforce.com%2Fapex%2Fconnector');
	}

	static testMethod void exchangeAuthCodeRequest_response()
	{
		// Given
		Test.setMock(HttpCalloutMock.class, new OAuthHttpResponse());

		ffhttp_OAuthClient client = new ffhttp_OAuthClient();

		ffhttp_OAuthClient.ExchangeAuthCodeRequest authCodeRequest = client.exchangeAuthCodeRequest(new MockConnectorType(), 'testcode');

		// When
		ffhttp_OAuthClient.AccessTokenResponse authTokenResponse = (ffhttp_OAuthClient.AccessTokenResponse) authCodeRequest.execute();

		// Then
		System.assertEquals(authTokenResponse.access_token, '1/fFAGRNJru1FTz70BzhT3Zg');
		System.assertEquals(authTokenResponse.expires_in, 3920);
		System.assertEquals(authTokenResponse.token_type, 'Bearer');
		System.assertEquals(authTokenResponse.refresh_token, '1/xEoDL4iW3cxlI7yDbSRFYNG01kVKM2C-259HOF2aQbI');
	}

	static testMethod void exchangeRefreshTokenRequest_buildsHttpRequestCorrectly()
	{
		// Given
		ffhttp_OAuthClient client = new ffhttp_OAuthClient();

		ffhttp_OAuthClient.ExchangeRefreshTokenRequest refreshTokenRequest = client.exchangeRefreshTokenRequest(new MockConnectorType(), 'testRefreshToken');

		// When
		HttpRequest request = refreshTokenRequest.buildHttpRequest();

		// Then
		System.assertEquals(request.getEndpoint(), 'https://accounts.google.com/o/oauth2/token');
		System.assertEquals(request.getMethod(), 'POST');
		System.assertEquals(request.getHeader('Content-Type'), 'application/x-www-form-urlencoded');
		System.assertEquals(request.getBody(), 'grant_type=refresh_token&client_id=35780030306-f9tvdjig5av01uashtnhkkfmtdghh3di.apps.googleusercontent.com&client_secret=Exd29I0NjExkm6RDFR-MY-Gx&redirect_uri=https%3A%2F%2Feu3.salesforce.com%2Fapex%2Fconnector&refresh_token=testRefreshToken');
	}

	/************************************************************************************************************
	 * Test classes
	 ************************************************************************************************************/

	/**
	 * Mock response for OAuth authorisation 
	 */
	class OAuthHttpResponse implements HttpCalloutMock
	{
		public HttpResponse respond(HTTPRequest req)
		{
			HttpResponse res = new HttpResponse();
			res.setBody('{"access_token":"1/fFAGRNJru1FTz70BzhT3Zg","expires_in":3920,"token_type":"Bearer","refresh_token":"1/xEoDL4iW3cxlI7yDbSRFYNG01kVKM2C-259HOF2aQbI"}');
			res.setStatusCode(200);
			return res;
		}
	}

	/**
	 * MockConnectorType test class
	 *
	 * Mocks the Google OAuth Authorization information
	 */
	class MockConnectorType implements ffhttp_IConnectorType
	{
		public String getAuthorizationEndpoint()
		{
			return 'https://accounts.google.com/o/oauth2/auth';
		}

		public String getTokenEndpoint()
		{
			return 'https://accounts.google.com/o/oauth2/token';
		}

		public String getClientId()
		{
			return '35780030306-f9tvdjig5av01uashtnhkkfmtdghh3di.apps.googleusercontent.com';
		}

		public String getClientSecret()
		{
			return 'Exd29I0NjExkm6RDFR-MY-Gx';
		}

		public String getRedirectUri()
		{
			return 'https://eu3.salesforce.com/apex/connector';
		}

		public String getExtraUrlParameters()
		{
			return 'access_type=offline&approval_prompt=force';
		}
	}

}
