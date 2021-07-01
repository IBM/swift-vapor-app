import Vapor
import VaporOpenAPI

final class HomeController {

    let app: Application

    init(app: Application) {
        self.app = app
    }

    func view(_ req: TypedRequest<ViewContext>) -> EventLoopFuture<View> {
        return req.view.render("index")
    }

}

extension HomeController {
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