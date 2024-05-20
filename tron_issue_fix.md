
# TronWebSwift Issue Fix

## 问题 / Issue
在运行 `pod install` 时，出现了以下警告：
While running `pod install`, the following warnings appeared:

```
[!] A license was specified in podspec `TronWebSwift` but the file does not exist - /Volumes/WhiteHare_/wallet_ios/TronWebSwift/LICENSE
[!] Unable to read the license file `LICENSE` for the spec `TronWebSwift (1.0.0)`
```

## 原因 / Cause
`TronWebSwift.podspec` 文件中指定了一个不存在的 `LICENSE` 文件。
The `TronWebSwift.podspec` file specifies a `LICENSE` file that does not exist.

## 解决方法 / Solution
创建并添加一个 `LICENSE` 文件到 `TronWebSwift` 目录中。以下是 `TronWebSwift.podspec` 的例子：
Create and add a `LICENSE` file to the `TronWebSwift` directory. Here is an example of the `TronWebSwift.podspec` file:

```ruby
Pod::Spec.new do |s|
  s.name             = 'TronWebSwift'
  s.version          = '1.0.0'
  s.summary          = 'A Swift wrapper for TronWeb.'
  s.description      = 'This is a Swift wrapper for TronWeb, providing the necessary functionalities for interacting with Tron blockchain.'
  s.homepage         = 'https://github.com/mathwallet/TronWebSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Author Name' => 'author@example.com' }
  s.source           = { :git => 'https://github.com/mathwallet/TronWebSwift.git', :tag => '1.0.0' }
  s.platform         = :ios, '11.0'
  s.source_files     = 'TronWebSwift/**/*.{swift,h,m}'
  s.requires_arc     = true
end
```

确保在 `TronWebSwift` 目录中有一个 `LICENSE` 文件。你可以使用 MIT 许可的标准文本，或者根据需要自定义。
Ensure that there is a `LICENSE` file in the `TronWebSwift` directory. You can use the standard text for the MIT license or customize it as needed.
