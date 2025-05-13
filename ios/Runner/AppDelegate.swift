import UIKit
import Flutter
import GoogleMaps
import flutter_dotenv

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Carrega as variáveis do .env
    try? DotEnv().load()

    // Obtém a chave da API do .env
    let apiKey = DotEnv().get("GOOGLE_MAPS_API_KEY") ?? "CHAVE_NAO_ENCONTRADA"
    GMSServices.provideAPIKey(apiKey)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
