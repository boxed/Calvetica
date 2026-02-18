platform :ios, '13.0'

target "calvetica" do
  # Our libs
  pod 'MTDates',                  path: "libs/MTDates"
  pod 'MTAnimation',              path: "libs/MTAnimation"
  pod 'MTGeometry',               path: "libs/MTPencil/libs/MTGeometry"
  pod 'MTPencil',                 path: "libs/MTPencil/"
  pod 'MTMigration',              path: "libs/MTMigration"
  pod 'MYSCategoryProperties',    path: "libs/MYSCategoryProperties"
  pod 'MTColorDistance',          path: "libs/MTColorDistance"
  pod 'MYSRuntime',               path: "libs/MYSRuntime"
  pod 'MYSSharedSettings',        path: "libs/MYSSharedSettings"
  pod 'MTQueue'

  # Third Party
  pod 'FrameAccessor'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
