//
//  FreeTypeFace.h
//  EOSFramework
//
//  Created by Sam Chang on 1/7/13.
//
//

#import <CAPKit/CAPKit.h>
#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_GLYPH_H

@interface FreeTypeFace : NSObject{
    FT_Library   library;
    FT_Face      face;
    
    NSString *filePath;
}

- (FT_Face) getFace;

- (id)initWithFile: (NSString *) file;
@end
