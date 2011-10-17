//
//  RecordLocation.m
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

#import "RecordLocation.h"

@implementation RecordLocation
@synthesize coordinate, title, subtitle, libraryLocation, libraryName;

-(id)initWithTitle:(NSString *)n_title andSubTitle:(NSString *)n_subtitle andLibraryName:(NSString *)libName{
	self = [super init];
	if(self){
		self.title = n_title;
		self.subtitle = n_subtitle;
		//self.libraryName = libName;
		self.libraryName = [[libName stringByReplacingOccurrencesOfString:@":" withString:@" "] stringByReplacingOccurrencesOfString:@"'" withString:@""];
		NSLog(@"Lib name after strip %@",[self libraryName]);
		
		NSArray *libraries = [RecordLocation getLibraryNames];
		NSArray *locations = [RecordLocation getLibraryLocations];
		
		//Do some string stuff to find the coordinates of the library
		for(int i=0;i<[libraries count];i++){
			NSRange textRange;
			textRange =[[libraryName lowercaseString] rangeOfString:[[libraries objectAtIndex:i] lowercaseString]];
			
			if(textRange.location != NSNotFound)
			{
				NSString *longLat = [locations objectAtIndex:i];
				
				NSLog(@"Setting location at %@",longLat);
				
				NSArray *coords = [longLat componentsSeparatedByString:@","];
				
				float longd = [[coords objectAtIndex:1] floatValue];
				NSLog(@"Long %f",longd);
				
				float lat = [[coords objectAtIndex:0] floatValue];
				NSLog(@"Lat %f",lat);
				
				coordinate.latitude = lat;
				coordinate.longitude = longd;
			}
		}
		[libraries release];
		[locations release];
	}
	return self;
}

/*
-(NSString *)title{
	return title;
}

-(NSString *)subtitle{
	return subtitle;
}
 */


/* 
 * The library names and locations, probably not the best way to do this.
 * It should be done with constants but I need to read up more on the c preprocessor
 */
+ (NSArray *)getLibraryNames{
	return [[NSArray alloc] initWithObjects:
			@"UL",
			@"Medical Library",
			@"Squire Law Library",
			@"Central Science Library",
			@"Betty & Gordon Moore",
			/* COLLEGES */
			@"Christs College",
			@"Churchill College",
			@"Clare College",
			@"Clare Hall",
			@"Corpus Christi College",
			@"Darwin College",
			@"Downing College",
			@"Emmanuel College",
			@"Fitzwilliam College",
			@"Girton College",
			@"Gonville & Caius College",
			@"Homerton College",
			@"Hughes Hall",
			@"Jesus College",
			@"Kings College",
			@"Lucy Cavendish College",
			@"Magdalene College",
			@"Murray Edwards College",
			@"Newnham College",
			@"Pembroke College",
			@"Peterhouse",
			@"Queens College",
			@"Robinson College",
			@"St Catharines College",
			@"St Edmunds College",
			@"St Johns College",
			@"Selwyn College",
			@"Sidney Sussex College",
			@"Trinity College",
			@"Trinity Hall",
			@"Wolfson College",
			nil];
}

+ (NSArray *)getLibraryLocations{
	return [[NSArray alloc] initWithObjects:
			@"52.204917,0.107565", /* The UL */
			@"52.186404,0.137709", /* Medical Library */
			@"52.2029,0.110727", /* Squire Law Library */
			@"52.203695,0.119054", /* Central Science Library */
			@"52.209552,0.100047", /* Betty & Gordon Moore */
			/* COLLEGES */
			@"52.20639,0.12170", /* Christ's College */
			@"52.21293,0.10310", /* Churchill College */
			@"52.20509,0.11564", /* Clare College */
			@"52.20409,0.10445", /* Clare Hall */
			@"52.20288,0.11782", /* Corpus Chisti College */
			@"52.20067,0.11371", /* Darwin College */
			@"52.20142,0.12517", /* Downing College */
			@"52.20361,0.12375", /* Emmanuel College */
			@"52.21434,0.10478", /* Fitzwilliam College */
			@"52.22841,0.08373", /* Girton College */
			@"52.20590,0.11794", /* Gonville & Caius College */
			@"52.18606,0.13599", /* Homerton College */
			@"52.20073,0.13323", /* Hughes Hall */
			@"52.20908,0.12334", /* Jesus College */
			@"52.20433,0.11724", /* King's College */
			@"52.21101,0.11052", /* Lucy Cavendish College */
			@"52.21044,0.11577", /* Magdalene College */
			@"52.21419,0.10856", /* Murray Edwards College */
			@"52.20018,0.10722", /* Newnham College */
			@"52.20265,0.12063", /* Pembroke College */
			@"52.20065,0.11813", /* Peterhouse */
			@"52.20184,0.11421", /* Queen's College */
			@"52.20483,0.10534", /* Robinson College */
			@"52.20288,0.11637", /* St Catharine's College */
			@"52.21291,0.10925", /* St Edmund's College */
			@"52.20884,0.11738", /* St Johns College */
			@"52.20098,0.10556", /* Selwyn College */
			@"52.20750,0.12131", /* Sidney Sussex College */
			@"52.20712,0.11759", /* Trinity College */
			@"52.20608,0.11561", /* Trinity Hall */
			@"52.19866,0.10101", /* Wolfson College */
			
			
			nil];
}



@end
