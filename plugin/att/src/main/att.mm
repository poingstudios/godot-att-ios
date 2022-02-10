//
//  att.mm
//  att
//
//  Created by Gustavo Maciel on 06/02/22.
//

#import <Foundation/Foundation.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#include "core/project_settings.h"
#include "core/class_db.h"

#import "att.h"

void ATT::_bind_methods() {
    ADD_SIGNAL(MethodInfo("request_tracking_authorization_complete", PropertyInfo(Variant::INT, "status")));

    ClassDB::bind_method("request_tracking_authorization", &ATT::request_tracking_authorization);
    ClassDB::bind_method("get_tracking_authorization_status", &ATT::get_tracking_authorization_status);
}

void ATT::request_tracking_authorization() {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            NSLog(@"iOS 14+: Status: %@", [@(status) stringValue]);
            emit_signal("request_tracking_authorization_complete", (int)status);
        }];
    }
    else{
        NSLog(@"iOS version below 14 ATT: status 0 = ATTrackingManagerAuthorizationStatusNotDetermined");
        emit_signal("request_tracking_authorization_complete", 0); // 0 = ATTrackingManagerAuthorizationStatusNotDetermined //
        //https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanagerauthorizationstatus/attrackingmanagerauthorizationstatusnotdetermined?language=objc
    }
}

int ATT::get_tracking_authorization_status() {
    if (@available(iOS 14, *)) {
        NSLog(@"iOS 14+: Status: %@", [@([ATTrackingManager trackingAuthorizationStatus]) stringValue]);
        return (int)[ATTrackingManager trackingAuthorizationStatus];
    }
    else{
        NSLog(@"iOS version below 14 ATT: status 0 = ATTrackingManagerAuthorizationStatusNotDetermined");
        return 0; // 0 = ATTrackingManagerAuthorizationStatusNotDetermined
        //https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanagerauthorizationstatus/attrackingmanagerauthorizationstatusnotdetermined?language=objc
    }
}


ATT::ATT() {
    NSLog(@"initialize ATT");
}

ATT::~ATT() {
    NSLog(@"deinitialize ATT");
}
