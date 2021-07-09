import Vapor
import Swiftgger


final class HealthResponse: Content {
    let status: String
    
    init(status: String) {
        self.status = status
    }
}

func routes(_ app: Application) throws {

    // Swagger docs

    let openAPIBuilder = OpenAPIBuilder(
        title: "Vapor Example API",
        version: "1.0.0",
        description: "API for example Vapor application"
    ).add(APIController(name: "Health", description:"", actions: [
        APIAction(method: .get, route: "/health",
            summary: "Health",
            description: "Get health of application",
            responses: [
                APIResponse(code: "200", description: "OK"),
                APIResponse(code: "404", description: "Not found")
            ]
        )
    ]))

    let document = openAPIBuilder.built()
    let jsonEncoder = JSONEncoder()
    let jsonData = try jsonEncoder.encode(document)
    let json = String(data: jsonData, encoding: String.Encoding.utf8)


    // Routes

    app.get("") { req in
        return req.view.render("index")
    }

    app.get("health") { req in 
        return HealthResponse(status: "UP")
    }

    app.get("docs", "openapi.json") { req in 
        return json!
    }

    app.get("docs") { req in 
        return req.view.render("swagger")
    }
}       