//
//  NSURLConnection+Utilities.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


/*

 USAGE:
 
 1. call: NSArray *returnedArray = [NSURLConnection JSONFromURL:url usingUsername:username password:password method:method sendingBody:body error:&error];
 
 2. check the result option to make sure its what you expect, if its not what you expect
 
	 I. check the error object.  If it is NOT nil
	 
		a. see if the domain is @"ConnectionError".  If it is, that means there is no internet connection.
		
		b. see if the domain is @"RequestError".  If it is:
			
			i. if the error.code property is 401, your username and password are wrong.

			ii. if the error.code is 404, your url is wrong.
	 
			iii. if the error.code is 422, the JSON you sent was malformed.
	 
			iv. if the error.code is 426, you tried to connect with http when https is required.
		
		c. see if the domain is @"ResponseError".  If it is, the JSON returned was malformed.

 3. check to make sure returnedArray is not nil.  If it is, and error was nil too, you're screwed.
 
 
 EXAMPLE:
 
 dispatch_async([CVOperationQueue backgroundQueue], ^(void) {
	
 	NSError *error = nil;
	NSArray *returnedArray = [NSURLConnection JSONFromURL:url usingUsername:username password:password method:method sendingBody:body error:&error];
 	
 	dispatch_async(dispatch_get_main_queue(), ^(void) {
 		*** update the UI with the response data ***
 	});
 
 });
 
*/


typedef enum {
    CVURLConnectionResultSuccess,
	CVURLConnectionResultCreated,
    CVURLConnectionResultUnauthorized,
    CVURLConnectionResultUnprocessable,
	CVURLConnectionResultNotFound,
	CVURLConnectionResultNoConnection,
	CVURLConnectionResultOther,
} CVURLConnectionResult;

@interface NSURLConnection (Utilities)

+ (NSArray *)JSONFromURL:(NSString *)url usingUsername:(NSString *)username password:(NSString*)password method:(NSString *)method sendingBody:(NSString *)body result:(CVURLConnectionResult *)result error:(NSError **)error;

@end
