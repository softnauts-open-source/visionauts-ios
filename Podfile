# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'visionauts' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for visionauts
	pod 'Alamofire'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'Kingfisher'
	pod 'Pulsator'
  pod 'KontaktSDK'
	
  target 'visionautsTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.2'
        end
        if target.name == 'Pulsator'
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '4.0'
          end
        end
    end
end
