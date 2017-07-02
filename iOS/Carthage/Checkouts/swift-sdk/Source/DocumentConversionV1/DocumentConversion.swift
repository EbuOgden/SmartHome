/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import RestKit

/**
 The IBM Watson™ Document Conversion Service converts a single HTML, PDF, or Microsoft Word™ 
 document. The input document is transformed into normalized HTML, plain text, or a set of 
 JSON-formatted Answer units that can be used with other Watson services, like the
 Watson Retrieve and Rank Service.
 */
public class DocumentConversion {
    
    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/document-conversion/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let credentials: Credentials
    private let version: String
    private let domain = "com.ibm.watson.developer-cloud.DocumentConversionV1"
    
    /**
     Create a `DocumentConversion` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String, version: String) {
        credentials = .basicAuthentication(username: username, password: password)
        self.version = version
    }
    
    /**
     If the given data represents an error returned by the Document Conversion service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: Data) -> NSError? {
        do {
            let json = try JSON(data: data)
            if let errCode = try? json.getInt(at: "code") {
                let code = errCode
                let message = try json.getString(at: "error")
                let userInfo = [NSLocalizedFailureReasonErrorKey: message]
                return NSError(domain: domain, code: code, userInfo: userInfo)
            } else if let errCode = try? json.getString(at: "code") {
                let code = Int(errCode)!
                let message = try json.getString(at: "error")
                let userInfo = [NSLocalizedFailureReasonErrorKey: message]
                return NSError(domain: domain, code: code, userInfo: userInfo)
            }
            return nil
        } catch {
            return nil
        }
    }
    
    /**
     Convert a document to answer units, HTML, or text.
     
     - parameter document: The document to convert.
     - parameter withConfigurationFile: A configuration file that identifies the output type and
        optionally includes information to define tags and structure in the converted output.
        For more information about the configuration file, refer to the documentation:
        http://www.ibm.com/watson/developercloud/doc/document-conversion/customizing.shtml
     - parameter fileType: Explicit type of the file you are converting, if the service cannot
        detect or you don't want the service to auto detect the file type.
     - parameter failure:  A function executed if the call fails
     - parameter success:  A function executed with the response String
     */
    public func convertDocument(
        _ document: URL,
        withConfigurationFile config: URL,
        fileType: FileType? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (String) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(config, withName: "config")
        multipartFormData.append(document, withName: "file")
        if let type = fileType?.rawValue.data(using: String.Encoding.utf8) {
            multipartFormData.append(type, withName: "type")
        }
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/convert_document",
            credentials: credentials,
            headerParameters: defaultHeaders,
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseString(dataToError: dataToError) { response in
            switch response.result {
            case .success(let result): success(result)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Deserializes a response string to a ConversationResponse object. Only works with AnswerUnits
     as that's the only response type from the service that returns a JSON object. The other two
     options return plain text
     
     - parameter string: the String to attempt to convert to a ConversationResponse object
     
     - retuns: A ConversationReponse object populated with the input's data
     */
    public func deserializeAnswerUnits(string: String) throws -> ConversationResponse {
        let json = try JSON(string: string)
        let answerUnits = try ConversationResponse(json: json)
        return answerUnits
    }
    
    /**
     Write service config parameters to a temporary JSON file that can be uploaded. This creates the
     most basic configuration file possible. For information on creating your own, with greater
     functionality, see: 
     http://www.ibm.com/watson/developercloud/doc/document-conversion/customizing.shtml
     
     - parameter type: The return type of the service you wish to recieve.
     
     - returns: The URL of a JSON file that includes the given parameters.
     */
    public func writeConfig(type: ReturnType) throws -> URL {
        // construct JSON dictionary
        var json = [String: Any]()
        json["conversion_target"] = type.rawValue
        
        // create a globally unique file name in a temporary directory
        let suffix = "DocumentConversionConfiguration.json"
        let fileName = "\(UUID().uuidString)_\(suffix)"
        let directoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = directoryURL.appendingPathComponent(fileName)!
        
        // save JSON dictionary to file
        do {
            let data = try JSON(dictionary: json).serialize()
            try data.write(to: fileURL, options: .atomic)
        } catch {
            let message = "Unable to create config file"
            let userInfo = [NSLocalizedFailureReasonErrorKey: message]
            throw NSError(domain: domain, code: 0, userInfo: userInfo)
        }
        
        return fileURL
    }
    
}

/**
 Enum for supported return types from the DocumentConversion service
 */
public enum ReturnType: String {
    
    /// Constant for AnswerUnits
    case answerUnits = "ANSWER_UNITS"
    
    /// Constant for HTML
    case html = "NORMALIZED_HTML"
    
    /// Constant for Text
    case text = "NORMALIZED_TEXT"
}
