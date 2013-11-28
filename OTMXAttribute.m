//
//  OTMXAttribute.m
//  OTMCache Example
//
//  Created by Ryan on 11/27/13.
//  Copyright (c) 2013 Otium. All rights reserved.
//

#import "OTMXAttribute.h"

NSString *const OTMXAttributeErrorDomain = @"com.otium.XAttribute.ErrorDomain";

NSError* generateError(int errnum) {
	
	NSDictionary *userInfo = @{
							   NSLocalizedDescriptionKey:[NSString stringWithUTF8String:strerror(errnum)]
							   };
	NSError *error = [NSError errorWithDomain:OTMXAttributeErrorDomain code:errnum userInfo:userInfo];
	
	return error;
	
}

@implementation OTMXAttribute

+(BOOL)setAttributeAtPath:(NSString *)path name:(NSString *)name value:(id)value position:(NSUInteger)position options:(OTMXAttributeOptions)options error:(NSError *__autoreleasing *)error {
	
	NSParameterAssert(path);
	NSParameterAssert(name);
	NSParameterAssert(value);
	
	NSAssert([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSData class]], @"Values must be of a NSString object or NSData object");
	
	const void *valueBytes = NULL;
	size_t valueLength = 0;
	
	if ([value isKindOfClass:[NSString class]]) {
		
		valueBytes = ((NSString *)value).UTF8String;
		valueLength = strlen(valueBytes);
		
	} else if ([value isKindOfClass:[NSData class]]) {
		
		valueBytes = ((NSData *)value).bytes;
		valueLength = ((NSData *)value).length;
	}
	
	
	int result = setxattr(path.fileSystemRepresentation, name.UTF8String, valueBytes, valueLength, position, options);
	
	if (result == -1) {
		*error = generateError(errno);
	}
	
	return result == 0;
}

+(BOOL)setAttributeAtPath:(NSString *)path name:(NSString *)name value:(id)value error:(NSError *__autoreleasing *)error {
	
	return [self setAttributeAtPath:path name:name value:value position:0 options:OTMXAttributeDefault error:error];
}

+(NSData *)attributeAtPath:(NSString *)path name:(NSString *)name position:(NSUInteger)position options:(OTMXAttributeOptions)options error:(NSError *__autoreleasing *)error {
	
	NSParameterAssert(path);
	NSParameterAssert(name);
	
	const char *fp = path.fileSystemRepresentation;
	const char *fn = name.UTF8String;
	
	size_t size = getxattr(fp, fn, NULL, 0, position, options);
	
	if (size == -1) {
		
		*error = generateError(errno);
		return nil;
	}
	
	void *value = malloc(size);
	
	size = getxattr(fp, fn, value, size, position, options);
	
	if (size == -1) {
		
		*error = generateError(errno);
		free(value);
		return nil;
	}
	
	NSData *data = [NSData dataWithBytes:value length:size];
	
	free(value);
	
	return data;
}

+(NSData *)attributeAtPath:(NSString *)path name:(NSString *)name error:(NSError *__autoreleasing *)error {
	
	return [self attributeAtPath:path name:name position:0 options:OTMXAttributeDefault error:error];
}

+(NSString *)stringAttributeAtPath:(NSString *)path name:(NSString *)name error:(NSError *__autoreleasing *)error {
	
	return [[NSString alloc]initWithData:[self attributeAtPath:path name:name error:error] encoding:NSUTF8StringEncoding];
}

+(NSArray *)attributeNamesAtPath:(NSString *)path options:(OTMXAttributeOptions)options error:(NSError *__autoreleasing *)error{
	
	NSParameterAssert(path);
	
	const char *fp = path.fileSystemRepresentation;
	
	size_t size = listxattr(fp, NULL, 0, options);
	
	if (size == -1) {
		
		*error = generateError(errno);
		return nil;
		
	} else if(size == 0) {
		
		return @[];
	}
	
	char *names = malloc(size);
	
	size = listxattr(fp, names, size, options);
	
	if (size == -1) {
		
		*error = generateError(errno);
		free(names);
		return nil;
	}
	
	NSMutableArray *array = [NSMutableArray array];
	NSUInteger offset = 0;
	
	while (offset < size) {
		
		NSString *string = [NSString stringWithUTF8String:names + offset];
		offset += string.length + 1;
		[array addObject:string];
		
	}
	
	free(names);
	
	return array;
}

+(BOOL)removeAttributeAtPath:(NSString *)path name:(NSString *)name options:(OTMXAttributeOptions)options error:(NSError *__autoreleasing *)error {
	
	NSParameterAssert(path);
	NSParameterAssert(name);
	
	int result = removexattr(path.fileSystemRepresentation, name.UTF8String, options);
	
	if (result == -1) {
		
		*error = generateError(errno);
	}
	
	return result == 0;
}

+(BOOL)removeAttributeAtPath:(NSString *)path name:(NSString *)name options:(NSError *__autoreleasing *)error {
	
	return [self removeAttributeAtPath:path name:name options:OTMXAttributeDefault error:error];
}

+(BOOL)attributeExistsAtPath:(NSString *)path name:(NSString *)name options:(OTMXAttributeOptions)options {
	
	size_t result = getxattr(path.fileSystemRepresentation, name.UTF8String, NULL, 0, 0, options);
	
	return result > 0;
}

+(BOOL)attributeExistsAtPath:(NSString *)path name:(NSString *)name {
	
	return [self attributeExistsAtPath:path name:name options:OTMXAttributeDefault];
}

@end
