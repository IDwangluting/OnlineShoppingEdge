//
//  OSEHomeViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/3.
//  Copyright © 2020 luting. All rights reserved.
//

//    NSString * urlString = @"http://item.jd.com/40395526489.html";
//    NSString * urlString = @"http://detail.tmall.com/item.htm?id=601565277987";
//    NSString * urlString = @"http://product.dangdang.com/28502447.html#ddclick_reco_book";
//    NSString * urlString = @"https://item.gome.com.cn/9140127528-1130660112.html?intcmp=box20-v3-1_2_0a70ae2520011113081126&frm=bigd";
//    NSString * urlString = @"https://item.taobao.com/item.htm?id=522020554602&ali_refid=a3_420435_1006:1102185729:N:8jeuVnatBzSHv0A7PH5qZA%3D%3D:10d87f1e56e49e04234f581a25de91c2&ali_trackid=1_10d87f1e56e49e04234f581a25de91c2&spm=a230r.1.1989828.22";
//
//    NSString * urlString = @"https://www.amazon.cn/gp/product/B00MCW8R1S/ref=cn_ags_s9_asin_1403206071_merchandised-search-3?pf_rd_p=33e63d50-addd-4d44-a917-c9479c457e1a&pf_rd_s=merchandised-search-3&pf_rd_t=101&pf_rd_i=1403206071&pf_rd_m=A1AJ19PSB66TGU&pf_rd_r=F6HR5G81QGBKVX14T9CM&pf_rd_r=F6HR5G81QGBKVX14T9CM&pf_rd_p=33e63d50-addd-4d44-a917-c9479c457e1a";
        
//     NSString * urlString = @"https://product.suning.com/0070067092/000000000128763302.html?srcPoint=index3_none_recscnxhB_1-7_p_0070067092_000000000128763302_rec_6-1_0_A&src=index3_none_recscnxhB_1-7_p_0070067092_000000000128763302_rec_6-1_0_A&safp=d488778a.homepage1.99347413133.13&safc=prd.1.rec_6-1_0_A";

#define SearchBarHeight 40

#import "OSEHomeViewController.h"
#import "OSEHistroyDetailViewController.h"

//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>

@interface OSEHomeViewController ()<UISearchBarDelegate>

@property (nonnull,strong,nonatomic)UIPasteboard * pasteboard;
@property (weak,nonatomic)UISearchBar * searchBar;

@end

@implementation OSEHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    self.searchBar.frame = CGRectMake(SearchBarHeight, size.height / 3 - SearchBarHeight,size.width - SearchBarHeight * 2 , SearchBarHeight);
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        UISearchBar * searchBar = [[UISearchBar alloc]init];
        searchBar.layer.cornerRadius = 8;
        searchBar.clipsToBounds = YES;
        searchBar.searchBarStyle = UISearchBarStyleProminent;
        searchBar.placeholder = @"请输入网址";
        searchBar.delegate = self;
        searchBar.returnKeyType = UIReturnKeyDone;
        searchBar.keyboardType  = UIKeyboardTypeURL;
        searchBar.scopeButtonTitles = @[];
        searchBar.tintColor = UIColor.brownColor;
        searchBar.backgroundColor = UIColor.grayColor;
        _searchBar = searchBar;
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (void)enterHistoryDetailWithUrl:(NSString *)url {
    OSEHistroyDetailViewController * vc= [[OSEHistroyDetailViewController alloc]initWithUrl:url];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.text = @"https://product.suning.com/0070067092/000000000128763302.html?srcPoint=index3_none_recscnxhB_1-7_p_0070067092_000000000128763302_rec_6-1_0_A&src=index3_none_recscnxhB_1-7_p_0070067092_000000000128763302_rec_6-1_0_A&safp=d488778a.homepage1.99347413133.13&safc=prd.1.rec_6-1_0_A";
    
    NSURL * url = [NSURL URLWithString:searchBar.text];
    if (![url.scheme containsString:@"http"] || ![url.scheme containsString:@"https"]) {
        return ;
    }

    [self enterHistoryDetailWithUrl:searchBar.text];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [self enterHistoryDetailWithUrl:searchBar.text];
        return NO;
    }
    return YES;
}

//- (void)simCardInfo {
//    CTTelephonyNetworkInfo *  networkInfo = [[CTTelephonyNetworkInfo alloc] init];
//    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
//    carrier.carrierName;//供应商名称（中国联通 中国移动）
//    carrier.mobileCountryCode; //所在国家编号
//    carrier.mobileNetworkCode; //供应商网络编号
//    carrier.allowsVOIP?@ "YES" :@ "NO";
//    carrier.isoCountryCode;
//    NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
//    UITextContentTypeOneTimeCode
//    @{@"":@""};
    
    
//    NSArray * contentTypeArray =  @[UITextContentTypeOneTimeCode         ,
//                                    UITextContentTypeLocation            ,
//                                    UITextContentTypeFullStreetAddress   ,
//                                    UITextContentTypeStreetAddressLine1  ,
//                                    UITextContentTypeStreetAddressLine2  ,
//                                    UITextContentTypeAddressCity         ,
//                                    UITextContentTypeAddressState        ,
//                                    UITextContentTypeAddressCityAndState ,
//                                    UITextContentTypeSublocality         ,
//                                    UITextContentTypeCountryName         ,
//                                    UITextContentTypePostalCode          ,
//                                    UITextContentTypeTelephoneNumber     ,
//                                    UITextContentTypeEmailAddress        ,
//                                    UITextContentTypeURL                 ,
//                                    UITextContentTypeCreditCardNumber    ];
//    CGRect frame = self.navigationController.navigationBar.frame ;
//    CGFloat topMargin = frame.size.height + frame.origin.y;
//    for (NSInteger index = 0; contentTypeArray.count > index; index++) {
//        UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(20, (40 + 10) * index + topMargin, self.view.frame.size.width - 40, 40)];
//        field.textContentType = contentTypeArray[index];
//        field.borderStyle = UITextBorderStyleLine;
//        field.placeholder = field.textContentType;
//        [self.view addSubview:field];
//    }
//}
@end
