//
//  ViewController.m
//  07导航自定义画线
//
//  Created by 章芝源 on 15/11/5.
//  Copyright © 2015年 ZZY. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
@interface ViewController ()<MKMapViewDelegate>
///定位器
@property(nonatomic, strong)CLLocationManager *manager;
///地理解析器
@property(nonatomic, strong)CLGeocoder *geoger;
///地图mapView
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ViewController

#pragma mark - lazy
- (CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
    }
    return _manager;
}

- (CLGeocoder *)geoger
{
    if (!_geoger) {
        _geoger = [[CLGeocoder alloc]init];
    }
    return _geoger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //1. 授权
    [self.manager requestAlwaysAuthorization];
    
    //2. 设置代理,  mapView
    self.mapView.delegate = self;
    //3. 创建请求对象
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    
    //4. 设置起点
    //使用导航类进行设置
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    //5. 开始导航设置
    [self.geoger geocodeAddressString:@"东莞" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //拿到终点
        MKPlacemark *place = [[MKPlacemark alloc]initWithPlacemark:placemarks.firstObject];
        //把终点封印到请求里
        request.destination = [[MKMapItem alloc]initWithPlacemark:place];
        
        //使用请求创建路径
        MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
        
        ///方向获得想要画的遮盖
        [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            //从响应中拿到, 路线数组, 遍历
            for (MKRoute *route in response.routes) {
                //添加路线中的遮盖到mapView上面
                [self.mapView addOverlay:route.polyline];
            }
        }];
    }];
    
    
}

//6. 代理方法画线
/**
 *  返回一个折线渲染器
 *
 *  @param mapView mapView
 *  @param overlay 折线模型
 */

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer =  [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    
    ///修改渲染器中的属性
    ///矢量
    [renderer setStrokeColor:[UIColor blueColor]];
    [renderer setLineWidth:10.0];
    return  renderer;
}


@end
