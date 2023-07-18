platform :ios, '11.0'
target 'SwiftMVVMTP' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxAlamofire'
  pod 'MBProgressHUD'
  pod 'Kingfisher'
  pod 'Localize'
  pod 'FirebaseMessaging'
  post_install do |pi|
      pi.pods_project.targets.each do |t|
          t.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
          end
      end
  end
end
