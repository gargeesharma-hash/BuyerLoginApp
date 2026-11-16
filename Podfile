platform :ios, '15.0'

target 'BuyerLogin' do
  use_frameworks!

  # Same pods the buyer app uses on its login screen
  pod 'CountryPickerView'
  pod 'FTIndicator'
  pod 'Kingfisher'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
