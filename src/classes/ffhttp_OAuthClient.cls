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
 * ffhttp_OAuthClient
 *
 * Class to represent the OAuth HTTP client.
 * This class deals with sending and receiving OAuth authentication requests and responses.
 */
public with sharing class ffhttp_OAuthClient extends ffhttp_Client.AbstractClient
{
	/**
	 * Constructor
	 */
	public ffhttp_OAuthClient()
	{
		this.setCredentialsRequired(false);
	}
	
	/**
	 * Helper methods
	 */
	public String generateAuthorizationUrl(ffhttp_IConnectorType connectorType, String state)
	{
		String url = String.format(
    		'{0}?response_type=code&client_id={1}&redirect_uri={2}&state={3}&{4}',
    		new List<String>{
    			connectorType.getAuthorizationEndpoint(),
    			EncodingUtil.urlEncode(connectorType.getClientId(), ffhttp_Client.CHARSET_UTF8),
    			EncodingUtil.urlEncode(connectorType.getRedirectUri(), ffhttp_Client.CHARSET_UTF8),
    			state,
    			connectorType.getExtraUrlParameters()
    		}
		);
	
		return url;
	}
	
	/*********************************************************************************************************
	 * Requests
	 *********************************************************************************************************/
	 
	public ExchangeAuthCodeRequest exchangeAuthCodeRequest(ffhttp_IConnectorType ct, String code) 
	{
		AuthCodeRequestBody content = new AuthCodeRequestBody(ct, 'authorization_code', code, null);
		return new ExchangeAuthCodeRequest(this, ct.getTokenEndpoint(), content);
	}
	
	public ExchangeRefreshTokenRequest exchangeRefreshTokenRequest(ffhttp_IConnectorType ct, String refreshToken)
	{	
		AuthCodeRequestBody content = new AuthCodeRequestBody(ct, 'refresh_token', null, refreshToken);
		return new ExchangeRefreshTokenRequest(this, ct.getTokenEndpoint(), content);
	}
	
	/*********************************************************************************************************
	 * API Callout Inner Classes
	 *********************************************************************************************************/
	 
	public class ExchangeAuthCodeRequest extends ffhttp_Client.AbstractClientRequest
	{
		public ExchangeAuthCodeRequest(ffhttp_Client.AbstractClient client, String endpoint, AuthCodeRequestBody httpContent)
		{
			super(client, endpoint, REQUEST_METHOD_POST, httpContent, new ffhttp_JsonDeserializer(AccessTokenResponse.class));	
		}
	}
	
	public class ExchangeRefreshTokenRequest extends ffhttp_Client.AbstractClientRequest
	{
		ExchangeRefreshTokenRequest(ffhttp_Client.AbstractClient client, String endpoint, AuthCodeRequestBody httpContent)
		{
			super(client, endpoint, REQUEST_METHOD_POST, httpContent, new ffhttp_JsonDeserializer(AccessTokenResponse.class));	
		} 
	}
	
	/*********************************************************************************************************
	 * Inner Classes
	 *********************************************************************************************************/
	
	class AuthCodeRequestBody implements ffhttp_IHttpContent 
	{
		String grantType;
		String code;
		String clientId;
		String clientSecret;
		String redirectUri;
		String refreshToken;
		
		public AuthCodeRequestBody(ffhttp_IConnectorType ct, String grantType, String code, String refreshToken)
		{
			this.clientId = ct.getClientId();
			this.clientSecret = ct.getClientSecret();
			this.redirectUri = ct.getRedirectUri();
			
			this.grantType = grantType;
			this.code = code;
			this.refreshToken = refreshToken;
		}
		
		/**
		 * IHttpContent implementation
		 */
		public String getHttpContentType()
		{
			return 'application/x-www-form-urlencoded';
		}
	
		public Object getHttpContent()
		{	
			String content = '';
			content = addParameterIfStringNotEmpty(content, 'code', code, false);
			content = addParameterIfStringNotEmpty(content, 'grant_type', grantType, false);
			content = addParameterIfStringNotEmpty(content, 'client_id', clientId, true);
			content = addParameterIfStringNotEmpty(content, 'client_secret', clientSecret, true);
			content = addParameterIfStringNotEmpty(content, 'redirect_uri', redirectUri, true);
			content = addParameterIfStringNotEmpty(content, 'refresh_token', refreshToken, false);		
			return content;
		}
		
		private String addParameterIfStringNotEmpty(String content, String parameter, String value, Boolean encode)
		{
			if (String.isEmpty(value))
			{
				return content;
			}
			
			if (!String.isEmpty(content))
			{
				content += ffhttp_Client.HTTP_REQUEST_ENDPOINT_SEPARATOR;
			}
			
			if (encode)
			{
				value = EncodingUtil.urlEncode(value, ffhttp_Client.CHARSET_UTF8);
			}
			
			return content += parameter + ffhttp_Client.HTTP_REQUEST_PARAMETER_SEPARATOR + value;
		}
	}
	
	public class AccessTokenResponse extends ffhttp_AbstractJsonSerializable
	{
		public String access_token { get; set; }
		public String token_type { get; set; }
		public String refresh_token { get; set; }
		public Decimal expires_in { get; set; }
	}
}