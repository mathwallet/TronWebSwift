Pod::Spec.new do |spec|
  spec.name = 'TronWebSwift'
  spec.version = '1.0.0'
  spec.summary = 'A Swift wrapper for Tron Web API'
  spec.description = <<-DESC
    A Swift wrapper for Tron Web API to interact with Tron blockchain.
  DESC
  spec.homepage = 'https://github.com/Whitehare2023/TronWebSwift'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'Math Wallet' => 'support@mathwallet.org' }

  spec.requires_arc = true
  spec.source = { git: 'https://github.com/Whitehare2023/TronWebSwift.git', branch: 'add-podspec' }
  spec.source_files = 'Sources/TronWebSwift/**/*.{h,m,swift}'
  spec.exclude_files = 'Sources/**/LinuxSupport.swift'
  spec.ios.deployment_target = '13.0'
  spec.swift_version = '5.0'

  spec.dependency 'Alamofire', '~> 5.4'
  spec.dependency 'SwiftProtobuf'
  spec.dependency 'BigInt'
end
