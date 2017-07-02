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

/** A response produced by the Discovery service to analyze the input provided. */
public struct QueryResponse: JSONDecodable {
    
    /// Number of matching results.
    public let matchingResults: Int?
    
    /// Results returned by the Discovery service.
    public let results: [Result]?
    
    /// Aggregations returned by the Discovery service.
    public let aggregations: [Aggregation]?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a `QueryResponse` model from JSON.
    public init(json: JSON) throws {
        matchingResults = try? json.getInt(at: "matching_results")
        results = try? json.decodedArray(at: "results", type: Result.self)
        aggregations = try? json.decodedArray(at: "aggregations", type: Aggregation.self)
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize a 'QueryResponse' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
