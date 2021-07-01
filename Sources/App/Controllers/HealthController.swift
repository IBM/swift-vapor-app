import Vapor
import VaporOpenAPI

final class HealthController {

    let app: Application

    init(app: Application) {
        self.app = app
    }

    func view(_ req: TypedRequest<ViewContext>) -> EventLoopFuture<Response> {
        return req.response.success.encode(.init(status: "UP"))
    }

}

extension HealthController {
    struct ViewContext: RouteContext {
        typealias RequestBodyType = EmptyRequestBody

        static let defaultContentType: HTTPMediaType? = nil
        static let shared = Self()

        let success: ResponseContext<HealthResponse> = .init { response in
            response.headers.contentType = .json
            response.status = .ok
        }
    }
}