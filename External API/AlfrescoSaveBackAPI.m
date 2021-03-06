/*******************************************************************************
 * Copyright (C) 2005-2012 Alfresco Software Limited.
 *
 * This file is part of the Alfresco SaveBack API.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/
//
//  AlfrescoSaveBackAPI.m
//

#import "AlfrescoSaveBackAPI.h"

/**
 * The Alfresco private metadata will be stored in the annotation dictionary under this key. It should be returned in the
 * same format, using the same key, when invoking a Save Back operation.
 */
NSString * const AlfrescoSaveBackMetadataKey = @"AlfrescoMetadata";

/**
 * Limit the "Open In..." list of available apps, part 1:
 * The document must be renamed so that the following extension is appended to the filename. For example "My Document.docx.alfrescosaveback"
 */
NSString * const AlfrescoSaveBackDocumentExtension = @".alfrescosaveback";

/**
 * Limit the "Open In..." list of available apps, part 2:
 * The UIDocumentInteractionController's UTI property must be set to a unique string.
 */
NSString * const AlfrescoSaveBackUTI = @"com.alfresco.mobile.saveback";


/**
 * Save Back to Alfresco helper function.
 *
 * The function is given the path to a document and will return a URL representing a suitably renamed document
 * ready to participate in the Save Back operation. The renamed document will be created in the temporary directory.
 */
NSURL *alfrescoSaveBackURLForFilePath(NSString *filePath, NSError **error)
{
    NSString *tempFilename = [NSTemporaryDirectory() stringByAppendingPathComponent:filePath.pathComponents.lastObject];
    NSString *tempSaveBackPath = [tempFilename stringByAppendingString:AlfrescoSaveBackDocumentExtension];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tempSaveBackPath])
    {
        if ([fileManager removeItemAtPath:tempSaveBackPath error:error] == NO)
        {
            return nil;
        }
    }
    
    if ([fileManager copyItemAtPath:filePath toPath:tempSaveBackPath error:error] == NO)
    {
        return nil;
    }
    
    return [NSURL fileURLWithPath:tempSaveBackPath];
}
