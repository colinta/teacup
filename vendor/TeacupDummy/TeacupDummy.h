#import <Foundation/Foundation.h>

enum {
  AnyType   = 0,
};
typedef char AnyOldType;

@interface TeacupDummy : NSObject
- (void) setType:(AnyOldType)type;
- (AnyOldType) type;
@end
