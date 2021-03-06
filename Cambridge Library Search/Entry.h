//
//  Entry.h
//  Cambridge Library Search
/*
 Copyright (c) 2011, James Snee 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 • Redistributions of source code must retain the above copyright notice, this 
 list of conditions and the following disclaimer.
 • Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

@interface Entry : NSObject{
	
	NSString *author;
	NSString *title;
	NSString *edition;
	NSString *isbn;
	
	//Aquabrowser specific
	NSString *bibId;
	NSString *coverImageURL;
	NSString *database;
	NSString *pubDate;
	
	//Holding Data
	NSMutableArray *libraryCodes;
	NSMutableArray *normalisedCallNos;
	NSMutableArray *locationCodes;
	NSMutableArray *locationNames;
	NSMutableArray *callNos;
}

//Properties
@property (retain) NSString *author;
@property (retain) NSString *title;
@property (retain) NSString *edition;
@property (retain) NSString *isbn;

@property (retain) NSString *bibId;
@property (retain) NSString *coverImageURL;
@property (retain) NSString *database;
@property (retain) NSString *pubDate;

@property (retain) NSMutableArray *libraryCodes;
@property (retain) NSMutableArray *normalisedCallNos;
@property (retain) NSMutableArray *locationCodes;
@property (retain) NSMutableArray *locationNames;
@property (retain) NSMutableArray *callNos;

@end
