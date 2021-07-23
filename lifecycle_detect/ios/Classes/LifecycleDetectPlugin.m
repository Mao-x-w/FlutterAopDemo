#import "LifecycleDetectPlugin.h"
#if __has_include(<lifecycle_detect/lifecycle_detect-Swift.h>)
#import <lifecycle_detect/lifecycle_detect-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lifecycle_detect-Swift.h"
#endif

@implementation LifecycleDetectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLifecycleDetectPlugin registerWithRegistrar:registrar];
}
@end
