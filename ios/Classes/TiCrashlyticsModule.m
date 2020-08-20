/**
 * titanium-crashlytics
 *
 * Created by Hans Knoechel
 * Copyright (c) 2018 Hans Knoechel. No rights reserved.
 */

#import "TiCrashlyticsModule.h"
#import "TiApp.h"
#import "TiBase.h"
#import "TiExceptionHandler.h"
#import "TiHost.h"
#import "TiUtils.h"

#import <FirebaseCrashlytics/FirebaseCrashlytics.h>

@implementation TiCrashlyticsModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"108ab55a-0cbb-4c63-ade2-536dabdfa250";
}

- (NSString *)moduleId
{
  return @"ti.crashlytics";
}

- (void)_configure
{
  [super _configure];
}

#pragma Public APIs

- (void)crash:(id)unused
{
  @[][1];
}

- (void)setUserIdentifier:(id)userIdentifier
{
  ENSURE_SINGLE_ARG(userIdentifier, NSString);
  [[FIRCrashlytics crashlytics] setUserID:userIdentifier];
}

- (void)log:(id)log
{
  ENSURE_SINGLE_ARG(log, NSString);  
  [[FIRCrashlytics crashlytics] log:log];
}

- (void)recordCustomException:(id)params
{
  ENSURE_SINGLE_ARG(params, NSDictionary);
  NSString *name = params[@"name"];
  NSString *reason = params[@"reason"];
  NSArray *frames = params[@"frames"];
  
  FIRExceptionModel *model = [[FIRExceptionModel alloc] initWithName:name reason:reason];
  
  NSMutableArray<FIRStackFrame *> *frameArray = [NSMutableArray arrayWithCapacity:frames.count];
  for (NSString *frame in frames) {
    // TODO: expose FIRStackFrame?
    [frameArray addObject:[FIRStackFrame stackFrameWithSymbol:frame file:@"main.js" line:0]];
  }
  
  [[FIRCrashlytics crashlytics] recordExceptionModel:model];
}

- (void)setEnabled:(NSNumber *)enabled
{
  [[FIRCrashlytics crashlytics] setCrashlyticsCollectionEnabled:enabled];
}

@end
