//
//  AIRGoogleMapURLTile.m
//  Created by Nick Italiano on 11/5/16.
//

#ifdef HAVE_GOOGLE_MAPS

#import "AIRGoogleMapUrlTile.h"

@implementation AIRGoogleMapUrlTile

- (void)setZIndex:(int)zIndex
{
  _zIndex = zIndex;
  _tileLayer.zIndex = zIndex;
}

- (void)setUrlTemplate:(NSString *)urlTemplate
{
  _urlTemplate = urlTemplate;
  _tileLayer = [GMSURLTileLayer tileLayerWithURLConstructor:[self _getTileURLConstructor]];
  _tileLayer.tileSize = [[UIScreen mainScreen] scale] * 256;
}

- (GMSTileURLConstructor)_getTileURLConstructor
{
  NSString *urlTemplate = self.urlTemplate;
  NSInteger *maximumZ = self.maximumZ;
  NSInteger *minimumZ = self.minimumZ;
  GMSTileURLConstructor urls = ^NSURL* _Nullable (NSUInteger x, NSUInteger y, NSUInteger zoom) {
    NSString *url = urlTemplate;
    NSUInteger realZoom = zoom - 16;
    long realX = x - (long) (32767 * pow(2, realZoom));
    long realY = y - (long) (32767 * pow(2, realZoom));

    url = [url stringByReplacingOccurrencesOfString:@"{x}" withString:[NSString stringWithFormat: @"%ld", (long)realX]];
    url = [url stringByReplacingOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat: @"%ld", (long)realY]];
    url = [url stringByReplacingOccurrencesOfString:@"{z}" withString:[NSString stringWithFormat: @"%ld", (long)realZoom]];

   if(maximumZ && (long)zoom > (long)maximumZ) {
      return nil;
    }

    if(minimumZ && (long)zoom < (long)minimumZ) {
      return nil;
    }

    return [NSURL URLWithString:url];
  };
  return urls;
}

@end

#endif
