//
//  color.h
//  Firehose
//
//  Created by Adam Kirk on 3/30/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#ifndef RGB

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)

#define RGBAHex(rgbValue, a) RGBA( \
((float)((rgbValue & 0xFF0000) >> 16)), \
((float)((rgbValue & 0xFF00) >> 8)), \
((float)(rgbValue & 0xFF)), \
a \
)

#define RGBHex(rgbValue) RGBAHex(rgbValue, 1.0)

#endif
