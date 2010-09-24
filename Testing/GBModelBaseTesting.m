//
//  GBModelBaseTesting.m
//  appledoc
//
//  Created by Tomaz Kragelj on 28.7.10.
//  Copyright (C) 2010 Gentle Bytes. All rights reserved.
//

#import "GBDataObjects.h"

@interface GBModelBaseTesting : GHTestCase
@end

@implementation GBModelBaseTesting

#pragma mark Common merging testing

- (void)testMergeDataFromObject_shouldMergeDeclaredFiles {
	// setup
	GBModelBase *original = [[GBModelBase alloc] init];
	[original registerSourceInfo:[GBSourceInfo fileDataWithFilename:@"f1" lineNumber:1]];
	[original registerSourceInfo:[GBSourceInfo fileDataWithFilename:@"f2" lineNumber:2]];
	GBModelBase *source = [[GBModelBase alloc] init];
	[source registerSourceInfo:[GBSourceInfo fileDataWithFilename:@"f1" lineNumber:3]];
	[source registerSourceInfo:[GBSourceInfo fileDataWithFilename:@"f3" lineNumber:4]];
	// execute
	[original mergeDataFromObject:source];
	// verify
	NSArray *files = [original sourceInfosSortedByName];
	assertThatInteger([files count], equalToInteger(3));
	assertThat([[files objectAtIndex:0] filename], is(@"f1"));
	assertThat([[files objectAtIndex:1] filename], is(@"f2"));
	assertThat([[files objectAtIndex:2] filename], is(@"f3"));
	assertThatInteger([[files objectAtIndex:0] lineNumber], equalToInteger(3));
	assertThatInteger([[files objectAtIndex:1] lineNumber], equalToInteger(2));
	assertThatInteger([[files objectAtIndex:2] lineNumber], equalToInteger(4));
}

- (void)testMergeDataFromObject_shouldPreserveSourceDeclaredFiles {
	// setup
	GBModelBase *original = [[GBModelBase alloc] init];
	[original registerSourceInfo:[GBSourceInfo fileDataWithFilename:@"f1" lineNumber:4]];
	 [original registerSourceInfo:[GBSourceInfo fileDataWithFilename:@"f2" lineNumber:3]];
	GBModelBase *source = [[GBModelBase alloc] init];
	 [source registerSourceInfo:[GBSourceInfo fileDataWithFilename:@"f1" lineNumber:2]];
	 [source registerSourceInfo:[GBSourceInfo fileDataWithFilename:@"f3" lineNumber:1]];
	// execute
	[original mergeDataFromObject:source];
	// verify
	NSArray *files = [source sourceInfosSortedByName];
	assertThatInteger([files count], equalToInteger(2));
	assertThat([[files objectAtIndex:0] filename], is(@"f1"));
	assertThat([[files objectAtIndex:1] filename], is(@"f3"));
	assertThatInteger([[files objectAtIndex:0] lineNumber], equalToInteger(2));
	assertThatInteger([[files objectAtIndex:1] lineNumber], equalToInteger(1));
}

#pragma mark Comments merging handling

- (void)testMergeDataFromObject_shouldUseOriginalCommentIfSourceIsNotGiven {
	// setup
	GBModelBase *original = [[GBModelBase alloc] init];
	[original registerCommentString:@"Comment"];
	GBModelBase *source = [[GBModelBase alloc] init];
	// execute
	[original mergeDataFromObject:source];
	// verify
	assertThat(original.comment.stringValue, is(@"Comment"));
	assertThat(source.comment.stringValue, is(nil));
}

- (void)testMergeDataFromObject_shouldUseSourceCommentIfOriginalIsNotGiven {
	// setup
	GBModelBase *original = [[GBModelBase alloc] init];
	GBModelBase *source = [[GBModelBase alloc] init];
	[source registerCommentString:@"Comment"];
	// execute
	[original mergeDataFromObject:source];
	// verify
	assertThat(original.comment.stringValue, is(@"Comment"));
	assertThat(source.comment.stringValue, is(@"Comment"));
}

- (void)testMergeDataFromObject_shouldKeepOriginalCommentIfBothObjectsHaveComments {
	// setup
	GBModelBase *original = [[GBModelBase alloc] init];
	[original registerCommentString:@"Comment1"];
	GBModelBase *source = [[GBModelBase alloc] init];
	[source registerCommentString:@"Comment2"];
	// execute
	[original mergeDataFromObject:source];
	// verify
	assertThat(original.comment.stringValue, is(@"Comment1"));
	assertThat(source.comment.stringValue, is(@"Comment2"));
}

@end
