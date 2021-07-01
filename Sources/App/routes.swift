import Vapor

func routes(_ app: Application) throws {
    let apiDocsController = APIDocsController(app: app)
    let homeController = HomeController(app: app)
    let healthController = HealthController(app: app)

    app.get("", use: homeController.view)
        .summary("Homepage")
        .description("Homepage for Vapor example app")
        .tags("Home")

    app.get("health", use: healthController.view)
        .summary("Health")
        .description("Get health of application")
        .tags("Health")

    app.get("docs", use: apiDocsController.view)
        .summary("View API Documentation")
        .description("API Documentation is served using the Redoc web app.")
        .tags("Documentation")

    app.get("docs", "openapi.yml", use: apiDocsController.show)
        .summary("Download API Documentation")
        .description("Retrieve the OpenAPI documentation as a YAML file.")
        .tags("Documentation")

}           