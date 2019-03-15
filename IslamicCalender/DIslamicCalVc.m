//
//  DIslamicCalVc.m
//  DigitalMasbaha
//
//  Created by Anish Mallik on 14/10/18.
//  Copyright © 2018 Anish. All rights reserved.
//

#import "DIslamicCalVc.h"
#import "IslamicCalendarCell.h"
#import "AppDelegate.h"
#import "IslamicCalDaysCell.h"
#import "AniApiCall.h"
#import "AniApiMethod.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface DIslamicCalVc ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>{
    int tod;
    NSInteger year,month,day;
    NSInteger currentMonth,currentYear,currentDay;
    NSIndexPath *preVsel;
}
@property (weak, nonatomic) IBOutlet UICollectionView *colIslamicCal;
@property (weak, nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblyear;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnNextMonth;
@property (weak, nonatomic) IBOutlet UIView *vwBottom;
@property (weak, nonatomic) IBOutlet UICollectionView *colDays;
@property (weak, nonatomic) IBOutlet UILabel *lblEnIslamicMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblArIslamicMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblHijriDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEnDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEnMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblEnYear;
@property (weak, nonatomic) IBOutlet UIView *vwLoading;
@property (weak, nonatomic) IBOutlet UILabel *lblToday;
@property (weak, nonatomic) IBOutlet UILabel *lblArEnToday;
@property (weak, nonatomic) IBOutlet UILabel *lblARarToday;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlCalendar;
@property (weak, nonatomic) IBOutlet UITableView *tblHoliday;

@property(nonatomic,strong)NSMutableArray *aryDays,*aryMonths,*aryHolidays;
@end

@implementation DIslamicCalVc

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.colIslamicCal registerNib:[UINib nibWithNibName:@"IslamicCalendarCell" bundle:nil] forCellWithReuseIdentifier:@"islamiccalander"];
    [self.colDays registerNib:[UINib nibWithNibName:@"IslamicCalDaysCell" bundle:nil] forCellWithReuseIdentifier:@"days"];
    self.aryDays=[[NSMutableArray alloc] initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thru",@"Fri",@"Sat", nil];
    self.aryMonths=[NSMutableArray new];
    self.title=@"Hijri Calander";
    NSDate *now = [NSDate date];
      unsigned units = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:units fromDate:now];
    self.aryHolidays=[NSMutableArray new];
     year = [components year];
     month = [components month];
     day = [components day];
    currentYear=year;
    currentDay=day;
    currentMonth=month;
   
  
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self apiCalling:month:year];
}

-(void)apiCalling:(NSInteger)month :(NSInteger)year{
    tod=0;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(month-1)];
    self.lblMonth.text=monthName;
    self.lblyear.text = [NSString stringWithFormat:@"%ld",(long)year];
    preVsel=nil;
    NSString *urlStr=[NSString stringWithFormat:@"https://api.aladhan.com/v1/gToHCalendar/%@/%@",[NSString stringWithFormat:@"%ld",(long)month],[NSString stringWithFormat:@"%ld",(long)year]];
    self.vwLoading.hidden=false;
    [[AniApiMethod sharedManager] callGETJSONMethodApi:[NSURL URLWithString:urlStr] completion:^(NSData *data, NSError *error) {
        if(data!=nil){
            NSMutableDictionary *jsonAry=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *aryLod=[jsonAry objectForKey:@"data"];
            NSMutableDictionary *dic = [aryLod objectAtIndex:0];
            NSMutableDictionary *geo=[dic objectForKey:@"gregorian"];
            NSMutableDictionary *weekday = [geo objectForKey:@"weekday"];
            NSString *today = [weekday objectForKey:@"en"];
            
            if([today isEqualToString:@"Sunday"]){
                self->tod = 0;
            }
            if([today isEqualToString:@"Monday"]){
                self->tod = 1;
            }
            if([today isEqualToString:@"Tuesday"]){
                self->tod = 2;
            }
            if([today isEqualToString:@"Wednesday"]){
                self->tod = 3;
            }
            if([today isEqualToString:@"Thursday"]){
                self->tod = 4;
            }
            if([today isEqualToString:@"Friday"]){
                self->tod = 5;
            }
            if([today isEqualToString:@"Saturday"]){
                self->tod = 6;
            }
            self.aryMonths=[jsonAry objectForKey:@"data"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.colIslamicCal reloadData];
                self.vwBottom.hidden=false;
                self.vwLoading.hidden=true;
            });
        }
    }];
    NSInteger dvi=(SCREEN_WIDTH/7);
    NSInteger ht=dvi * 5;
    self.colDays.frame=CGRectMake(0, self.colDays.frame.origin.y, SCREEN_WIDTH, dvi);
    self.colIslamicCal.frame=CGRectMake(self.colIslamicCal.frame.origin.x, self.colDays.frame.origin.y + self.colDays.frame.size.height + 1, SCREEN_WIDTH, ht+1);
    self.vwBottom.frame=CGRectMake(0, self.colIslamicCal.frame.origin.y+ ht + 3, SCREEN_WIDTH, 319);
    self.scrlCalendar.contentSize=CGSizeMake(SCREEN_WIDTH, self.vwBottom.frame.size.height +  self.vwBottom.frame.origin.y);
}
#pragma mark Uicollectionview cell
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag==2)
        return tod + self.aryMonths.count;
    else
        return self.aryDays.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag==2){
        static NSString *cellStr=@"islamiccalander";
        IslamicCalendarCell *cell=(IslamicCalendarCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellStr forIndexPath:indexPath];
        [cell.btnDate setTitle:@"" forState:UIControlStateNormal];
        [cell.btnDate setBackgroundColor:[UIColor whiteColor]];
        if(tod <=indexPath.row){
            [cell.btnDate setTitle:[NSString stringWithFormat:@"%ld",(long)((indexPath.row + 1) - tod)] forState:UIControlStateNormal];
            NSMutableDictionary *dic = [self.aryMonths objectAtIndex:indexPath.row - tod];
            NSMutableDictionary *hij=[dic objectForKey:@"hijri"];
            NSMutableArray *aryHoliday = [hij objectForKey:@"holidays"];
            if(currentMonth==month && currentYear==year){
                if(((indexPath.row + 1) - tod) == currentDay){
                    self.lblToday.hidden=false;
                    [self setDate:indexPath : cell];
                }
            }
            
            if(aryHoliday.count>0){
                [cell.btnDate setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:73.0f/255.0f blue:61.0f/255.0f alpha:1]];
            }
        }
        return cell;
    }
    else{
         static NSString *cellStr=@"days";
        IslamicCalDaysCell *cell=(IslamicCalDaysCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellStr forIndexPath:indexPath];
        cell.lblDay.text=[self.aryDays objectAtIndex:indexPath.row];
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag==2){
        if(tod <=indexPath.row){
            IslamicCalendarCell *cell =(IslamicCalendarCell *) [collectionView cellForItemAtIndexPath:indexPath];
            if(preVsel!=nil){
                IslamicCalendarCell *cellprev =(IslamicCalendarCell *) [collectionView cellForItemAtIndexPath:preVsel];
                [cellprev.btnDate setBackgroundColor:[UIColor whiteColor]];
                
            }
            
            [cell.btnDate setBackgroundColor:[UIColor colorWithRed:141.0f/255.0f green:219.0f/255.0f blue:245.0f/255.0f alpha:1]];
            [self setDate:indexPath : cell];
        }
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/7, SCREEN_WIDTH/7);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Set Hijri Value
-(void)setValue:(NSIndexPath *)indexPath :(IslamicCalendarCell *)cell{
    NSMutableDictionary *dic = [self.aryMonths objectAtIndex:indexPath.row - tod];
    NSMutableDictionary *hij=[dic objectForKey:@"hijri"];
    NSMutableDictionary *geoCal=[dic objectForKey:@"gregorian"];
     self.lblEnDate.text=[NSString stringWithFormat:@"%ld",(long)((indexPath.row + 1) - tod)];
    self.lblHijriDate.text=[hij objectForKey:@"date"];
    NSMutableDictionary *hjMonth= [hij objectForKey:@"month"];
    self.lblEnIslamicMonth.text=[hjMonth objectForKey:@"en"];
    self.lblArIslamicMonth.text = [hjMonth objectForKey:@"ar"];
    self.lblEnMonth.text=[[geoCal objectForKey:@"month"] objectForKey:@"en"];
    self.lblEnYear.text=[geoCal objectForKey:@"year"];
    self.lblToday.text=[[geoCal objectForKey:@"weekday"] objectForKey:@"en"];
    self.lblArEnToday.text=[[hij objectForKey:@"weekday"] objectForKey:@"en"];
    self.lblARarToday.text=[[hij objectForKey:@"weekday"] objectForKey:@"ar"];
    self.aryHolidays = [hij objectForKey:@"holidays"];
    if(self.aryHolidays.count>0){
         preVsel=nil;
         [cell.btnDate setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:73.0f/255.0f blue:61.0f/255.0f alpha:1]];
        
    }
    [self.tblHoliday reloadData];
}
-(void)setDate:(NSIndexPath *)indexPath :(IslamicCalendarCell *)cell{
    if(currentMonth==month && currentYear==year && (((indexPath.row + 1) - tod) == currentDay)){
        preVsel=nil;
        [cell.btnDate setBackgroundColor:[UIColor colorWithRed:131.0f/255.0f green:227.0f/255.0f blue:82.0f/255.0f alpha:1]];
        [self setValue:indexPath :cell];
        self.lblToday.text=@"Today";
    }
    else{
         preVsel=indexPath;
         [self setValue:indexPath :cell];
    }
}
#pragma mark Uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.aryHolidays.count > 0 ? self.aryHolidays.count : 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr=@"cellHoliday";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.textColor=[UIColor colorWithRed:239.0f/255.0f green:73.0f/255.0f blue:61.0f/255.0f alpha:1];
    if(self.aryHolidays.count>0){
        cell.textLabel.text=[self.aryHolidays objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text=@"No Holiday";
    }
    return cell;
}
#pragma mark Button Delegate

- (IBAction)btnNextMonth:(id)sender {
   
    if(month==12){
        month=1;
        year= year + 1;
       
    }else{
        month = month + 1;
    }
     [self apiCalling:month :year];
}
- (IBAction)btnPrevMonth:(id)sender {
    if(month==1){
        month=12;
        year = year - 1;
      
    }else{
        month = month - 1;
    }
    [self apiCalling:month :year];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
