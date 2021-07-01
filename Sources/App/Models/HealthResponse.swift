import Vapor
import Sampleable
import OpenAPIKit
import OpenAPIReflection

struct HealthResponse: Codable {
    let status: String
    
    init(status: String) {
        self.status = status
    }
}

extension HealthResponse: ResponseEncodable {
    func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
        return request.eventLoop
            .makeSucceededFuture(())
            .flatMapThrowing {
                try Response(body: .init(data: JSONEncoder().encode(self)))
        }
    }
}

extension HealthResponse: Sampleable {
    static var sample: HealthResponse {
        .init(status: "UP")
    }
}

extension HealthResponse: OpenAPIEncodedSchemaType {
    static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        return try genericOpenAPISchemaGuess(using: encoder)
    }
}