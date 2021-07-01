import Vapor
import VaporOpenAPI
import Foundation
import Yams

final class APIDocsController {

    let app: Application

    init(app: Application) {
        self.app = app
    }

    func view(_ req: TypedRequest<ViewContext>) -> EventLoopFuture<View> {
        return req.view.render("swagger")
    }

    func show(_ req: TypedRequest<ShowContext>) throws -> EventLoopFuture<Response> {
        let jsonEncoder = JSONEncoder()
        if #available(macOS 10.12, *) {
            jsonEncoder.dateEncodingStrategy = .iso8601
            jsonEncoder.outputFormatting = .sortedKeys
        }

        #if os(Linux)
        jsonEncoder.dateEncodingStrategy = .iso8601
        jsonEncoder.outputFormatting = .sortedKeys
        #endif

        let info = OpenAPI.Document.Info(
            title: "Swift Vapor App API",
            description:
            ###"""
            ## API Documentation for example Swift Vapor App
            """###,
            version: "1.0"
        )

        let servers = [
            OpenAPI.Server(url: URL(string: "http://\(app.http.server.configuration.hostname):\(app.http.server.configuration.port)")!)
        ]

        let paths = try app.routes.openAPIPathItems(using: jsonEncoder)

        let document = OpenAPI.Document(
            info: info,
            servers: servers,
            paths: paths,
            components: .noComponents,
            security: []
        )

        return req
            .response
            .success
            .encode(try YAMLEncoder().encode(document))
    }
}

extension APIDocsController {
    struct ShowContext: RouteContext {
        typealias RequestBodyType = EmptyRequestBody

        static let defaultContentType: HTTPMediaType? = nil
        static let shared = Self()

        let success: ResponseContext<String> = .init { response in
            response.headers.contentType = .init(type: "application", subType: "x-yaml")
            response.status = .ok
        }
    }

    struct ViewContext: RouteContext {
        typealias RequestBodyType = EmptyRequestBody

        static let defaultContentType: HTTPMediaType? = nil
        static let shared = Self()

        let success: ResponseContext<String> = .init { response in
            response.headers.contentType = .html
            response.status = .ok
        }
    }
}