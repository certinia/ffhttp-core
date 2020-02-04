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
 * ffhttp_Client
 *
 * Creates a HTTP client capable of sending HTTPRequests.
 */
public with sharing class ffhttp_Client
{
	// Client request method calls
	public static final String REQUEST_METHOD_DELETE = 'DELETE';
	public static final String REQUEST_METHOD_GET = 'GET';
	public static final String REQUEST_METHOD_POST = 'POST';
	public static final String REQUEST_METHOD_PUT = 'PUT';

	// URL 
	public static final String NAMED_CREDENTIALS_URL_PREFIX = 'callout:';

	// Header names
	public static final String HTTP_HEADER_AUTHORIZATION = 'Authorization';
	public static final String HTTP_HEADER_CONTENT_DISPOSITION = 'Content-Disposition';
	public static final String HTTP_HEADER_CONTENT_LENGTH = 'Content-Length';
	public static final String HTTP_HEADER_CONTENT_TYPE = 'Content-Type';

	// Content types
	public static final String CONTENT_TYPE_JSON = 'application/json; charset=UTF-8';
	public static final String CONTENT_TYPE_WWW_FORM_ENCODED = 'application/x-www-form-urlencoded';

	// Separator
	public static final String HTTP_REQUEST_ENDPOINT_SEPARATOR = '&';
	public static final String HTTP_REQUEST_PARAMETER_SEPARATOR = '=';
	public static final String HTTP_REQUEST_PARAMETER_PREFIX = '?';
	public static final String HTTP_REQUEST_COOKIE_SEPARATOR = ';';

	// Charset
	public static final String CHARSET_UTF8 = 'UTF-8';

	// Others
	public static final String BLANK = '';

	// HTTP Status Codes
	// Definition comments are taken from the following page
	// See https://httpstatuses.com

	// 3×× Redirection

	// The target resource has more than one representation, each with its own more specific identifier, 
	// and information about the alternatives is being provided so that the user (or user agent) can
	// select a preferred representation by redirecting its request to one or more of those identifiers.
	public static final Integer HTTP_STATUS_CODE_REDIRECTION_MULTIPLE_CHOICES = 300;

	// The target resource has been assigned a new permanent URI and any future references to this 
	// resource ought to use one of the enclosed URIs.
	public static final Integer HTTP_STATUS_CODE_REDIRECTION_MOVED_PERMANENTLY = 301;

	// The target resource resides temporarily under a different URI. 
	// Since the redirection might be altered on occasion, the client ought to continue to use 
	// the effective request URI for future requests.
	public static final Integer HTTP_STATUS_CODE_REDIRECTION_FOUND = 302;

	// The server is redirecting the user agent to a different resource, as indicated by a URI 
	// in the Location header field, which is intended to provide an indirect response to the 
	// original request.
	public static final Integer HTTP_STATUS_CODE_REDIRECTION_SEE_OTHER = 303;

	// A conditional GET or HEAD request has been received and would have resulted in a 200 
	// OK response if it were not for the fact that the condition evaluated to false.
	public static final Integer HTTP_STATUS_CODE_REDIRECTION_NOT_MODIFIED = 304;

	// The target resource resides temporarily under a different URI and the user agent 
	// MUST NOT change the request method if it performs an automatic redirection to that URI.
	public static final Integer HTTP_STATUS_CODE_REDIRECTION_TEMPORARY_REDIRECT = 307;

	// The target resource has been assigned a new permanent URI and any future references to 
	// this resource ought to use one of the enclosed URIs.
	public static final Integer HTTP_STATUS_CODE_REDIRECTION_PERMANENT_REDIRECT = 308;

	// 4xx Client errors

	// The server cannot or will not process the request due to something that is perceived to 
	// be a client error (e.g., malformed request syntax, invalid request message framing, or 
	// deceptive request routing).
	public static final Integer HTTP_STATUS_CODE_ERROR_BAD_REQUEST = 400;

	// The request has not been applied because it lacks valid authentication credentials 
	// for the target resource.
	public static final Integer HTTP_STATUS_CODE_ERROR_UNAUTHORIZED = 401;

	// The server understood the request but refuses to authorize it.
	public static final Integer HTTP_STATUS_CODE_ERROR_FORBIDDEN = 403;

	// The origin server did not find a current representation for the target resource or is 
	// not willing to disclose that one exists.
	public static final Integer HTTP_STATUS_CODE_ERROR_NOT_FOUND = 404;

	// The method received in the request-line is known by the origin server but not supported 
	// by the target resource.
	public static final Integer HTTP_STATUS_CODE_ERROR_METHOD_NOT_ALLOWED = 405;

	// The target resource does not have a current representation that would be acceptable to 
	// the user agent, according to the proactive negotiation header fields received in the request, 
	// and the server is unwilling to supply a default representation.
	public static final Integer HTTP_STATUS_CODE_ERROR_NOT_ACCEPTABLE = 406;

	// Similar to 401 Unauthorized, but it indicates that the client needs to authenticate itself in 
	// order to use a proxy.
	public static final Integer HTTP_STATUS_CODE_ERROR_PROXY_AUTHENTICATION_REQUIRED = 407;

	// The server did not receive a complete request message within the time that it was prepared 
	// to wait.
	public static final Integer HTTP_STATUS_CODE_ERROR_REQUEST_TIMEOUT = 408;

	// The request could not be completed due to a conflict with the current state of the target 
	// resource. This code is used in situations where the user might be able to resolve the conflict 
	// and resubmit the request.
	public static final Integer HTTP_STATUS_CODE_ERROR_CONFLICT = 409;

	// The target resource is no longer available at the origin server and that this condition is 
	// likely to be permanent.
	public static final Integer HTTP_STATUS_CODE_ERROR_GONE = 410;

	// The server refuses to accept the request without a defined Content-Length.
	public static final Integer HTTP_STATUS_CODE_ERROR_LENGTH_REQUIRED = 411;

	// One or more conditions given in the request header fields evaluated to false when tested 
	// on the server.
	public static final Integer HTTP_STATUS_CODE_ERROR_PRECONDITION_FAILED = 412;

	// The server is refusing to process a request because the request payload is larger than the 
	// server is willing or able to process.
	public static final Integer HTTP_STATUS_CODE_ERROR_REQUEST_ENTITY_TOO_LARGE = 413;

	// The server is refusing to service the request because the request-target is longer than the 
	// server is willing to interpret.
	public static final Integer HTTP_STATUS_CODE_ERROR_REQUEST_URI_TOO_LONG = 414;

	// The origin server is refusing to service the request because the payload is in a format not
	// supported by this method on the target resource.
	public static final Integer HTTP_STATUS_CODE_ERROR_UNSUPPORTED_MEDIA_TYPE = 415;

	// None of the ranges in the request's Range header field1 overlap the current extent of the 
	// selected resource or that the set of ranges requested has been rejected due to invalid ranges 
	// or an excessive request of small or overlapping ranges.
	public static final Integer HTTP_STATUS_CODE_ERROR_REQUESTED_RANGE_NOT_SATISFIABLE = 416;

	// The expectation given in the request's Expect header field could not be met by at least one 
	// of the inbound servers.
	public static final Integer HTTP_STATUS_CODE_ERROR_EXPECTATION_FAILED = 417;

	// Curl command
	private static final String CURL_COMMAND = 'curl';
	private static final String CURL_REQUEST_METHOD = ' -X ';
	private static final String CURL_HEADER = ' -H ';
	private static final String CURL_BODY = ' -d ';
	private static final String CURL_SPACE_SEPARATOR = ' ';
	private static final String CURL_QUOTE_SEPARATOR = '"';
	private static final String CURL_COLON_SEPARATOR = ':';

	/**
	 * Credentials Interface
	 */
	public interface ICredentials
	{
		String toEndpoint();
		void initRequest(IAbstractClientRequest request);
	}

	/** 
	 * Access Token Credential Interface
	 */
	public interface IAccessTokenCredentials extends ICredentials
	{
		String getTokenType();
		String getAccessToken();
		String getClientCertificateName();
		String getBaseURL();
	}

	/**
	 * Named Credentials Interface
	 */
	public interface INamedCredentials extends ICredentials
	{
		String getName();
	}

	/**
	 * AccessTokenCredentials
	 * 
	 * Wraps up the accessToken and the token type that is required to communicate with the API.
	 * Can optionally include the name of a client certificate
	 */
	public virtual class AccessTokenCredentials implements IAccessTokenCredentials
	{
		private String m_tokenType;
		private String m_accessToken;
		private String m_clientCertificateName;
		private String m_baseUrl;

		public AccessTokenCredentials(String tokenType, String accessToken)
		{
			if (tokenType == null) throw new ffhttp_SystemException(System.Label.ffhttp_NullTokenType);
			if (accessToken == null) throw new ffhttp_SystemException(System.Label.ffhttp_NullAccessToken);

			m_tokenType = tokenType;
			m_accessToken = accessToken;
		}

		public String toEndpoint()
		{
			return String.isNotBlank(m_baseUrl) ? m_baseUrl : '';
		}

		public void initRequest(IAbstractClientRequest request)
		{
			request.addExtraHeader(HTTP_HEADER_AUTHORIZATION, m_tokenType + ' ' + m_accessToken);
			request.setClientCertificateName(m_clientCertificateName);
		}

		/**
		 * Gets/Sets
		 */
		public String getTokenType()
		{
			return m_tokenType;
		}
		public AccessTokenCredentials setTokenType(String tokenType)
		{
			m_tokenType = tokenType;
			return this;
		}
		public String getAccessToken()
		{
			return m_accessToken;
		}
		public AccessTokenCredentials setAccessToken(String accessToken)
		{
			m_accessToken = accessToken;
			return this;
		}
		public String getClientCertificateName()
		{
			return m_clientCertificateName;
		}
		public AccessTokenCredentials setClientCertificateName(String clientCertificateName)
		{
			m_clientCertificateName = clientCertificateName;
			return this;
		}
		public String getBaseURL()
		{
			return m_baseUrl;
		}
		public AccessTokenCredentials setBaseURL(String baseUrl)
		{
			m_baseUrl = baseUrl;
			return this;
		}
	}

	/**
	 * NamedCredentials
	 * 
	 * Wraps up the name of the Named Credential that is required to communicate with the API.
	 */
	public virtual class NamedCredentials implements INamedCredentials
	{
		private String m_name;

		public NamedCredentials(String name)
		{
			if (name == null) throw new ffhttp_SystemException(System.Label.ffhttp_NullNamedCredentialName);

			m_name = name;
		}

		public String toEndpoint()
		{
			String endpoint = NAMED_CREDENTIALS_URL_PREFIX;
			endpoint += m_name;
			return endpoint;
		}

		public void initRequest(IAbstractClientRequest request)
		{
			// Everything is handled by the named credential so nothing to do here
		}

		public String getName()
		{
			return m_name;
		}
		public NamedCredentials setName(String name)
		{
			if (name == null) throw new ffhttp_SystemException(System.Label.ffhttp_NullNamedCredentialName);

			m_name = name;
			return this;
		}
	}

	/*
	 * AbstractClient Interface
	 */
	public interface IAbstractClient
	{
		Boolean getCredentialsRequired();
		IAbstractClient setCredentialsRequired(Boolean credentialsRequired);
		ICredentials getCredentials();
		IAbstractClient setCredentials(ICredentials credentials);
	}

	/**
	 * AbstractClient
	 *
	 * Abstract HTTP Client class.
	 *
	 * All requests made to a particular service have a reference to this so that the required 
	 * credentials are set in any callout.
	 */
	public abstract class AbstractClient implements IAbstractClient
	{
		private Boolean m_credentialsRequired = true;
		private ICredentials m_credentials;

		public Boolean getCredentialsRequired()
		{
			return m_credentialsRequired;
		}
		public IAbstractClient setCredentialsRequired(Boolean credentialsRequired)
		{
			m_credentialsRequired = credentialsRequired;
			return this;
		}
		public ICredentials getCredentials()
		{
			return m_credentials;
		}
		public IAbstractClient setCredentials(ICredentials credentials)
		{
			m_credentials = credentials;
			return this;
		}
	}

	/**
	 * AbstractClientRequest Interface
	 */
	public interface IAbstractClientRequest
	{
		IAbstractClientRequest addExtraHeader(String key, String value);
		void setClientCertificateName(String clientCertificateName);
		void setParamsAsJson(Boolean paramsAsJson);
		HttpRequest buildHttpRequest();
		Object execute();
		HttpResponse executeUnparsed();
		Object parse(HttpResponse response);
	}

	/**
	 * AbstractClientRequest
	 *
	 * Abstract class that all API requests extend. 
	 * This class deals with building the URL sent via HTTP to the particular service.
	 */
	public abstract class AbstractClientRequest implements IAbstractClientRequest
	{
		protected IAbstractClient abstractClient {get;set;}
		protected String requestMethod {get;set;}
		protected String endpoint {get;set;}
		protected ffhttp_IHttpContent httpContent {get;set;}
		protected ffhttp_IDeserialize responseDeserializer {get;set;}
	
		private Map<String, Object> m_params = new Map<String, Object>();

		private Map<String, String> m_extraHeaders = new Map<String, String>();

		// For a lot of callouts the parameters are added as a JSON body rather than in the URL.
		// This flag switches between the two approaches.
		private Boolean m_paramsAsJson = false;

		private String m_clientCertificateName = null;
		private Boolean returnsBlob = false;

		protected AbstractClientRequest()
		{}

		protected AbstractClientRequest(IAbstractClient abstractClient, String endpoint, String requestMethod,
			ffhttp_IHttpContent httpContent, ffhttp_IDeserialize responseDeserializer)
		{
			this.abstractClient = abstractClient;
			this.endpoint = endpoint;
			this.requestMethod = requestMethod;
			this.httpContent = httpContent;
			this.responseDeserializer = responseDeserializer;
		}

		/**
		 * Method to set returnsBlob based on the parameters provided.
		 */
		public AbstractClientRequest setReturnsBlob(Boolean returnsBlob) 
+		{
+			this.returnsBlob = returnsBlob;
+			return this;
+		}

		/**
		 * Method to build the HTTP Request based on the parameters provided.
		 */
		public HttpRequest buildHttpRequest()
		{
			if (abstractClient == null)
			{
				throw new ffhttp_SystemException(System.Label.ffhttp_AbstractClientNotSet);
			}

			if (abstractClient.getCredentialsRequired() != null && abstractClient.getCredentialsRequired() == true && abstractClient.getCredentials() == null)
			{
				throw new ffhttp_SystemException(System.Label.ffhttp_AbstractClientCredentialsNotSet);
			}

			if (m_paramsAsJson && httpContent != null && !m_params.isEmpty())
			{
				throw new ffhttp_SystemException(System.Label.ffhttp_InvalidStateJsonAndRequestBody);
			}

			HttpRequest request = new HttpRequest();

			ICredentials clientCredentials = abstractClient.getCredentials();
			if (clientCredentials != null)
			{
				clientCredentials.initRequest(this);
			}

			request.setEndpoint(createEndpoint());
			request.setMethod(this.requestMethod);

			if (httpContent != null)
			{
				Object body = httpContent.getHttpContent();
				if (body instanceOf Blob)
				{
					Blob bodyBlob = (Blob) body;
					request.setBodyAsBlob(bodyBlob);
					request.setHeader(HTTP_HEADER_CONTENT_LENGTH, String.valueOf(bodyBlob.size()));
				}
				else
				{
					String bodyStr = String.valueof(body);
					request.setBody(bodyStr);
					request.setHeader(HTTP_HEADER_CONTENT_LENGTH, String.valueOf(bodyStr.length()));
				}

				String httpContentType = httpContent.getHttpContentType();
				request.setHeader(HTTP_HEADER_CONTENT_TYPE, httpContentType);
			}
			else if (m_paramsAsJson)
			{
				String bodyStr = JSON.serialize(m_params);
				request.setBody(bodyStr);
				request.setHeader(HTTP_HEADER_CONTENT_LENGTH, String.valueOf(bodyStr.length()));
				request.setHeader(HTTP_HEADER_CONTENT_TYPE, CONTENT_TYPE_JSON);
			}
			else
			{
				// Shouldn't need this but some of the Google API calls expect a content length in the header
				// even though they expect nothing in the body of the call e.g. Files.Trash call.
				request.setHeader(HTTP_HEADER_CONTENT_LENGTH, String.valueOf(0));
			}

			if (String.isNotBlank(m_clientCertificateName))
			{
				request.setClientCertificateName(m_clientCertificateName);
			}

			addExtraHeaders(request);

			return request;
		}

		/**
		 * Creates the endpoint taking into account the endpoint, urlParam and parameters provided.
		 */
		private String createEndpoint()
		{
			String retval = '';

			ICredentials credentials = abstractClient.getCredentials();
			if (credentials != null)
			{
				retval = credentials.toEndpoint();
			}

			retval += this.endpoint;

			if (!m_paramsAsJson)
			{
				Set<String> keys = m_params.keySet();
				if (keys.size() > 0)
				{
					retval += HTTP_REQUEST_PARAMETER_PREFIX;

					for (String key: keys)
					{
						String param = String.valueOf(m_params.get(key));
						if (param != null)
						{
							retval += key;
							retval += HTTP_REQUEST_PARAMETER_SEPARATOR;
							retval += EncodingUtil.urlEncode(param, CHARSET_UTF8);
							retval += HTTP_REQUEST_ENDPOINT_SEPARATOR;
						}
					}
				}

				if (retval.endsWith(HTTP_REQUEST_ENDPOINT_SEPARATOR))
				{
					retval = retval.substring(0, retval.length() - 1);
				}
			}

			return retval;
		}

		/**
		 * Adds extra HTTP request headers.
		 * Each of the headers is checked before being added to make sure that it is not one of the standard headers.
		 */
		private void addExtraHeaders(HttpRequest request)
		{
			for (String key: m_extraHeaders.keySet())
			{
				if (key == HTTP_HEADER_CONTENT_LENGTH || key == HTTP_HEADER_CONTENT_TYPE)
				{
					throw new ffhttp_SystemException(System.Label.ffhttp_InvalidStateAddingProtectedHeader);
				}

				String value = String.valueOf(m_extraHeaders.get(key));
				request.setHeader(key, value);
			}
		}

		public HttpResponse executeUnparsed()
		{
			HttpRequest request = buildHttpRequest();

			validateRequest(request);

			HttpResponse response = new Http().send(request);
			Integer statusCode = response.getStatusCode();
			String status = response.getStatus();
			if (statusCode >= HTTP_STATUS_CODE_ERROR_BAD_REQUEST)
			{
				throw new ffhttp_AppException(statusCode, status);
			}

			if (statusCode >= HTTP_STATUS_CODE_REDIRECTION_MULTIPLE_CHOICES && statusCode < HTTP_STATUS_CODE_ERROR_BAD_REQUEST)
			{
				handleRedirection(response);
			}

			return response;
		}

		public Object execute()
		{
			HttpResponse response = executeUnparsed();
			return (returnsBlob) ? response.getBodyAsBlob() : parse(response);
		}

		public Object parse(HttpResponse response)
		{
			return responseDeserializer == null ? null : responseDeserializer.deserialize(response.getBody());
		}

		public IAbstractClientRequest addExtraHeader(String key, String value)
		{
			m_extraHeaders.put(key, value);
			return this;
		}

		/**
		 * Simple helper to return this command as a curl command that can be used for debugging.
		 */
		public String toCurlCommand()
		{
			HttpRequest request = buildHttpRequest();

			List<String> curlHeaders = new List<String>();

			for (String header: m_extraHeaders.keySet())
			{
				String value = String.valueOf(m_extraHeaders.get(header));
				curlHeaders.add(CURL_QUOTE_SEPARATOR + header + CURL_COLON_SEPARATOR + value + CURL_QUOTE_SEPARATOR);
			}

			String contentLength = request.getHeader(HTTP_HEADER_CONTENT_LENGTH);
			if (String.isNotBlank(contentLength))
			{
				curlHeaders.add(CURL_QUOTE_SEPARATOR + HTTP_HEADER_CONTENT_LENGTH + CURL_COLON_SEPARATOR + contentLength + CURL_QUOTE_SEPARATOR);
			}

			String contentType = request.getHeader(HTTP_HEADER_CONTENT_TYPE);
			if (String.isNotBlank(contentType))
			{
				curlHeaders.add(CURL_QUOTE_SEPARATOR + HTTP_HEADER_CONTENT_TYPE + CURL_COLON_SEPARATOR + contentType + CURL_QUOTE_SEPARATOR);
			}

			String curlHeadersStr = CURL_HEADER + String.join(curlHeaders, CURL_HEADER);

			String requestBody = request.getBody();

			String curlBody = BLANK;
			if (String.isNotBlank(requestBody))
			{
				String escapedRequestBody = requestBody.escapeJava();
				curlBody = CURL_BODY + CURL_QUOTE_SEPARATOR + escapedRequestBody + CURL_QUOTE_SEPARATOR;
			}

			return CURL_COMMAND + CURL_REQUEST_METHOD + requestMethod + CURL_SPACE_SEPARATOR + createEndpoint() + curlHeadersStr + curlBody;
		}

		public void setClientCertificateName(String clientCertificateName)
		{
			m_clientCertificateName = clientCertificateName;
		}

		public void setParamsAsJson(Boolean paramsAsJson)
		{
			m_paramsAsJson = paramsAsJson;
		}

		protected virtual void validateRequest(HttpRequest request)
		{}

		protected virtual void handleRedirection(HttpResponse response)
		{
			throw new ffhttp_SystemException(System.Label.ffhttp_UnhandledRedirection);
		}

		@TestVisible
		protected Boolean getParam(String name, Boolean defaultValue)
		{
			Boolean param = (Boolean) getParamObj(name);
			if (param == null)
			{
				return defaultValue;
			}
			return param;
		}

		@TestVisible
		protected Integer getParam(String name, Integer defaultValue)
		{
			Integer param = (Integer) getParamObj(name);
			if (param == null)
			{
				return defaultValue;
			}
			return param;
		}

		@TestVisible
		protected Long getParam(String name, Long defaultValue)
		{
			Long param = (Long) getParamObj(name);
			if (param == null)
			{
				return defaultValue;
			}
			return param;
		}

		@TestVisible
		protected String getParam(String name, String defaultValue)
		{
			String param = (String) getParamObj(name);
			if (param == null)
			{
				return defaultValue;
			}
			return param;
		}

		@TestVisible
		protected Object getParamObj(String name)
		{
			return m_params.get(name);
		}

		@TestVisible
		protected AbstractClientRequest addParam(String name, Object param)
		{
			m_params.put(name, param);
			return this;
		}
	}
}
