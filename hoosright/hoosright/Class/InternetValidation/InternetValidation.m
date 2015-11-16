//
//  InternetValidation.m
//  CarBrokersUSA
//
//  Created by Micronixtraining on 9/6/13.
//  Copyright (c) 2013 Micronix Technologies. All rights reserved.
//

#import "InternetValidation.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@implementation InternetValidation
+ (BOOL) connectedToNetwork
{
	
    
	BOOL success = NO;
	const char *host_name = [@"google.com"
							 cStringUsingEncoding:NSASCIIStringEncoding];
	
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,
																				host_name);
	SCNetworkReachabilityFlags flags;
	success = SCNetworkReachabilityGetFlags(reachability, &flags);
	BOOL isAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	if (isAvailable) {
		success = YES;
	}else{
		success = NO;
	}
	//NSLog(@"%d",success);
	return success;
    
}


@end
