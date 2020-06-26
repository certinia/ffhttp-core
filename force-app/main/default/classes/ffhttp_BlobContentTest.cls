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
 * ffhttp_BlobContentTest
 *
 * Test class for ffhttp_BlobContent.
 */
@isTest
private class ffhttp_BlobContentTest
{
	static testMethod void constructor_initializedCorrectly()
	{
		// Given
		Blob b = Blob.valueOf('Testing');

		// When
		ffhttp_BlobContent content = new ffhttp_BlobContent(b, 'application/json');

		// Then
		System.assertEquals(content.getHttpContent(), b);
		System.assertEquals(content.getHttpContentType(), 'application/json');
	}

	static testMethod void constructor_throwsException_forNullBlob()
	{
		try
		{
			// Given
			new ffhttp_BlobContent(null, 'application/json');
			System.assert(false, 'ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			// Then
			System.assertEquals(ex.getMessage(), 'Blob cannot be null');
		}
	}

	/**
	 * Test that if you try and create a BlobContent instance with no content type an exception is thrown
	 */
	static testMethod void constructor_throwsException_forNullContentType()
	{
		try
		{
			// Given
			Blob b = Blob.valueOf('Testing');
			new ffhttp_BlobContent(b, null);
			System.assert(false, 'ffhttp_SystemException was not thrown');
		}
		catch (ffhttp_SystemException ex)
		{
			// Then
			System.assertEquals(ex.getMessage(), 'ContentType cannot be null');
		}
	}
}
