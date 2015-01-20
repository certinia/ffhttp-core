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
 * ffhttp_AppException
 *
 * Extension of exception that wraps up a status code (HTTP Error Code) and associated error (status).
 */
public with sharing class ffhttp_AppException extends Exception 
{
	public static final Integer ERROR_HTTP_BAD_REQUEST = 400;	
	public static final Integer ERROR_HTTP_UNAUTHORIZED = 401;
	public static final Integer ERROR_HTTP_PAYMENT_REQUIRED = 402; 
	public static final Integer ERROR_HTTP_FORBIDDEN = 403;
	public static final Integer ERROR_HTTP_NOT_FOUND = 404;
	public static final Integer ERROR_HTTP_METHOD_NOT_ALLOWED = 405;
	public static final Integer ERROR_HTTP_NOT_ACCEPTABLE = 406;
	public static final Integer ERROR_HTTP_PROXY_AUTHENTICATION_REQUIRED = 407;
	public static final Integer ERROR_HTTP_REQUEST_TIMEOUT = 408;
	public static final Integer ERROR_HTTP_CONFLICT = 409;
	public static final Integer ERROR_HTTP_GONE = 410;
	public static final Integer ERROR_HTTP_LENGTH_REQUIRED = 411;
	public static final Integer ERROR_HTTP_PRECONDITION_FAILED = 412;
	public static final Integer ERROR_HTTP_REQUEST_ENTITY_TOO_LARGE = 413;
	public static final Integer ERROR_HTTP_REQUEST_URI_TOO_LONG = 414;
	public static final Integer ERROR_HTTP_UNSUPPORTED_MEDIA_TYPE = 415;
	public static final Integer ERROR_HTTP_REQUESTED_RANGE_NOT_SATISFIABLE = 416;
	public static final Integer ERROR_HTTP_EXPECTATION_FAILED = 417;
		
	private Integer m_statusCode;
	private String m_status;
	
	public ffhttp_AppException(Integer statusCode, String status) 
	{
		m_statusCode = statusCode;
		m_status = status;
	}
	
	public override String getMessage() 
	{
		return m_status;
	}
	
	public Integer getStatusCode() 
	{
		return m_statusCode;
	}
	
	public String getStatus() 
	{
		return m_status;
	}
}