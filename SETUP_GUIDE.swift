// ============================================================
//  Xcode 프로젝트 설정 안내 (스토리보드 없이 코드 기반 UI 사용)
// ============================================================
//
// [1단계] 새 Xcode 프로젝트 생성
//   - File > New > Project > iOS > App
//   - Interface: Storyboard  /  Language: Swift
//   - 프로젝트명: LiarMaster
//
// [2단계] Main.storyboard 삭제
//   - 프로젝트 탐색기에서 Main.storyboard 선택 후 Delete (Move to Trash)
//
// [3단계] Info.plist 수정
//   - Info.plist 열기
//   - "Main storyboard file base name" 항목 삭제
//   (또는 UIMainStoryboardFile 키 삭제)
//
// [4단계] SceneDelegate.swift 수정
//   아래 코드를 SceneDelegate.swift의 scene(_:willConnectTo:) 함수에 붙여넣기:
//
//   func scene(_ scene: UIScene,
//              willConnectTo session: UISceneSession,
//              options connectionOptions: UIScene.ConnectionOptions) {
//
//       guard let windowScene = (scene as? UIWindowScene) else { return }
//       let window = UIWindow(windowScene: windowScene)
//       let homeVC = HomeViewController()
//       let navController = UINavigationController(rootViewController: homeVC)
//       window.rootViewController = navController
//       window.makeKeyAndVisible()
//       self.window = window
//   }
//
// [5단계] Swift 파일 추가
//   이 폴더의 파일들을 Xcode 프로젝트에 드래그:
//     - Models.swift
//     - HomeViewController.swift
//     - CardViewController.swift
//     - TimerViewController.swift
//     - ResultViewController.swift
//   (Add to targets: LiarMaster 체크)
//
// [6단계] 기존 ViewController.swift 삭제
//   - Xcode가 기본 생성한 ViewController.swift 삭제
//
// [7단계] 빌드 및 실행
//   - Command + R 또는 ▶ 버튼으로 시뮬레이터 실행
// ============================================================
