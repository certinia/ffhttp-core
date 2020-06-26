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
 * ffhttp_MultipartMimeAttachment
 *
 * Creates multipart attachments to be sent in a HTTP callout
 */
public class ffhttp_MultipartMimeAttachment implements ffhttp_IHttpContent
{
    private static final String BOUNDARY = '1ff13444ed8140c7a32fc4e6451aa76d';
    private static final String HTTP_CONTENT_TYPE = 'multipart/form-data; charset="UTF-8"; boundary="' + BOUNDARY + '"';

    private static final String CONTENT_DISPOSITION_PREFIX = ffhttp_Client.HTTP_HEADER_CONTENT_DISPOSITION + ': form-data; name="';
    private static final String CONTENT_DISPOSITION_FILENAME = '"; filename="';

    private static final String EMPTY = '';
    private static final String COLON = ':';
    private static final String DOUBLE_QUOTE = '"';
    private static final String SPACE = ' ';

    private static final String LF = '\n';
    private static final String CR = '\r';
    private static final String CRLF = CR + LF;
    private static final String CRLFCRLF = CRLF + CRLF;

    private static final String FILE_64_ENDING_OK = '0K';
    private static final String FILE_64_ENDING_N = 'N';

    private static final String ENDING_EQUALS = '=';
    private static final String ENDING_DOUBLE_EQUALS = '==';

    private static final String BOUNDARY_PREFIX = '--';
    private static final String BOUNDARY_SUFFIX = '--';

    private String httpContent = EMPTY;
    private String currentEndingType = EMPTY;

    public String getHttpContentType()
    {
        return HTTP_CONTENT_TYPE;
    }

    public Object getHttpContent()
    {
        return EncodingUtil.base64Decode(httpContent);
    }

    public void writeBoundary() 
    {
        String value = BOUNDARY_PREFIX + BOUNDARY + CRLF;
        Blob valueBlob = Blob.valueOf(value);

        httpContent += EncodingUtil.base64Encode(valueBlob);
    }

    public void writeEndBoundary() 
    {
        String value = EMPTY;

        if (currentEndingType == CR) 
        {
            value += LF;
        } 
        else if (currentEndingType == EMPTY) 
        {
            value += CRLF;
        }
        
        value += BOUNDARY_PREFIX + BOUNDARY + BOUNDARY_SUFFIX;

        Blob valueBlob = Blob.valueOf(value);

        httpContent += EncodingUtil.base64Encode(valueBlob);
    }

    public void writeFile(String key, String value, String mimeType, Blob fileBlob) 
    {
        httpContent += createPaddedBase64EncodedString(CONTENT_DISPOSITION_PREFIX + key + CONTENT_DISPOSITION_FILENAME + value + DOUBLE_QUOTE, CRLF);
        httpContent += createPaddedBase64EncodedString(ffhttp_Client.HTTP_HEADER_CONTENT_TYPE + COLON + SPACE + mimeType, CRLFCRLF);

        String file64 = EncodingUtil.base64Encode(fileBlob);
        Integer file64Length = file64.length();
        String file64Ending = file64.substring(file64Length - 3, file64Length);

        currentEndingType = EMPTY;
        if (file64Ending.endsWith(ENDING_DOUBLE_EQUALS)) 
        {
            file64Ending = file64Ending.substring(0, 1) + FILE_64_ENDING_OK;
            file64 = file64.substring(0, file64Length - 3) + file64Ending;
            currentEndingType = CRLF;
        } 
        else if (file64Ending.endsWith(ENDING_EQUALS)) 
        {
            file64Ending = file64Ending.substring(0, 2) + FILE_64_ENDING_N;
            file64 = file64.substring(0, file64Length - 3) + file64Ending;
            currentEndingType = CR;
        }

        httpContent += file64;
    }

    public void writeBodyParameter(String key, String value) 
    {
        httpContent += createPaddedBase64EncodedString(CONTENT_DISPOSITION_PREFIX + key + DOUBLE_QUOTE, CRLFCRLF);
        httpContent += createPaddedBase64EncodedString(value, CRLF);
    }

    private String createPaddedBase64EncodedString(String value, String lineBreaks)
    {
        String valueCrLf = value + lineBreaks;
        Blob valueCrLfBlob = Blob.valueOf(valueCrLf);
        String valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
        return addPadding(value, valueCrLf64, lineBreaks);
    }

    private String addPadding(String value, String valueCrLf64, String lineBreaks) 
    {
        String valueCrLf = EMPTY;
        Blob valueCrLfBlob = null;

        while (valueCrLf64.endsWith(ENDING_EQUALS)) 
        {
            value += SPACE;
            valueCrLf = value + lineBreaks;
            valueCrLfBlob = Blob.valueOf(valueCrLf);
            valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
        }

        return valueCrLf64;
    }
}