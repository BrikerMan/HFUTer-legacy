////
////  Encryptions.h
////  HFUTer
////
////  Created by Eliyar Eziz on 15/10/17.
////  Copyright © 2015年 Eliyar Eziz. All rights reserved.
////
//
//@interface MD5Encryption : NSObject
//
//+ (NSString *)md5by32:(NSString*)input;
//- (NSString *)md5:(NSString *)str;
//
//+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
//+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;
//
////
//// Standard Base64 (RFC) handling
////
//
//// encodeData:
////
///// Base64 encodes contents of the NSData object.
////
///// Returns:
/////   A new autoreleased NSData with the encoded payload.  nil for any error.
////
//+(NSData *)Base64_encodeData:(NSData *)data;
//
//// decodeData:
////
///// Base64 decodes contents of the NSData object.
////
///// Returns:
/////   A new autoreleased NSData with the decoded payload.  nil for any error.
////
//+(NSData *)Base64_decodeData:(NSData *)data;
//
//// encodeBytes:length:
////
///// Base64 encodes the data pointed at by |bytes|.
////
///// Returns:
/////   A new autoreleased NSData with the encoded payload.  nil for any error.
////
//+(NSData *)Base64_encodeBytes:(const void *)bytes length:(NSUInteger)length;
//
//// decodeBytes:length:
////
///// Base64 decodes the data pointed at by |bytes|.
////
///// Returns:
/////   A new autoreleased NSData with the encoded payload.  nil for any error.
////
//+(NSData *)Base64_decodeBytes:(const void *)bytes length:(NSUInteger)length;
//
//// stringByEncodingData:
////
///// Base64 encodes contents of the NSData object.
////
///// Returns:
/////   A new autoreleased NSString with the encoded payload.  nil for any error.
////
//+(NSString *)Base64_stringByEncodingData:(NSData *)data;
//
//// stringByEncodingBytes:length:
////
///// Base64 encodes the data pointed at by |bytes|.
////
///// Returns:
/////   A new autoreleased NSString with the encoded payload.  nil for any error.
////
//+(NSString *)Base64_stringByEncodingBytes:(const void *)bytes length:(NSUInteger)length;
//
//// decodeString:
////
///// Base64 decodes contents of the NSString.
////
///// Returns:
/////   A new autoreleased NSData with the decoded payload.  nil for any error.
////
//+(NSData *)Base64_decodeString:(NSString *)string;
//
////
//// Modified Base64 encoding so the results can go onto urls.
////
//// The changes are in the characters generated and also allows the result to
//// not be padded to a multiple of 4.
//// Must use the matching call to encode/decode, won't interop with the
//// RFC versions.
////
//
//// webSafeEncodeData:padded:
////
///// WebSafe Base64 encodes contents of the NSData object.  If |padded| is YES
///// then padding characters are added so the result length is a multiple of 4.
////
///// Returns:
/////   A new autoreleased NSData with the encoded payload.  nil for any error.
////
//+(NSData *)Base64_webSafeEncodeData:(NSData *)data
//                      padded:(BOOL)padded;
//
//// webSafeDecodeData:
////
///// WebSafe Base64 decodes contents of the NSData object.
////
///// Returns:
/////   A new autoreleased NSData with the decoded payload.  nil for any error.
////
//+(NSData *)Base64_webSafeDecodeData:(NSData *)data;
//
//// webSafeEncodeBytes:length:padded:
////
///// WebSafe Base64 encodes the data pointed at by |bytes|.  If |padded| is YES
///// then padding characters are added so the result length is a multiple of 4.
////
///// Returns:
/////   A new autoreleased NSData with the encoded payload.  nil for any error.
////
//+(NSData *)Base64_webSafeEncodeBytes:(const void *)bytes
//                       length:(NSUInteger)length
//                       padded:(BOOL)padded;
//
//// webSafeDecodeBytes:length:
////
///// WebSafe Base64 decodes the data pointed at by |bytes|.
////
///// Returns:
/////   A new autoreleased NSData with the encoded payload.  nil for any error.
////
//+(NSData *)Base64_webSafeDecodeBytes:(const void *)bytes length:(NSUInteger)length;
//
//// stringByWebSafeEncodingData:padded:
////
///// WebSafe Base64 encodes contents of the NSData object.  If |padded| is YES
///// then padding characters are added so the result length is a multiple of 4.
////
///// Returns:
/////   A new autoreleased NSString with the encoded payload.  nil for any error.
////
//+(NSString *)Base64_stringByWebSafeEncodingData:(NSData *)data
//                                  padded:(BOOL)padded;
//
//// stringByWebSafeEncodingBytes:length:padded:
////
///// WebSafe Base64 encodes the data pointed at by |bytes|.  If |padded| is YES
///// then padding characters are added so the result length is a multiple of 4.
////
///// Returns:
/////   A new autoreleased NSString with the encoded payload.  nil for any error.
////
//+(NSString *)Base64_stringByWebSafeEncodingBytes:(const void *)bytes
//                                   length:(NSUInteger)length
//                                   padded:(BOOL)padded;
//
//// webSafeDecodeString:
////
///// WebSafe Base64 decodes contents of the NSString.
////
///// Returns:
/////   A new autoreleased NSData with the decoded payload.  nil for any error.
////
//+(NSData *)Base64_webSafeDecodeString:(NSString *)string;
//
//@en