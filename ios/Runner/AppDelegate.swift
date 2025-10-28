import UIKit
import Flutter
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var audioEngine: AVAudioEngine?
  private var playerNode: AVAudioPlayerNode?
  private var pitchNode: AVAudioUnitTimePitch?
  private var audioFile: AVAudioFile?
  
  // NOVO: Canal para enviar eventos de volta ao Dart (ex: música terminou)
  private var pitchChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    pitchChannel = FlutterMethodChannel(
      name: "app.chula/audio_pitch",
      binaryMessenger: controller.binaryMessenger
    )
    
    pitchChannel!.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else {
        result(FlutterError(code: "UNAVAILABLE", message: "Instance unavailable", details: nil))
        return
      }
      
      switch call.method {
      case "checkPitchSupport":
        result(true)
        
      case "initializeNativePlayer":
        guard let args = call.arguments as? [String: Any],
              let path = args["path"] as? String,
              let isAsset = args["isAsset"] as? Bool else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments for initialize", details: nil))
          return
        }
        self.initializePlayer(path: path, isAsset: isAsset, result: result)
        
      case "setPitch":
        guard let args = call.arguments as? [String: Any],
              let pitch = args["pitch"] as? Double else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid pitch value", details: nil))
          return
        }
        self.setPitch(pitch: Float(pitch))
        result(true)
        
      case "setPlaybackRate":
        guard let args = call.arguments as? [String: Any],
              let rate = args["rate"] as? Double else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid rate value", details: nil))
          return
        }
        self.setPlaybackRate(rate: Float(rate))
        result(true)
        
      case "playNative":
        self.playNative()
        result(true)
        
      case "pauseNative":
        self.pauseNative()
        result(true)
        
      case "stopNative":
        self.stopNative()
        result(true)
        
      // NOVO: Retorna o tempo atual em segundos
      case "getCurrentTime":
        result(self.getCurrentTime())
        
      // NOVO: Implementa o Seek
      case "seekNative":
          guard let args = call.arguments as? [String: Any],
                let time = args["time"] as? Double else {
              result(FlutterError(code: "INVALID_ARGS", message: "Invalid time value for seek", details: nil))
              return
          }
          self.seekNative(to: time)
          result(true)

      // NOVO: Define o volume
      case "setVolume":
          guard let args = call.arguments as? [String: Any],
                let volume = args["volume"] as? Double else {
              result(FlutterError(code: "INVALID_ARGS", message: "Invalid volume value", details: nil))
              return
          }
          self.setVolume(volume: Float(volume))
          result(true)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // ALTERADO: A função agora lida com assets E arquivos
  private func initializePlayer(path: String, isAsset: Bool, result: @escaping FlutterResult) {
    do {
      // Cleanup anterior
      stopNative()
      audioEngine = nil
      playerNode = nil
      pitchNode = nil
      
      // Configura audio session
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.playback, mode: .default)
      try audioSession.setActive(true)
      
      // ALTERADO: Lógica para pegar a URL do arquivo
      let url: URL
      if isAsset {
        let key = FlutterDartProject.lookupKey(forAsset: path)
        guard let assetPath = Bundle.main.path(forResource: key, ofType: nil) else {
          result(FlutterError(code: "FILE_NOT_FOUND", message: "Asset file not found", details: path))
          return
        }
        url = URL(fileURLWithPath: assetPath)
      } else {
        url = URL(fileURLWithPath: path)
      }
      
      audioFile = try AVAudioFile(forReading: url)
      
      // Configura o audio engine
      audioEngine = AVAudioEngine()
      playerNode = AVAudioPlayerNode()
      pitchNode = AVAudioUnitTimePitch()
      
      guard let engine = audioEngine,
            let player = playerNode,
            let pitch = pitchNode,
            let file = audioFile else {
        result(FlutterError(code: "INIT_FAILED", message: "Failed to initialize audio components", details: nil))
        return
      }
      
      engine.attach(player)
      engine.attach(pitch)
      
      // Conecta: player -> pitch -> output
      let format = file.processingFormat
      engine.connect(player, to: pitch, format: format)
      engine.connect(pitch, to: engine.mainMixerNode, format: format)
      
      // Agenda o buffer para tocar
      player.scheduleFile(file, at: nil) {
        // Callback quando a música termina
        DispatchQueue.main.async {
            // O timer do Dart (getCurrentTime) vai cuidar de detectar o fim,
            // mas poderíamos enviar um evento de volta se quiséssemos:
            // self.pitchChannel?.invokeMethod("playbackDidEnd", arguments: nil)
        }
      }
      
      try engine.start()
      
      let duration = Double(file.length) / file.processingFormat.sampleRate
      result(duration)
      
    } catch {
      result(FlutterError(code: "INIT_ERROR", message: error.localizedDescription, details: nil))
    }
  }
  
  private func setPitch(pitch: Float) {
    let cents = 1200 * log2(pitch)
    pitchNode?.pitch = cents
  }
  
  private func setPlaybackRate(rate: Float) {
    pitchNode?.rate = rate
  }
    
  private func setVolume(volume: Float) {
      playerNode?.volume = volume
  }
  
  private func getCurrentTime() -> Double {
      guard let playerNode = playerNode,
            let nodeTime = playerNode.lastRenderTime,
            let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else {
          return 0.0
      }
      
      let currentTime = Double(playerTime.sampleTime) / playerTime.sampleRate
      return currentTime
  }

  private func seekNative(to time: Double) {
      guard let playerNode = playerNode,
            let audioFile = audioFile else {
          return
      }
      
      let sampleRate = audioFile.processingFormat.sampleRate
      let startSample = AVAudioFramePosition(time * sampleRate)
      let frameCount = AVAudioFrameCount(audioFile.length - startSample)
      
      guard frameCount > 0 else {
          print("Seek time is out of bounds")
          return
      }
      
      playerNode.stop()
      playerNode.scheduleSegment(
          audioFile,
          startingFrame: startSample,
          frameCount: frameCount,
          at: nil,
          completionHandler: {
              // Callback quando o segmento termina
          }
      )
      
      if audioEngine?.isRunning ?? false {
          playerNode.play()
      }
  }

  
  private func playNative() {
    if !(audioEngine?.isRunning ?? false) {
        do {
            try audioEngine?.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }
    playerNode?.play()
  }
  
  private func pauseNative() {
    playerNode?.pause()
  }
  
  private func stopNative() {
    playerNode?.stop()
    audioEngine?.stop()
  }
}
