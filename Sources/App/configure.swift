import Vapor
import Leaf
    
public func configure(_ app: Application) throws {

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)

    app.middleware.use(cors)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Disallow reconfiguration of Leaf when testing begins
    if LeafEngine.rootDirectory == nil {
        if !app.environment.isRelease {
            LeafRenderer.Option.caching = .bypass
        }

        let detected = LeafEngine.rootDirectory ?? app.directory.viewsDirectory
        LeafEngine.rootDirectory = detected

        LeafEngine.sources = .singleSource(NIOLeafFiles(fileio: app.fileio,
                                                        limits: .default,
                                                        sandboxDirectory: detected,
                                                        viewDirectory: detected,
                                                        defaultExtension: "html"))
        
        app.views.use(.leaf)
    }
    
    try routes(app)

}
