//
//  OTMXAttribute.h
//  OTMCache Example
//
//  Created by Otium on 11/27/13.
//  Copyright (c) 2013 Otium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/xattr.h>

typedef NS_ENUM(NSInteger, OTMXAttributeOptions) {
	
	OTMXAttributeDefault = 0,
	OTMXAttributeNoFollow = XATTR_NOFOLLOW,
	OTMXAttributeCreate = XATTR_CREATE,
	OTMXAttributeReplace = XATTR_REPLACE,
	OTMXAttributeShowCompression = XATTR_SHOWCOMPRESSION
};

@interface OTMXAttribute : NSObject

+(BOOL)setAttributeAtPath:(NSString *)path name:(NSString *)name value:(id)value position:(NSUInteger)position options:(OTMXAttributeOptions)options error:(NSError *__autoreleasing*)error;
+(BOOL)setAttributeAtPath:(NSString *)path name:(NSString *)name value:(id)value error:(NSError *__autoreleasing*)error;

+(NSData *)attributeAtPath:(NSString *)path name:(NSString *)name position:(NSUInteger)position options:(OTMXAttributeOptions)options error:(NSError *__autoreleasing *)error;
+(NSData *)attributeAtPath:(NSString *)path name:(NSString *)name error:(NSError *__autoreleasing *)error;
+(NSString *)stringAttributeAtPath:(NSString *)path name:(NSString *)name error:(NSError *__autoreleasing *)error;

+(NSArray *)attributeNamesAtPath:(NSString *)path options:(OTMXAttributeOptions)options error:(NSError *__autoreleasing*)error;

+(BOOL)removeAttributeAtPath:(NSString *)path name:(NSString *)name options:(OTMXAttributeOptions)options error:(NSError *__autoreleasing*)error;
+(BOOL)removeAttributeAtPath:(NSString *)path name:(NSString *)name error:(NSError *__autoreleasing*)error;

+(BOOL)attributeExistsAtPath:(NSString *)path name:(NSString *)name options:(OTMXAttributeOptions)options;
+(BOOL)attributeExistsAtPath:(NSString *)path name:(NSString *)name;

@end
