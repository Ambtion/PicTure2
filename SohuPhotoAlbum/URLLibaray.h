//
//  URLLibaray.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-16.
//
//


#define DEV 1

#ifdef DEV

#define BASICURL @"http://dev.pp.sohu.com"
#define BASICURL_V1 @"http://dev.pp.sohu.com/api/v1"

#else

#define BASICURL @"http://pp.sohu.com"
#define BASICURL_V1 @"http://pp.sohu.com/api/v1"

#endif

#define CLIENT_ID @"355d0ee5-d1dc-3cd3-bdc6-76d729f61655"

#define CLIENT_SECRET @"47ae8860-2f8d-36c3-be99-3ebba8f1e7e7"

#define WEIBOOAUTHOR2URL @"http://pp.sohu.com/auth/mobile/weibo"

#define QQOAUTHOR2URL   @"http://pp.sohu.com/auth/mobile/qq"

#define RENRENAUTHOR2URL  @"http://pp.sohu.com/auth/mobile/renren"
