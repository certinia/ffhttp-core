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
 * ffhttp_AbstractFormDataSerializable 
 * 
 * Abstract class to allow the custom serialisation of form encoded objects.
 * This class extends IHttpContent which allows these objects to be sent in HTTP requests.
 */
public abstract class ffhttp_AbstractFormDataSerializable implements ffhttp_IHttpContent
{
	private List < String > m_parameters = new List < String > ();

	protected void addParameterIfNotEmpty(String parameter, String value, Boolean encode)
	{
		if (String.isNotBlank(value))
		{
			String localValue = value;
			if (encode)
			{
				localValue = EncodingUtil.urlEncode(value, ffhttp_Client.CHARSET_UTF8);
			}

			String parameterAndValue = parameter + ffhttp_Client.HTTP_REQUEST_PARAMETER_SEPARATOR + localValue;
			m_parameters.add(parameterAndValue);
		}
	}

	/**
	 * ffhttp_IHttpContent implementation
	 */
	public String getHttpContentType()
	{
		return ffhttp_Client.CONTENT_TYPE_WWW_FORM_ENCODED;
	}

	public Object getHttpContent()
	{
		return String.join(m_parameters, ffhttp_Client.HTTP_REQUEST_ENDPOINT_SEPARATOR);
	}
}
