project 'Ecommerce.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
    pod 'Firebase/Core', '6.1.0'
    pod 'Firebase/Auth', '6.1.0'
    pod 'Firebase/Firestore', '6.1.0'
    pod 'Firebase/Storage', '6.1.0'
    pod 'Firebase/Functions', '6.1.0'
    pod 'IQKeyboardManagerSwift', '6.3.0'
    pod 'Kingfisher', '~> 4.0'
end

target 'Ecommerce' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Ecommerce

shared_pods
pod 'Stripe', '15.0.1'

  target 'EcommerceTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'EcommerceUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'EcommerceAdmin' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EcommerceAdmin
shared_pods
end
