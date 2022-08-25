#import "TpslPrinterPlugin.h"
#if __has_include(<tpsl_printer/tpsl_printer-Swift.h>)
#import <tpsl_printer/tpsl_printer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tpsl_printer-Swift.h"
#endif

@implementation TpslPrinterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTpslPrinterPlugin registerWithRegistrar:registrar];
}
@end
