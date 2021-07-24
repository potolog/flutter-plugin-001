#import "Plugin001Plugin.h"
#if __has_include(<plugin_001/plugin_001-Swift.h>)
#import <plugin_001/plugin_001-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "plugin_001-Swift.h"
#endif

@implementation Plugin001Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlugin001Plugin registerWithRegistrar:registrar];
}
@end
