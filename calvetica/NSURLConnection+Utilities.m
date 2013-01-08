//
//  NSURLConnection+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "NSURLConnection+Utilities.h"
#import "NSJSONSerialization+Utilities.h"
#import "NSData+Utilities.h"

@implementation NSURLConnection (Utilities)

+ (NSArray *)JSONFromURL:(NSString *)url usingUsername:(NSString *)username password:(NSString*)password method:(NSString *)method sendingBody:(NSString *)body result:(CVURLConnectionResult *)result error:(NSError **)error {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

	[request setHTTPMethod:method];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	if (username && password) {
        NSString *plainTextAuth = [NSString stringWithFormat:@"%@:%@", username, password];        
        NSString *base64EncodedAuth = [[plainTextAuth dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
		[request setValue:[NSString stringWithFormat:@"Basic %@", base64EncodedAuth] forHTTPHeaderField:@"Authorization"];
    }
	
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
		
		
	NSHTTPURLResponse *response = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
	
	// set the status code
	if ([response statusCode] == 200) {
		*result = CVURLConnectionResultSuccess;
	}
	else if ([response statusCode] == 201) {
		*result = CVURLConnectionResultCreated;
	}
	else if ([response statusCode] == 401 || (*error && [*error code] == NSURLErrorUserCancelledAuthentication)) {
		*result = CVURLConnectionResultUnauthorized;
		NSDictionary *dictionary = @{NSLocalizedDescriptionKey: @"UNAUTHORIZED"};
		*error = [NSError errorWithDomain:@"RequestError" code:401 userInfo:dictionary];
		return nil;
	}
	else if ([response statusCode] == 404) {
		*result = CVURLConnectionResultNotFound;
		NSDictionary *dictionary = @{NSLocalizedDescriptionKey: @"NOT FOUND"};
		*error = [NSError errorWithDomain:@"RequestError" code:[response statusCode] userInfo:dictionary];
		return nil;
	}
	else if ([response statusCode] == 422) {
		*result = CVURLConnectionResultUnprocessable;
	}
	else if (!data) {
		*result = CVURLConnectionResultNoConnection;
		NSDictionary *dictionary = @{NSLocalizedDescriptionKey: @"No internet connection"};
		*error = [NSError errorWithDomain:@"ConnectionError" code:[response statusCode] userInfo:dictionary];
		return nil;
	}
	else {
		*result = CVURLConnectionResultOther;
	}
	
	
	
	
	
	// if the connection and response was successfully made and recieved
	if (response) {
        
        id JSONObject = [NSJSONSerialization unserializeData:data];
		
		// if there was a problem with the request or the server
		if (*result == CVURLConnectionResultUnprocessable) {
			
			NSDictionary *errorDict = nil;
            if ([JSONObject isKindOfClass:[NSArray class]]) {
                errorDict = [JSONObject lastObject];
            }
            else {
                errorDict = (NSDictionary *)JSONObject;
            }
			NSString *errorString = [[[errorDict allValues] lastObject] lastObject];
			errorString = [errorString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
			errorString = [errorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if (errorString && [errorString isKindOfClass:[NSString class]]) {
				NSDictionary *dictionary = @{NSLocalizedDescriptionKey: errorString};
				*error = [NSError errorWithDomain:@"RequestError" code:[response statusCode] userInfo:dictionary];				
			}
			return nil;
		}
		
		else if (*error != nil) {
			return nil;
		}
		
		// otherwise, everything worked out great, so we can parse the json data.
		else {
			
			// if the JSON was malformed, return an error 
			if (!JSONObject) {
				NSDictionary *dictionary = @{NSLocalizedDescriptionKey: @"The JSON returned was not valid"};
				*error = [NSError errorWithDomain:@"ResponseError" code:[response statusCode] userInfo:dictionary];
				return nil;
			}
			else {
				return JSONObject;
			}
		}
	}
	
	return nil;
	
}

@end
