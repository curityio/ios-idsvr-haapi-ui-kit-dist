Pod::Spec.new do |spec|
  spec.name             = 'IdsvrHaapiUIKitPreviewer'
  spec.version          = '5.5.0'
  spec.license          = { :type => "UNLICENSED", :file => "legal.md" }
  spec.homepage         = 'https://curity.io'
  spec.authors          = { 'Curity' => 'info@curity.io' }
  spec.summary          = 'Xcode Previews tooling for the Curity HAAPI UI Kit (experimental)'
  spec.description      = <<-DESC
                            Renders themed HAAPI screens and component galleries in Xcode Previews
                            so integrators can iterate on their theme without running a full
                            authentication flow. Distributed as Swift source compiled by the
                            consuming project: Debug builds get the previewer, Release builds
                            compile it to an empty module — no previewer code ships in the app.
                          DESC
  spec.documentation_url = 'https://developer.curity.io/docs/latest/index.html'
  spec.social_media_url = 'https://x.com/curityio'
  spec.swift_version = "6.0"
  spec.source           = { :git => 'https://github.com/curityio/ios-idsvr-haapi-ui-kit-dist.git', :tag => spec.version }

  spec.source_files = "HaapiUIPreviewer/**/*.swift"
  spec.dependency 'IdsvrHaapiUIKit', "= #{spec.version}"

  spec.platform = :ios
  spec.ios.deployment_target  = '14.0'

end
