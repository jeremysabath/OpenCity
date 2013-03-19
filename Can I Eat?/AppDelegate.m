//
//  AppDelegate.m
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "EateryDoc.h"
#import "EateryData.h"

// Stackmob
#import "StackMob.h"

@implementation AppDelegate

// Stackmob
@synthesize client = _client;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Stackmob
    // Override point for customization after application launch.
    self.client = [[SMClient alloc] initWithAPIVersion:@"0" publicKey:@"c2cebcf6-f9c1-495c-9e11-528f95052026"];
    SMCoreDataStore *coreDataStore = [self.client coreDataStoreWithManagedObjectModel:self.managedObjectModel];
    self.managedObjectContext = [coreDataStore managedObjectContext];
    
    [self loadData];
    
    return YES;
}

// Stackmob
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"mydatamodel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

float opens;
float closes;
bool isit;

- (void) loadData {
    // determine day of week and current time
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [weekdayComponents weekday];
    NSLog(@"%i", weekday);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH.mm.ss"];
    NSString *stringTime = [formatter stringFromDate:[NSDate date]];
    float time = [stringTime floatValue];
    
#pragma mark - Al's
    
    // any day but sunday
    if(weekday != 1){
        // 22
        closes = 22;
    }
    else{
        closes = 20;
    }
    // weekday 1 = Sunday for Gregorian calendar
    // use EateryDoc initializer to create 3 sample eateries, passing in title, rating, foodtype
    if(time >= 11 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *als = [[EateryDoc alloc]
                      initWithTitle:@"Al's Cafe"
                      foodtype:@"als, subs, sandwiches, dinner"
                      rating:4
                      description:@"Hungry? Come to Al's to get a delicious hot or cold sub, chips and a 20 oz. drink for less than 8 bucks!"
                      opensAt:11
                      closesAt:closes
                      isItOpen:isit
                      address:@"1350 Massachusetts Avenue, Cambridge, MA 02138"
                      number:@"tel:6174419100"
                      website:@"http://www.alscafes.com/"
                      thumbImage:[UIImage imageNamed:@"AlsThumb.jpg"]
                      fullImage:[UIImage imageNamed:@"Als.jpg"]
                      latitude:+42.37309260
                      longitude:-71.11828910
                      distance:111111];
    NSLog(@"isit = %i", isit);
    
    
#pragma mark - Annenberg

    // weekday breakfast
    if (time < 10 && weekday != 1){
        opens = 7.3;
        closes = 10;
    }
    // weekday lunch
    else if (time >= 10 && time < 14.15 && weekday != 1) {
        opens = 11.30;
        closes = 14.15;
    }
    // dinner
    else if (time >= 14.15 && time < 19.15){
        opens = 16.30;
        closes = 19.15;
    }
    // Sunday brunch
    else if (time < 14.15 && weekday == 1) {
        opens = 11.3;
        closes = 14;
    }
    // brain break Sun-Thurs
    else if (time >= 19.15 && (weekday >= 1 && weekday <= 5)) {
        opens = 21.15;
        closes = 22.45;
    }
    
    else {
        opens = 7.30;
        closes = 19.15;
    }
    
    if(time >= opens && time <= closes){
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *annenberg = [[EateryDoc alloc]
                            initWithTitle:@"Annenberg"
                            foodtype:@"cafeteria, dinner"
                            rating:3
                            description:@"Harvard's famous freshman dining hall. Only for Harvard College freshman and their paid guests. Watch out for the obscure hours!"
                            opensAt:opens
                            closesAt:closes
                            isItOpen:isit
                            address:@"45 Quincy Street, Cambridge, MA 02138"
                            number:@"NONE"
                            website:@"http://www.dining.harvard.edu/residential_dining/halls_hours.html"
                            thumbImage:[UIImage imageNamed:@"annenbergThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"annenberg.jpg"]
                            latitude:42.37622030
                            longitude:-71.11505030
                            distance:111111];
    
#pragma mark - Felipe's
    // if it's before midnight on th, fr, sat
    if((time <= 24.00 && time >=6) && (weekday == 5 || weekday == 6 || weekday == 7)){
        closes = 2;
    }
    // if it's after midnight on th, fri, sat
    else if(time < 6 &&(weekday == 6 || weekday == 7 || weekday == 1)){
        closes = 2;
    }
    else{
        closes = 24.00;
    }
    
    if (closes == 2) {
        if (time >= 11 || time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= 11 && time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    EateryDoc *felipes = [[EateryDoc alloc]
                          initWithTitle:@"Felipe's"
                          foodtype:@"Burritos, Mexican, dinner, cheap"
                          rating:4
                          description:@"Perfect for a late-night snack...or a late breakfast. Quick, cheap and  delicious."
                          opensAt:11
                          closesAt:closes
                          isItOpen:isit
                          address:@"83 Mount Auburn Street, Cambridge, MA 02138"
                          number:@"tel:6173549944"
                          website:@"http://www.felipestaqueria.com/"
                          thumbImage:[UIImage imageNamed:@"felipesThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"felipes.jpg"]
                          latitude:42.37251330
                          longitude:-71.11977260
                          distance:111111];
    
#pragma mark - Otto
    
    // if it's before midnight Sun-Thursday
    if((time <= 24.00 && time > 6) && (weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5)) {
        closes = 1;
    }
    // if it's after midnight Sun-Thurs
    else if(time <= 6 && (weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 || weekday == 6)) {
        closes = 2;
    }
    // any other time
    else {
        closes = 2;
    }
    
    if (time >= 10.3 || time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *otto = [[EateryDoc alloc]
                       initWithTitle:@"Otto"
                       foodtype:@"Pizza, dinner"
                       rating:4
                       description:@"New York style thin-crust pizza with a variety of creative and exciting toppings!"
                       opensAt:10.3
                       closesAt:closes
                       isItOpen:isit
                       address:@"1432 Massachusetts Avenue, Cambridge, MA 02138"
                       number:@"tel:6174993352"
                       website:@"http://ottocambridge.com/"
                       thumbImage:[UIImage imageNamed:@"ottoThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"otto.jpg"]
                       latitude:42.37413430
                       longitude:-71.11899080
                       distance:111111];
    
#pragma mark - Pinocchio's
    
    // if sunday
    if(weekday == 1){
        opens = 13;
        closes = 24.00;
    }
    // if before midnight on Mon-Thurs
    else if(time <= 24.00 && (weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5)){
        opens = 11;
        closes = 1;
    }
    // if after midnight on Mon-Thurs
    else if(time <= 6 && (weekday == 3 || weekday == 4 || weekday == 5 || weekday == 6)){
        opens = 11;
        closes = 1;
    }
    // if Fri or Sat
    else{
        opens = 11;
        closes = 2.30;
    }
    
    if (closes <= 2.3) {
        if (time >= opens || time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= opens && time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    EateryDoc *pinocchios = [[EateryDoc alloc]
                             initWithTitle:@"Pinocchio's"
                             foodtype:@"Pizza, nocchs, nochs, subs, pinnochios, pinnocchios, dinner, cheap"
                             rating:4
                             description:@"Addictive thick crust Sicilian slices with flavorful hot subs to boot. Late-night hours!"
                             opensAt:opens
                             closesAt:closes
                             isItOpen:isit
                             address:@"74 Winthrop Street, Cambridge, MA 02138"
                             number:@"tel:6178764897"
                             website:@"http://pinocchiospizza.net/"
                             thumbImage:[UIImage imageNamed:@"pinocchiosThumb.jpg"]
                             fullImage:[UIImage imageNamed:@"pinocchios.jpg"]
                             latitude:42.37198330
                             longitude:-71.12023590
                             distance:111111];
    
#pragma mark - Mr. Bartley's
    // if NOT Sunday
    if(weekday != 1){
        closes = 21;
    }
    // if Sunday
    else{
        closes = 25;
    }
    
    if (weekday == 1){
        isit = NO;
    }
    else if (time >= 11 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *mrBartleys = [[EateryDoc alloc]
                             initWithTitle:@"Mr. Bartley's"
                             foodtype:@"Burgers, shakes, french fries, grill, pub, dinner"
                             rating:3
                             description:@"Come to Mr. Bartley's for famous burgers, shakes and fries! Cash only!"
                             opensAt:11
                             closesAt:closes
                             isItOpen:isit
                             address:@"1246 Massachusetts Ave Cambridge, MA 02138"
                             number:@"tel:6173546559"
                             website:@"http://www.mrbartley.com/"
                             thumbImage:[UIImage imageNamed:@"mrBartleysThumb.jpg"]
                             fullImage:[UIImage imageNamed:@"mrBartleys.jpg"]
                             latitude:42.37247440
                             longitude:-71.11609380
                             distance:111111];
    
#pragma  mark - Au Bon Pain
    
    // if Mon-Fri before midnight
    if ((time >= 5 && time <= 24) && (weekday != 1 && weekday != 7)) {
        opens = 5.3;
        closes = 24;
    }
    // Mon-Fri after midnight
    else if (time < 5 && (weekday != 2 && weekday != 1)) {
        opens = 5.3;
        closes = 24;
    }
    // if Sun before midnight
    else if ((time >= 5 && time <= 24) && weekday == 1) {
        opens = 6;
        closes = 24;
    }
    // Sun after midnight
    else if (time < 5 && weekday == 2) {
        opens = 6;
        closes = 24;
    }
    // if Sat before midnight
    else if ((time >= 5 && time <= 24) && weekday == 7) {
        opens = 5.3;
        closes = 1;
    }
    // Sat after midnight
    else if (time < 5 && weekday == 1) {
        opens = 5.3;
        closes = 1;
    }
    
    
    if (closes == 1) {
        if (time >= opens || time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= opens && time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    EateryDoc *auBonPain = [[EateryDoc alloc]
                            initWithTitle:@"Au Bon Pain"
                            foodtype:@"salads, sandwiches, dinner, cheap"
                            rating:3
                            description:@"Just outside of the yard, Au Bon Pain provides savory breads and sandwiches along with fresh soups and salads!"
                            opensAt:opens
                            closesAt:closes
                            isItOpen:isit
                            address:@"1360 Massachusetts Ave, Cambridge, MA 02138"
                            number:@"tel:6174979797"
                            website:@"http://www.aubonpain.com/"
                            thumbImage:[UIImage imageNamed:@"abpThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"abp.jpg"]
                            latitude:42.3730660
                            longitude:-71.1184930
                            distance:111111];
    
#pragma mark - b.good
    
    // if sunday
    if (weekday == 1){
        closes = 21;
    }
    // if Mon-Sat
    else {
        closes = 22;
    }
    
    if (time >= 11 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *bGood = [[EateryDoc alloc]
                        initWithTitle:@"b.good"
                        foodtype:@"burgers, french fries, salads, milkshakes, shakes, dinner, cheap"
                        rating:3
                        description:@"b.good makes fast-food 'real.' Come on down for fresh burgers, shakes, fries and salads!"
                        opensAt:11
                        closesAt:closes
                        isItOpen:isit
                        address:@"24 Dunster Street, Cambridge , MA 02138"
                        number:@"tel:6173546500"
                        website:@"http://www.bgood.com/"
                        thumbImage:[UIImage imageNamed:@"bGoodThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"bGood.jpg"]
                        latitude:42.3726189
                        longitude:-71.1191012
                        distance:111111];
#pragma  mark - Ben and Jerry's
    
    if (time >= 9 && time <= 22) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *benAndJerrys = [[EateryDoc alloc]
                               initWithTitle:@"Ben & Jerry's"
                               foodtype:@"ice cream, sundaes, milkshakes, smoothies, dessert"
                               rating:4
                               description:@"Looking for a classic? Ben and Jerry's provides some of the most exciting and delicious ice cream flavors around. Stop by The Garage for a scoop, sundae or shake!"
                               opensAt:9
                               closesAt:22
                               isItOpen:isit
                               address:@"36 JFK Street, Cambridge, MA 02138"
                               number:@"tel:6178642828"
                               website:@"http://www.benjerry.com/"
                               thumbImage:[UIImage imageNamed:@"benAndJerrysThumb.jpg"]
                               fullImage:[UIImage imageNamed:@"benAndJerrys.jpg"]
                               latitude:42.3726417
                               longitude:-71.1198562
                               distance:111111];
    
#pragma mark = BerryLine
    
    // if Thurs-Sat
    if(weekday == 5 || weekday == 6 || weekday == 7){
        closes = 24;
    }
    else{
        closes = 23;
    }
    
    if (time >= 12 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *berryLine = [[EateryDoc alloc]
                            initWithTitle:@"BerryLine"
                            foodtype:@"frozen yogurt, froyo, fresh, fruit, dessert, ice cream"
                            rating:3
                            description:@"BerryLine provides delicious (and nutritious?) frozen yogurt. With flavors constantly in the rotation you'll be sure to find something to sweeten your day!"
                            opensAt:12
                            closesAt:closes
                            isItOpen:isit
                            address:@"3 Arrow Street, Cambridge, MA 02138"
                            number:@"tel:6178683500"
                            website:@"http://www.berryline.com/"
                            thumbImage:[UIImage imageNamed:@"berryLineThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"berryLine.jpg"]
                            latitude:42.3710162
                            longitude:-71.1141269
                            distance:111111];
#pragma mark - Bertucci's
    
    // if Fri-Sat
    if (weekday == 6 || weekday == 7) {
        closes = 23;
    }
    else {
        closes = 22;
    }
    
    if (time >= 11 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *bertuccis = [[EateryDoc alloc]
                            initWithTitle:@"Bertucci's"
                            foodtype:@"pizza, italian, pasta, salads, soups, dinner"
                            rating:4
                            description:@"Stop by Bertucci's for a casual Italian meal with fresh pizza or a baked pasta dish. Don't forget to the try the soup! And absolutely do not leave without rolls for the road."
                            opensAt:11
                            closesAt:closes
                            isItOpen:isit
                            address:@"21 Brattle Street, Cambridge, MA 02138"
                            number:@"tel:6178644748"
                            website:@"http://www.bertuccis.com/"
                            thumbImage:[UIImage imageNamed:@"bertuccisThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"bertuccis.jpg"]
                            latitude:42.3734069
                            longitude:-71.1204517
                            distance:111111];
    
#pragma  mark - Boloco
    
    if (time >= 7 && time <= 23) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *boloco = [[EateryDoc alloc]
                         initWithTitle:@"Boloco"
                         foodtype:@"burritos, smoothies, coffee, dinner, cheap"
                         rating:3
                         description:@"Drop into Boloco to try a fresh burrito or scrumptious smoothie."
                         opensAt:7
                         closesAt:23
                         isItOpen:isit
                         address:@"71 Mt. Auburn Street, Cambridge, MA 02138"
                         number:@"tel:6173545838"
                         website:@"http://boloco.com/"
                         thumbImage:[UIImage imageNamed:@"bolocoThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"boloco.jpg"]
                         latitude:42.3720326
                         longitude:-71.1182373
                         distance:111111];
#pragma mark - BonChon
    
    if (time >= 11.3 && time <= 23.30) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *bonChon = [[EateryDoc alloc]
                          initWithTitle:@"BonChon"
                          foodtype:@"korean, bbq, barbecue, asian, bon chon, wings, dinner"
                          rating:4
                          description:@"Looking for something different? Try BonChon's Korean BBQ! Entrees are prepared in front of you and everything is cooked to perfection. Go for the soy garlic wings!"
                          opensAt:11.3
                          closesAt:23.30
                          isItOpen:isit
                          address:@"57 JFK Street, Cambridge, MA 02138"
                          number:@"tel:6178680981"
                          website:@"http://www.bonchon.com/"
                          thumbImage:[UIImage imageNamed:@"bonChonThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"bonChon.jpg"]
                          latitude:42.3721459
                          longitude:-71.1209169
                          distance:111111];
    
#pragma mark - Border Cafe
    
    // if Sunday before midight
    if(time <= 24 && weekday == 1){
        opens = 12;
        closes = 24;
    }
    // if Sunday after midnight
    else if (time <= 5 && weekday == 2) {
        opens = 12;
        closes = 24;
    }
    // if Thursday after midnight
    else if (time <= 5 && weekday == 6) {
        opens = 11;
        closes = 1;
    }
    // if Fri-Sat before midnight
    else if (time <= 24 && (weekday == 6 || weekday == 7)){
        opens = 11;
        closes = 2;
    }
    // if Fri-Sat after midnight
    else if (time <= 5 && (weekday == 7 || weekday == 1)){
        opens = 11;
        closes = 2;
    }
    else {
        opens = 11;
        closes = 1;
    }
    
    if (closes <= 2) {
        if (time >= opens || time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= opens && time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    
    EateryDoc *borderCafe = [[EateryDoc alloc]
                             initWithTitle:@"Border Cafe"
                             foodtype:@"mexican, quesadillas, margeritas, margaritas dinner, bar"
                             rating:4
                             description:@"Come to Border Cafe for tasty Tex-Mex. With cool decor, cheesy quesadillas, homemade chips and fresh margaritas, there's not a lot to complain about!"
                             opensAt:opens
                             closesAt:closes
                             isItOpen:isit
                             address:@"32 Church Street, Cambridge, MA 02138"
                             number:@"tel:6178646100"
                             website:@"http://www.bordercafe.com/"
                             thumbImage:[UIImage imageNamed:@"borderCafeThumb.jpg"]
                             fullImage:[UIImage imageNamed:@"borderCafe.jpg"]
                             latitude:42.3743145
                             longitude:-71.1202433
                             distance:111111];
    
#pragma mark - Burdick's Chocolates
    
    if(weekday == 6 || weekday == 7){
        closes = 22;
    }
    else {
        closes = 21;
    }
    
    if (time >= 8 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *burdicks = [[EateryDoc alloc]
                           initWithTitle:@"L.A. Burdick Chocolates"
                           foodtype:@"chocolate, pastries, tea, dessert"
                           rating:4
                           description:@"Burdick's Chocolates is the place to go for a savory treat at any time. Try the tea too!"
                           opensAt:8
                           closesAt:closes
                           isItOpen:isit
                           address:@"52D Brattle Street, Cambridge, MA 02138"
                           number:@"tel:6174914340"
                           website:@"http://www.burdickchocolate.com/"
                           thumbImage:[UIImage imageNamed:@"burdicksThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"burdicks.jpg"]
                           latitude:42.3742859
                           longitude:-71.1219163
                           distance:111111];
    
    
#pragma mark - Cafe Pamplona
    
    if (time >= 11 && time <= 24) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *pamplona = [[EateryDoc alloc]
                           initWithTitle:@"Café Pamplona"
                           foodtype:@"coffee, tea, panini, soup, dessert"
                           rating:3
                           description:@"Café Pamplona has been a Harvard Square staple since 1958. Come by for some of the finest coffees and teas around. Don't forget to try the paninis!"
                           opensAt:11
                           closesAt:24
                           isItOpen:isit
                           address:@"12 Bow Street, Cambridge, MA 02138"
                           number:@"tel:6174920352"
                           website:@"http://www.yelp.com/biz/cafe-pamplona-cambridge"
                           thumbImage:[UIImage imageNamed:@"pamplonaThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"pamplona.jpg"]
                           latitude:42.371751
                           longitude:-71.115472
                           distance:111111];
    
#pragma mark - Cafe Sushi
    
    // if it's dinner on Friday or Saturday
    if (time >= 17.30 && (weekday == 6 || weekday == 7)) {
        opens = 17.30;
        closes = 22.30;
    }
    // if it's lunch
    else if (time <= 17.30 && weekday != 1) {
        opens = 12;
        closes = 14.30;
    }
    // if it's dinner not Friday or Saturday
    else if (time >= 17.30 && weekday != 6 && weekday != 7) {
        opens = 17.30;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *sushi = [[EateryDoc alloc]
                        initWithTitle:@"Cafe Sushi"
                        foodtype:@"sushi, japanese, asian, dinner"
                        rating:4
                        description:@"Café Sushi serves fresh sushi and authentic Japanese food. Seatings for lunch and dinner!"
                        opensAt:opens
                        closesAt:closes
                        isItOpen:isit
                        address:@"1105 Massachusetts Avenue, Cambridge, MA 02138"
                        number:@"tel:6174920434"
                        website:@"http://cafesushicambridge.com/"
                        thumbImage:[UIImage imageNamed:@"sushiThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"sushi.jpg"]
                        latitude:42.370649
                        longitude:-71.1136497
                        distance:111111];
    
#pragma mark - Cambridge, 1
    
    if (time >= 11.30 || time <= 1) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *cambridge = [[EateryDoc alloc]
                            initWithTitle:@"Cambridge, 1"
                            foodtype:@"pizza, beer, bar, dinner"
                            rating:4
                            description:@"Cambridge, 1 is a hip place to grab a pizza, a beer, or a little of both! Booth and bar seating!"
                            opensAt:11.30
                            closesAt:1
                            isItOpen:isit
                            address:@"27 Church Street, Cambridge , MA 02138"
                            number:@"tel:6175761111"
                            website:@"http://www.cambridge1.us/"
                            thumbImage:[UIImage imageNamed:@"cambridgeThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"cambridge.jpg"]
                            latitude:42.3744747
                            longitude:-71.1200351
                            distance:111111];
    
#pragma mark - Cardullo's
    
    if(weekday == 1){
        opens = 10;
        closes = 19;
    }
    else {
        opens = 9;
        closes = 21;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *cardullos = [[EateryDoc alloc]
                            initWithTitle:@"Cardullo's"
                            foodtype:@"gourmet, sandwiches, deli, coffee, tea, chocolate, wine, champagne"
                            rating:4
                            description:@"Cardullo's, owned by the Cardullo family since 1950, is a Cambridge classic. Stop by for a gourmet deli sandwich prepared with artisan bread or a special bar of chocolate. Check out all of the delicacies this market extraordinaire has to offer!"
                            opensAt:opens
                            closesAt:closes
                            isItOpen:isit
                            address:@"6 Brattle Street, Cambridge, MA 02138"
                            number:@"tel:6174918888"
                            website:@"http://www.cardullos.com/"
                            thumbImage:[UIImage imageNamed:@"cardullosThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"cardullos.jpg"]
                            latitude:42.3733883
                            longitude:-71.1197592
                            distance:111111];
    
#pragma mark - Charlie's Kitchen
    
    // if it's before midnight on th, fri, sat
    if(time <= 24 && (weekday == 5 || weekday == 6 || weekday == 7)){
        closes = 2;
    }
    // if it's after midnight on th, fri, sat
    else if (time <= 5 && (weekday == 6 || weekday == 7 || weekday == 1)){
        closes = 2;
    }
    // if it's before midnight NOT on th, fri, sat
    else if (time <= 24 && weekday != 5 && weekday != 6 && weekday != 7){
        closes = 1;
    }
    // if it's after midnight NOT on th, fri, sat
    else {
        closes = 1;
    }
    
    if (time >= 11 || time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *charlies = [[EateryDoc alloc]
                           initWithTitle:@"Charlie's Kitchen"
                           foodtype:@"burgers, french fries, beer, grill, pub, dinner"
                           rating:5
                           description:@"You know that burger you've been craving? Charlie's Kitchen is just waiting for you to order it. The burgers are big, the beers are endless and the music is just right."
                           opensAt:11
                           closesAt:closes
                           isItOpen:isit
                           address:@"10 Eliot Street, Cambridge, MA 02138"
                           number:@"tel:6174929646"
                           website:@"http://www.charlieskitchen.com/"
                           thumbImage:[UIImage imageNamed:@"charliesThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"charlies.jpg"]
                           latitude:42.3724547
                           longitude:-71.1214953
                           distance:111111];
    
#pragma mark - Chipotle Mexican Grill
    
    if (time >= 11 && time <= 22) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *chipotle = [[EateryDoc alloc]
                           initWithTitle:@"Chipotle Mexican Grill"
                           foodtype:@"mexican, burritos, dinner, cheap"
                           rating:4
                           description:@"Big burritos. Big taste. Come to Chipotle for kickin' Mexican food. Try the burrito bowl! More burrito, less mess!"
                           opensAt:11
                           closesAt:22
                           isItOpen:isit
                           address:@"1 Brattle Square, Cambridge, MA 02138"
                           number:@"tel:6174910677"
                           website:@"http://www.chipotle.com/en-US/Default.aspx?type=default"
                           thumbImage:[UIImage imageNamed:@"chipotleThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"chipotle.jpg"]
                           latitude:42.373199
                           longitude:-71.1211545
                           distance:111111];
    
#pragma mark - Chutney's
    
    if (time >= 11 && time <= 24) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *chutneys = [[EateryDoc alloc]
                           initWithTitle:@"Chutney's"
                           foodtype:@"indian, paninis, dinner, cheap"
                           rating:3
                           description:@"Indian food for everybody! Chutney's makes flavorful Indian dishes unlike what you'll find just about anywhere else!"
                           opensAt:11
                           closesAt:24
                           isItOpen:isit
                           address:@"36 JFK Street, Cambridge, MA 02138"
                           number:@"tel:6174912545"
                           website:@"http://chutneysma.com/"
                           thumbImage:[UIImage imageNamed:@"chutneysThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"chutneys.jpg"]
                           latitude:42.3726417
                           longitude:-71.1198562
                           distance:111111];
    
#pragma mark - Clover
    
    if (time >= 7 && time <= 24) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *clover = [[EateryDoc alloc]
                         initWithTitle:@"Clover"
                         foodtype:@"vegetarian, sandwiches, salads, soups, french fries"
                         rating:4
                         description:@"Fast food done different! Clover crafts gourmet fast foods each and every day. With new menu items each day of the week, there's always something new and delicious to try."
                         opensAt:7
                         closesAt:24
                         isItOpen:isit
                         address:@"7 Holyoke Street, Cambridge, MA 02138"
                         number:@"NONE"
                         website:@"http://www.cloverfoodlab.com/"
                         thumbImage:[UIImage imageNamed:@"cloverThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"clover.jpg"]
                         latitude:42.3725081
                         longitude:-71.1182788
                         distance:111111];
    
#pragma mark - Crazy Dough's Pizza Co.
    
    if(weekday == 1){
        opens = 12;
        closes = 21;
    }
    else {
        opens = 11;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *crazyDoughs = [[EateryDoc alloc]
                              initWithTitle:@"Crazy Dough's Pizza Co."
                              foodtype:@"pizza, dinner, cheap"
                              rating:4
                              description:@"Feeling crazy?! Well, either way it'd be crazy not to go to Crazy Dough's Pizza Co. Walk up the stairs in the garage for flavorful pizza with fresh and exciting toppings."
                              opensAt:opens
                              closesAt:closes
                              isItOpen:isit
                              address:@"36 JFK Street, Cambridge, MA 02138"
                              number:@"tel:6174924848"
                              website:@"http://www.crazydoughs.com/"
                              thumbImage:[UIImage imageNamed:@"crazyDoughsThumb.jpg"]
                              fullImage:[UIImage imageNamed:@"crazyDoughs.jpg"]
                              latitude:42.3726417
                              longitude:-71.1198562
                              distance:111111];
    
#pragma mark - Crema Cafe
    
    if (weekday == 6 || weekday == 7){
        opens = 8;
    }
    else {
        opens = 7;
    }
    
    if (time >= opens && time <= 21) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *crema = [[EateryDoc alloc]
                        initWithTitle:@"Crema Cafe"
                        foodtype:@"cafe, coffee, sandwiches, dessert"
                        rating:3
                        description:@"Cozy up with Crema Cafe. Here, you can sip high-quality coffee, indulge in flavorful sandwiches and always feel right at home."
                        opensAt:opens
                        closesAt:21
                        isItOpen:isit
                        address:@"27 Brattle Street, Cambridge, MA 02138"
                        number:@"tel:6178762700"
                        website:@"http://cremacambridge.com/"
                        thumbImage:[UIImage imageNamed:@"cremaThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"crema.jpg"]
                        latitude:42.3732534
                        longitude:-71.1207538
                        distance:111111];
    
#pragma mark - Dado Tea
    // Mon-Fri
    if (weekday != 7 && weekday != 1){
        opens = 8;
        closes = 21;
    }
    
    // Sat
    else if (weekday == 7){
        opens = 10;
        closes = 21;
    }
    // Sun
    else if (weekday == 1) {
        opens = 10;
        closes = 20;
    }
    
    if (time >= opens && time <= closes){
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *dado = [[EateryDoc alloc]
                       initWithTitle:@"Dado Tea"
                       foodtype:@"tea, sandwiches, wraps, salads"
                       rating:3
                       description:@"Dado Tea strives to provide healthy, wholesome and - most importantly - delicious food. Stop in for high quality teas, salads, sandwiches and wraps."
                       opensAt:opens
                       closesAt:closes
                       isItOpen:isit
                       address:@"50 Church Street, Cambridge, MA 02138"
                       number:@"tel:6175470950"
                       website:@"http://www.dadotea.com"
                       thumbImage:[UIImage imageNamed:@"dadoThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"dado.jpg"]
                       latitude:42.3741968
                       longitude:-71.1206414
                       distance:111111];
    
#pragma mark - Darwin's
    
    if (weekday == 1){
        opens = 7;
    }
    else {
        opens = 6.3;
    }
    
    if (time >= opens && time <= 21) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *darwins = [[EateryDoc alloc]
                          initWithTitle:@"Darwin's"
                          foodtype:@"sandwiches, coffee, dinner"
                          rating:5
                          description:@"Darwin's is one of those places you just keep going back to. The sandwiches are incredible, the music is fresh and the people are great. A must-see."
                          opensAt:opens
                          closesAt:21
                          isItOpen:isit
                          address:@"148 Mount Auburn Street, Cambridge, MA 02138"
                          number:@"tel:6173545233"
                          website:@"http://darwinsltd.com/"
                          thumbImage:[UIImage imageNamed:@"darwinsThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"darwins.jpg"]
                          latitude:42.3740664
                          longitude:-71.1251335
                          distance:111111];
    
#pragma mark - Dunkin' Donuts
    
    if (time >= 6 && time <= 24) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *dunkin = [[EateryDoc alloc]
                         initWithTitle:@"Dunkin' Donuts"
                         foodtype:@"coffee, donuts, cheap"
                         rating:5
                         description:@"It's Dunkin' Donuts!"
                         opensAt:6
                         closesAt:24
                         isItOpen:isit
                         address:@"65 JFK Street, Cambridge, MA 02138"
                         number:@"tel:6173545096"
                         website:@"http://www.dunkindonuts.com/dunkindonuts/en.html"
                         thumbImage:[UIImage imageNamed:@"dunkinThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"dunkin.jpg"]
                         latitude:42.3714451
                         longitude:-71.1210993
                         distance:111111];
    
#pragma mark - Falafel Corner
    
    // Sunday
    if (weekday == 1){
        closes = 24;
    }
    else {
        closes = 3;
    }
    
    if (weekday == 1) {
        if (time >= 11 && time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= 11 || time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    EateryDoc *falafel = [[EateryDoc alloc]
                          initWithTitle:@"Falafel Corner"
                          foodtype:@"falafel, greek, cheap"
                          rating:3
                          description:@"Falafel Corner gives you all of the Mediterranean food you want. Great falafel, shawarma, grape leaves... and don't forget the baba ghanouj."
                          opensAt:11
                          closesAt:closes
                          isItOpen:isit
                          address:@"8 Eliot Street, Cambridge, MA 02138"
                          number:@"tel:6174418888"
                          website:@"http://falafelcorner.eat24hour.com/"
                          thumbImage:[UIImage imageNamed:@"falafelThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"falafel.jpg"]
                          latitude:42.3725867
                          longitude:-71.1215271
                          distance:111111];
    
#pragma mark - Finale
    
    // if Sun-Monday
    if (weekday == 1 || weekday == 2){
        closes = 23;
    }
    // if Tues-Thurs
    else if (weekday == 3 || weekday == 4 || weekday == 5) {
        closes = 23.30;
    }
    // if Fri-Sat before midnight
    else {
        closes = 24;
    }
    
    if (time >= 11 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *finale = [[EateryDoc alloc]
                         initWithTitle:@"Finale"
                         foodtype:@"dessert, pastry, cake, chocolate, coffee"
                         rating:3
                         description:@"Finale Desserterie & Bakery makes decadent desserts and snacks all day long. Stop by for something rich!"
                         opensAt:11
                         closesAt:closes
                         isItOpen:isit
                         address:@"30 Dunster Street, Cambridge, MA 02138"
                         number:@"tel:6174419797"
                         website:@"http://www.finaledesserts.com/"
                         thumbImage:[UIImage imageNamed:@"finaleThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"finale.jpg"]
                         latitude:42.3724468
                         longitude:-71.119202
                         distance:111111];
    
#pragma  mark - FiRE + iCE
    
    // Monday-Thursday
    if (weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5) {
        opens = 11.30;
        closes = 22;
    }
    // Friday-Saturday
    else if (weekday == 6 || weekday == 7) {
        opens = 11.30;
        closes = 23;
    }
    // Sunday
    else if (weekday == 1) {
        opens = 10;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *fire = [[EateryDoc alloc]
                       initWithTitle:@"FiRE + iCE"
                       foodtype:@"burgers, bar, dinner"
                       rating:3
                       description:@"FiRE + iCE, the improvisational grill. Here, you pick your ingredients and your sauce and then watch your creation come to life on the big round grill in the center of the restaurant. Don't forget to check out the well-stocked bar!"
                       opensAt:opens
                       closesAt:closes
                       isItOpen:isit
                       address:@"50 Church St, Cambridge, MA 02138"
                       number:@"tel:6175479007"
                       website:@"http://www.fire-ice.com/"
                       thumbImage:[UIImage imageNamed:@"fireThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"fire.jpg"]
                       latitude:42.3741968
                       longitude:-71.1206414
                       distance:111111];
    
#pragma mark - First Printer Restaurant Bar & Grill
    
    // Monday-Saturday before midnight
    if (time <= 24 && weekday != 1) {
        opens = 11.30;
        closes = 1;
    }
    // Monday-Saturday after midnight
    else if (time <= 5 && weekday != 2) {
        opens = 11.30;
        closes = 1;
    }
    // Sunday
    else {
        opens = 10;
        closes = 24;
    }
    
    if (closes == 1) {
        if (time >= opens || time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= opens && time <= closes){
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    
    EateryDoc *firstPrinter = [[EateryDoc alloc]
                               initWithTitle:@"First Printer Restaurant Bar & Grill"
                               foodtype:@"bar, grill, wine, dinner"
                               rating:3
                               description:@"First Printer is a great place to go no matter what type of food you're looking for. With an extensive list of entrees, wines, beers and cocktails, you can always find something to suit your fancy."
                               opensAt:opens
                               closesAt:closes
                               isItOpen:isit
                               address:@"15 Dunster Street, Cambridge , MA 02138"
                               number:@"tel:6174970900"
                               website:@"http://thefirstprinter.com/"
                               thumbImage:[UIImage imageNamed:@"firstPrinterThumb.jpg"]
                               fullImage:[UIImage imageNamed:@"firstPrinter.jpg"]
                               latitude:42.3729744
                               longitude:-71.1189416
                               distance:111111];
    
#pragma  mark - Flat Patties
    
    if (weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4) {
        closes = 22;
    }
    
    else {
        closes = 23;
    }
    
    if (time >= 11.30 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *flatPatties = [[EateryDoc alloc]
                              initWithTitle:@"Flat Patties"
                              foodtype:@"grill, burger, sandwiches, french fries, dessert, dinner"
                              rating:3
                              description:@"Flat Patties serves up a variety of classic American food. Come for delicious burgers, sandwiches, hand cut fries and even decadent desserts!"
                              opensAt:11.30
                              closesAt:closes
                              isItOpen:isit
                              address:@"33 Brattle Street, Cambridge, MA 02138"
                              number:@"tel:6178716871"
                              website:@"http://www.flatpatties.com/"
                              thumbImage:[UIImage imageNamed:@"flatPattiesThumb.jpg"]
                              fullImage:[UIImage imageNamed:@"flatPatties.jpg"]
                              latitude:42.3735254
                              longitude:-71.1209047
                              distance:111111];
    
#pragma mark - Grafton Street Pub & Grill
    
    // Thursday-Saturday before midnight
    if (time <= 24 && (weekday >= 5 && weekday <= 7)){
        closes = 2;
    }
    else if (time <= 5 && (weekday == 6 || weekday == 7 || weekday == 1)) {
        closes = 2;
    }
    else if (time <= 24 && (weekday >= 1 && weekday <= 4)) {
        closes = 1;
    }
    else {
        closes = 1;
    }
    
    if (time >= 11 || time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *grafton = [[EateryDoc alloc]
                          initWithTitle:@"Grafton Street Pub & Grill"
                          foodtype:@"grill, pub, pizza, burger, sandwiches, salads, dinner"
                          rating:3
                          description:@"Stop by Grafton Street Pub & Grill, for a great entree, sandwich or salad. Check out the buttermilk mashed potatoes!"
                          opensAt:11
                          closesAt:closes
                          isItOpen:isit
                          address:@"1230 Massachusetts Avenue, Cambridge, MA 02138"
                          number:@"tel:6174970400"
                          website:@"http://www.graftonstreetcambridge.com/"
                          thumbImage:[UIImage imageNamed:@"graftonThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"grafton.jpg"]
                          latitude:42.3723329
                          longitude:-71.1158832
                          distance:111111];
    
#pragma  mark - Grendel's Den
    
    if (time >= 11.3 || time <= 1) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *grendels = [[EateryDoc alloc]
                           initWithTitle:@"Grendel's Den"
                           foodtype:@"grill, pub, bar, burger, french fries, sandwiches, salads, dinner"
                           rating:4
                           description:@"Grendel's Den is a Harvard Square classic for great food and great beer. They have an extensive selection of beers as well as great burgers and sandwiches. Stop by on Sunday's between 5 and 7.30 for happy hour!"
                           opensAt:11.30
                           closesAt:1
                           isItOpen:isit
                           address:@"89 Winthrop Street, Cambridge, MA 02138"
                           number:@"tel:6174911160"
                           website:@"http://www.grendelsden.com/"
                           thumbImage:[UIImage imageNamed:@"grendelsThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"grendels.jpg"]
                           latitude:42.3723652
                           longitude:-71.120898
                           distance:111111];
    
#pragma mark - Harvest
    
    // Lunch Monday-Saturday
    if (time < 17.3 && (weekday != 1)) {
        opens = 12;
        closes = 14.30;
    }
    // Dinner Monday-Thursday
    else if ((time >= 17.30 && time <= 24) && (weekday >= 2 && weekday <= 5)) {
        opens = 17.3;
        closes = 22;
    }
    // Dinner Friday-Saturday
    else if ((time >= 17.30 && time <= 24) && (weekday == 6 || weekday == 7)) {
        opens = 17.3;
        closes = 23;
    }
    // Sunday Brunch
    else if (time < 17.3 && weekday ==1) {
        opens = 11.3;
        closes = 14.3;
    }
    // Sunday Dinner
    else if ((time >= 17.3 && time <= 24) && weekday == 1) {
        opens = 17.3;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *harvest = [[EateryDoc alloc]
                          initWithTitle:@"Harvest"
                          foodtype:@"sandwiches, dinner"
                          rating:4
                          description:@"Visit Harvest for a fine-dining experience complete with modern show kitchen, heated patio and, of course, excellent food."
                          opensAt:opens
                          closesAt:closes
                          isItOpen:isit
                          address:@"44 Brattle Street, Cambridge, MA 02138"
                          number:@"tel:6178682255"
                          website:@"http://harvestcambridge.com/"
                          thumbImage:[UIImage imageNamed:@"harvestThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"harvest.jpg"]
                          latitude:42.3739314
                          longitude:-71.1216376
                          distance:111111];
    
#pragma mark - Hong Kong Restaurant
    
    // Thurs before midnight
    if (time <= 24 && weekday == 5) {
        closes = 2.30;
    }
    
    // Thurs after midnight
    else if (time <= 5 && weekday == 6) {
        closes = 2.30;
    }
    
    // Fri-Sat before midnight
    else if (time <= 24 && (weekday == 6 || weekday == 7)) {
        closes = 3;
    }
    
    // Fri-Sat after midnight
    else if (time <= 5 && (weekday == 7 || weekday == 1)) {
        closes = 3;
    }
    
    // Sun-Wed before midnight
    else if (time <= 24 && (weekday >= 1 && weekday <= 4)) {
        closes = 2;
    }
    else if (time <= 5 && (weekday >= 2 && weekday <= 5)) {
        closes = 2;
    }
    
    if (time >= 11.30 || time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *hongKong = [[EateryDoc alloc]
                           initWithTitle:@"Hong Kong Restaurant"
                           foodtype:@"dinner, chinese, asian"
                           rating:4
                           description:@"'The Kong' is every Harvard students' late-night best friend. It serves classic American Chinese food. For those 21+, don't forget to try the infamous Scorpion Bowl (watch out for the scary bouncer)."
                           opensAt:11.30
                           closesAt:closes
                           isItOpen:isit
                           address:@"1238 Mass Avenue, Cambridge, MA 02138"
                           number:@"tel:617864311"
                           website:@"http://www.hongkongharvard.com/"
                           thumbImage:[UIImage imageNamed:@"hongKongThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"hongKong.jpg"]
                           latitude:42.370562
                           longitude:-71.114159
                           distance:111111];
    
#pragma mark - J.P. Licks
    
    if (weekday != 7 && weekday != 1) {
        opens = 7;
    }
    else {
        opens = 8;
    }
    
    if (time >= opens && time <= 24) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *jpLicks = [[EateryDoc alloc]
                          initWithTitle:@"J.P. Licks"
                          foodtype:@"jp, ice cream, shakes, dessert"
                          rating:5
                          description:@"J.P. Licks is the go to ice-cream shop in Harvard Square. With creative flavors and delicious toppings, there really isn't another choice!"
                          opensAt:opens
                          closesAt:24
                          isItOpen:isit
                          address:@"1312 Massachusetts Ave, Cambridge, MA 02138"
                          number:@"tel:6174921001"
                          website:@"http://www.jplicks.com/"
                          thumbImage:[UIImage imageNamed:@"jpLicksThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"jpLicks.jpg"]
                          latitude:42.3731182
                          longitude:-71.1179677
                          distance:111111];
    
#pragma mark - John Harvard's Brew House
    
    if (time >= 11.3 || time <= 1) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *johnHarvards = [[EateryDoc alloc]
                               initWithTitle:@"John Harvard's Brew House"
                               foodtype:@"bar, pub, dinner, beer"
                               rating:4
                               description:@"A staple of the Harvard landscape, John Harvard's provides excellent pub food with fresh, homemade beer!"
                               opensAt:11.30
                               closesAt:1
                               isItOpen:isit
                               address:@"33 Dunster Street, Cambridge, MA 02138"
                               number:@"tel:6178683585"
                               website:@"https://www.johnharvards.com/"
                               thumbImage:[UIImage imageNamed:@"johnHarvardsThumb.jpg"]
                               fullImage:[UIImage imageNamed:@"johnHarvards.jpg"]
                               latitude:42.3725237
                               longitude:-71.1192685
                               distance:111111];
    
#pragma mark - Lamole Restaurant
    
    if (time >= 11 || time <= 1) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *lamole = [[EateryDoc alloc]
                         initWithTitle:@"Lamole Restaurant"
                         foodtype:@"pizza, dinner, salads, subs, sandwiches, wings, "
                         rating:3
                         description:@"Lamole offers great pizza, subs, salads, wings and more, all made fresh every day!"
                         opensAt:11
                         closesAt:1
                         isItOpen:isit
                         address:@"1105 Massachusetts Avenue, Cambridge, MA 02138"
                         number:@"tel:6179450441"
                         website:@"http://lamolepizza.com/"
                         thumbImage:[UIImage imageNamed:@"lamoleThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"lamole.jpg"]
                         latitude:42.370649
                         longitude:-71.1136497
                         distance:111111];
    
#pragma mark - Legal Sea Foods
    
    // Sun-Thurs
    if (weekday != 6 && weekday != 7) {
        closes = 22;
    }
    else {
        closes = 23;
    }
    
    if (time >= 11 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *legal = [[EateryDoc alloc]
                        initWithTitle:@"Legal Sea Foods"
                        foodtype:@"dinner"
                        rating:3
                        description:@"Legal Sea Foods provides high quality sea fare as well as excellent steaks. Right by The Charles Hotel!"
                        opensAt:11
                        closesAt:closes
                        isItOpen:isit
                        address:@"20 University Road, Cambridge, MA 02138"
                        number:@"tel:6174919400"
                        website:@"http://www.legalseafoods.com/"
                        thumbImage:[UIImage imageNamed:@"legalThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"legal.jpg"]
                        latitude:42.3732935
                        longitude:-71.122976
                        distance:111111];
    
#pragma mark - Lizzy's Ice Cream
    
    if (weekday != 6 && weekday != 7) {
        closes = 22.30;
    }
    else {
        closes = 22;
    }
    
    if (time >= 12 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *lizzys = [[EateryDoc alloc]
                         initWithTitle:@"Lizzy's Ice Cream"
                         foodtype:@"dessert, ice cream"
                         rating:3
                         description:@"Founded by an ex-corporate type, Lizzy's Ice Cream is truly a childhood dream come true. Stop by for a high quality licking experience!"
                         opensAt:12
                         closesAt:closes
                         isItOpen:isit
                         address:@"31A Church Street, Cambridge, MA 02138"
                         number:@"tel:6173542911"
                         website:@"http://www.lizzysicecream.com/"
                         thumbImage:[UIImage imageNamed:@"lizzysThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"lizzys.jpg"]
                         latitude:42.3745203
                         longitude:-71.12019
                         distance:111111];
    
#pragma mark - Midwest Grill
    
    if (time >= 11 && time <= 23) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *midwest = [[EateryDoc alloc]
                          initWithTitle:@"Midwest Grill"
                          foodtype:@"grill, brazillian, bbq, barbecue, dinner"
                          rating:3
                          description:@"Come to Midwest Grill for a mouthwatering Brazillian BBQ experience! Any meat-lover can feel at home here, but vegetarian and seafood dishes are served too."
                          opensAt:11
                          closesAt:23
                          isItOpen:isit
                          address:@"1124 Cambridge Street, Cambridge, MA 02139"
                          number:@"tel:6173547536"
                          website:@"http://www.midwestgrillrestaurant.com/"
                          thumbImage:[UIImage imageNamed:@"midwestThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"midwest.jpg"]
                          latitude:42.372855
                          longitude:-71.09603
                          distance:111111];
    
#pragma mark - Noir
    
    if (time >= 16 || time <= 2) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *noir = [[EateryDoc alloc]
                       initWithTitle:@"Noir"
                       foodtype:@"bar"
                       rating:4
                       description:@"Noir is a classy spot to grab drinks. Enjoy the signature cocktails and the chic feel!"
                       opensAt:16
                       closesAt:2
                       isItOpen:isit
                       address:@"1 Bennett Street, Cambridge, MA 02138"
                       number:@"6176618010"
                       website:@"http://www.noir-bar.com/"
                       thumbImage:[UIImage imageNamed:@"noirThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"noir.jpg"]
                       latitude:42.372258
                       longitude:-71.122667
                       distance:111111];
    
#pragma mark - Nubar
    
    // monday-thurs before midnight
    if (time <= 24 && (weekday >= 2 && weekday <= 5)) {
        opens = 6.30;
        closes = 24;
    }
    // monday - thurs after midnight
    else if (time <= 5 && (weekday >= 3 && weekday <= 6)) {
        opens = 6.30;
        closes = 1;
    }
    // friday before midnight
    else if ((time <= 24 && time > 5) && weekday == 6) {
        opens = 6.30;
        closes = 1;
    }
    // friday after midnight
    else if (time <= 5 && weekday == 7) {
        opens = 6.30;
        closes = 1;
    }
    // saturday before midnight
    else if ((time <= 24 && time > 5) && weekday == 7) {
        opens = 7;
        closes = 1;
    }
    // saturday after midnight
    else if (time <= 5 && weekday == 1) {
        opens = 7;
        closes = 1;
    }
    // sunday
    else {
        opens = 11;
        closes = 24;
    }
    
    if (closes <= 3) {
        if (time >= opens || time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= opens && time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    
    
    EateryDoc *nubar = [[EateryDoc alloc]
                        initWithTitle:@"Nubar"
                        foodtype:@"bar, dinner, beer, wine"
                        rating:4
                        description:@"Nubar is hip restaurant and lounge located right in front of the famous Sheraton Commander Hotel. Stop by for cocktails and excellent modern cuisine!"
                        opensAt:opens
                        closesAt:closes
                        isItOpen:isit
                        address:@"16 Garden Street, Cambridge, MA 02138"
                        number:@"tel:6172341365"
                        website:@"http://nubarcambridge.com/"
                        thumbImage:[UIImage imageNamed:@"nubarThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"nubar.jpg"]
                        latitude:42.3773012
                        longitude:-71.1231757
                        distance:111111];
    
    
#pragma mark - Oggi Gourmet
    
    // Mon-Fri
    if (weekday != 7 && weekday != 1){
        opens = 7.45;
        closes = 20;
    }
    // Sat-Sun
    else {
        opens = 12;
        closes = 19;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *oggi = [[EateryDoc alloc]
                       initWithTitle:@"Oggi Gourmet"
                       foodtype:@"sandwiches, dinner, pizza, salad"
                       rating:4
                       description:@"Located in the Holyoke Center, Oggi Gourmet makes mouthwatering pizza, sandwiches and salads. With everything handmade from the highest quality ingredients, you won't be disappointed."
                       opensAt:opens
                       closesAt:closes
                       isItOpen:isit
                       address:@"1350 Massachusetts Avenue, Cambridge, MA 02138"
                       number:@"tel:6174926444"
                       website:@"http://www.oggigourmet.com/"
                       thumbImage:[UIImage imageNamed:@"oggiThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"oggi.jpg"]
                       latitude:42.3730926
                       longitude:-71.1182891
                       distance:111111];
    
#pragma mark - Orinoco: A Latin Kitchen
    
    // monday
    if (weekday == 2) {
        opens = 26;
        closes = 25;
    }
    // lunch tues-wed
    else if (time < 17.30 && (weekday == 3 || weekday == 4)){
        opens = 12;
        closes = 14.30;
    }
    // dinner tues-wed
    else if (time >= 17.3 && (weekday == 3 || weekday == 4)) {
        opens = 17.30;
        closes = 22;
    }
    // lunch thursday-sat
    else if (time < 17.3 && (weekday >= 5 && weekday <= 7)) {
        opens = 12;
        closes = 14.30;
    }
    // dinner thurs-sat
    else if (time >= 17.3 && (weekday >= 5 && weekday <= 7)) {
        opens = 17.30;
        closes = 23;
    }
    // sunday brunch
    else if (time < 17.3 && weekday == 1) {
        opens = 11;
        closes = 15;
    }
    // sunday dinner
    else if (time > 17.3 && weekday == 1) {
        opens = 17.3;
        closes = 19;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *orinoco = [[EateryDoc alloc]
                          initWithTitle:@"Orinoco: A Latin Kitchen"
                          foodtype:@"mexican, beer, wine, dinner, sandwiches, salads"
                          rating:4
                          description:@"Stop by Orinoco for delicious Latin American food. With everything empanadas to ensaladas, there is a fantastic meal waiting for everyone."
                          opensAt:opens
                          closesAt:closes
                          isItOpen:isit
                          address:@"56 JFK Street, Cambridge, MA 02138"
                          number:@"tel:6173546900"
                          website:@"http://www.orinocokitchen.com/"
                          thumbImage:[UIImage imageNamed:@"orinocoThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"orinoco.jpg"]
                          latitude:42.3718668
                          longitude:-71.1205965
                          distance:111111];
    
#pragma mark - Panera
    
    // Monday-Sat
    if (weekday != 1) {
        opens = 5.30;
        closes = 23.30;
    }
    // Sun
    else {
        opens = 6;
        closes = 23;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *panera = [[EateryDoc alloc]
                         initWithTitle:@"Panera"
                         foodtype:@"dinner, sandwiches, salads, coffee, tea, cheap"
                         rating:2
                         description:@"Panera Bread makes the bread fresh from the oven every day to prepare sandwiches and other oven-baked goods. Come by for a meal or a quick snack!"
                         opensAt:opens
                         closesAt:closes
                         isItOpen:isit
                         address:@"1288 Massachusetts Avenue, Cambridge, MA 02138"
                         number:@"tel:6178680651"
                         website:@"http://www.panerabread.com/"
                         thumbImage:[UIImage imageNamed:@"paneraThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"panera.jpg"]
                         latitude:42.3727504
                         longitude:-71.116986
                         distance:111111];
    
#pragma mark - Park Restaurant & Bar
    
    // Sun-thurs before midnight
    if ((time <= 24 && time >= 5) && (weekday != 6 && weekday != 7)) {
        closes = 24;
    }
    // Sun-Thursday after midnight
    else if (time < 5 && (weekday != 7 && weekday != 1)) {
        closes = 24;
    }
    // Fri-Sat beforeco midnight
    else if ((time <= 24 && time >= 5) && (weekday == 6 || weekday == 7)) {
        closes = 1;
    }
    // Fri-Sat after midnight
    else if (time < 5 && (weekday == 6 || weekday == 7)) {
        closes = 1;
    }
    
    if (closes == 1) {
        if (time >= opens || time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= opens && time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    
    EateryDoc *park = [[EateryDoc alloc]
                       initWithTitle:@"Park Restaurant & Bar"
                       foodtype:@"bar, dinner, beer, wine"
                       rating:5
                       description:@"Come to park for cocktails, a snack or a leisurely meal. The food is modern and delicious and the list of cocktails, beers and wines is extensive!"
                       opensAt:17
                       closesAt:closes
                       isItOpen:isit
                       address:@"59 JFK Street, Cambridge, MA 02138"
                       number:@"tel:6174919851"
                       website:@"http://www.parkcambridge.com/"
                       thumbImage:[UIImage imageNamed:@"parkThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"park.jpg"]
                       latitude:42.3715778
                       longitude:-71.1209947
                       distance:111111];
    
#pragma mark - Peet's Coffee and Tea
    
    if (weekday == 1) {
        opens = 6;
        closes = 21;
    }
    else if (weekday >= 2 && weekday <= 5) {
        opens = 6;
        closes = 21.30;
    }
    else {
        opens = 6;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *peets = [[EateryDoc alloc]
                        initWithTitle:@"Peet's Coffee and Tea"
                        foodtype:@"coffee, tea, cheap, peets"
                        rating:5
                        description:@"Peet's is a nice choice for those looking for a small coffee shop with great, strong coffee."
                        opensAt:opens
                        closesAt:closes
                        isItOpen:isit
                        address:@"100 Mount Auburn Street, Cambridge, MA 02138"
                        number:@"tel:6174921844"
                        website:@"http://www.peets.com/fvpage.asp?rdir=1&"
                        thumbImage:[UIImage imageNamed:@"peetsThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"peets.jpg"]
                        latitude:42.3727334
                        longitude:-71.120611
                        distance:111111];
    
#pragma mark - Pinkberry
    
    if (weekday != 6 && weekday != 7) {
        closes = 23;
    }
    else {
        closes = 24;
    }
    
    if (time >= 9 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *pinkberry = [[EateryDoc alloc]
                            initWithTitle:@"Pinkberry"
                            foodtype:@"froyo, dessert, ice cream"
                            rating:5
                            description:@"Pinkberry serves high quality frozen yogurt with over 30 fresh and delicious toppings. Stop in for a mouthwatering frozen treat."
                            opensAt:9
                            closesAt:closes
                            isItOpen:isit
                            address:@"1380 Massachusetts Avenue, Cambridge, MA 02138"
                            number:@"tel:6175470573"
                            website:@"http://www.pinkberry.com/"
                            thumbImage:[UIImage imageNamed:@"pinkberryThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"pinkberry.jpg"]
                            latitude:42.3733731
                            longitude:-71.1191679
                            distance:111111];
    
#pragma mark - Qdoba Mexican Grill
    
    if (time >= 11 && time <= 21.30) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *qdoba = [[EateryDoc alloc]
                        initWithTitle:@"Qdoba Mexican Grill"
                        foodtype:@"burritos, cheap, dinner"
                        rating:3
                        description:@"Qdoba is the place to go for delicious burritos at a great price. Ample seating offers a study space for the urban student!"
                        opensAt:11
                        closesAt:21.30
                        isItOpen:isit
                        address:@"1290 Massachusetts Avenue, Cambridge, MA 02138"
                        number:@"tel:6178711136"
                        website:@"http://www.qdoba.com/"
                        thumbImage:[UIImage imageNamed:@"qdobaThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"qdoba.jpg"]
                        latitude:42.3727837
                        longitude:-71.1170776
                        distance:111111];
    
#pragma mark - Rialto
    
    if (weekday != 1) {
        closes = 23;
    }
    else {
        closes = 22;
    }
    
    if (time >= 17 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *rialto = [[EateryDoc alloc]
                         initWithTitle:@"Rialto"
                         foodtype:@"dinner, italian, dessert, bar"
                         rating:5
                         description:@"Rialto is a high quality modern Italian restaurant. Just go to the second floor of the Charles Hotel for a delicious meal, quick snack or drink at the bar!"
                         opensAt:17
                         closesAt:closes
                         isItOpen:isit
                         address:@"1 Bennett Street, Cambridge, MA 02138"
                         number:@"tel:6176615050"
                         website:@"http://www.rialto-restaurant.com/"
                         thumbImage:[UIImage imageNamed:@"rialtoThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"rialto.jpg"]
                         latitude:42.372258
                         longitude:-71.122667
                         distance:111111];
    
#pragma mark - Russell House Tavern
    
    // Sun-Wed before midnight
    if (time <= 24 && (weekday >= 1 && weekday <= 4)) {
        closes = 1;
    }
    // Sun-Wed before midnight
    else if (time < 5 && (weekday >= 2 && weekday <= 5)) {
        closes = 1;
    }
    // Thurs-Sat before midnight
    else if ((time <= 24 && time >= 5) && (weekday >= 5 && weekday <= 7)) {
        closes = 2;
    }
    // Thurs-Sat after midnight
    else if (time < 5 && (weekday == 6 || weekday == 7 || weekday == 1)) {
        closes = 2;
    }
    
    if (time >= 11 || time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *russellHouse = [[EateryDoc alloc]
                               initWithTitle:@"Russell House Tavern"
                               foodtype:@"dinner, bar"
                               rating:5
                               description:@"Russell House is a high-class restaurant located right outside of Harvard Yard. The food is fantastic, as is the bar. A Harvard Square must-see!"
                               opensAt:11
                               closesAt:closes
                               isItOpen:isit
                               address:@"14 JFK Street, Cambridge, MA 02138"
                               number:@"tel:6175003055"
                               website:@"http://www.russellhousecambridge.com/"
                               thumbImage:[UIImage imageNamed:@"russellHouseThumb.jpg"]
                               fullImage:[UIImage imageNamed:@"russellHouse.jpg"]
                               latitude:42.3731241
                               longitude:-71.119659
                               distance:111111];
    
#pragma mark - Sabra Grill
    
    if (time >= 10 && time <= 22) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *sabra = [[EateryDoc alloc]
                        initWithTitle:@"Sabra Grill"
                        foodtype:@"dinner, mediterranean, cheap"
                        rating:4
                        description:@"Come to Sabra for gourmet Middle-Eastern cuisine. The food is fresh, flavorful and different!"
                        opensAt:10
                        closesAt:22
                        isItOpen:isit
                        address:@"20 Eliot Street, Cambridge, MA 02138"
                        number:@"tel:6178685777"
                        website:@"http://www.sabrafoods.com/Sabra_Grill.htm"
                        thumbImage:[UIImage imageNamed:@"sabraThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"sabra.jpg"]
                        latitude:42.3722762
                        longitude:-71.1217977
                        distance:111111];
    
#pragma mark - Sandrine's Bistro
    
    // Sunday
    if (weekday == 1) {
        opens = 17.30;
        closes = 22;
    }
    // Lunch Mon-Sat
    else if (time < 17.3 && (weekday >= 2 && weekday <= 7)){
        opens = 11.3;
        closes = 14.3;
    }
    // Dinner Mon-Sat
    else if (time >= 17.3 && (weekday >= 2 && weekday <= 7)){
        opens = 17.3;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *sandrines = [[EateryDoc alloc]
                            initWithTitle:@"Sandrine's Bistro"
                            foodtype:@"dinner, french, wine, dessert, beer, bar"
                            rating:4
                            description:@"This French restaurant is home to Master Chef Raymond Ost. Stop in for a meal of exquisite French cuisine or a cocktail at the bar!"
                            opensAt:opens
                            closesAt:closes
                            isItOpen:isit
                            address:@"8 Holyoke Street, Cambridge, MA 02138"
                            number:@"tel:6174975300"
                            website:@"http://www.sandrines.com/"
                            thumbImage:[UIImage imageNamed:@"sandrinesThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"sandrines.jpg"]
                            latitude:42.372694
                            longitude:-71.117968
                            distance:111111];
    
#pragma mark - Shabu Ya
    
    // Sun-Wed before midnight
    if ((time >= 5 && time <= 24) && (weekday >= 1 && weekday <= 4)) {
        closes = 22.30;
    }
    // Sun-Wed after midnight
    else if ((time < 5) && (weekday >= 2 && weekday <= 5)) {
        closes = 22.30;
    }
    // Thurs-Sat before midnight
    else if ((time >= 5 && time <= 24) && (weekday >= 5 && weekday <= 7)) {
        closes = 24.30;
    }
    // Thurs-Sat after midnight
    else if ((time < 5) && (weekday == 6 || weekday == 7 || weekday == 1)) {
        closes = 24.30;
    }
    
    if (time >= 11.3 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *shabuya = [[EateryDoc alloc]
                          initWithTitle:@"Shabu Ya"
                          foodtype:@"dinner, asian, chinese, bbq, barbecue"
                          rating:3
                          description:@"Shabu Ya is a specialty restaurant serving up shabu-shabu, a traditional Asian dish known as 'hot-pot.' Stop in for a delicious and different dining experience!"
                          opensAt:11.3
                          closesAt:closes
                          isItOpen:isit
                          address:@"57 JFK Street, Cambridge, MA 02138"
                          number:@"tel:6178646868"
                          website:@"http://www.shabuyarestaurant.com"
                          thumbImage:[UIImage imageNamed:@"shabuyaThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"shabuya.jpg"]
                          latitude:42.3721459
                          longitude:-71.1209169
                          distance:111111];
    
#pragma mark - Shays Pub & Wine Bar
    
    if (weekday == 1) {
        opens = 12;
    }
    else {
        opens = 11;
    }
    
    if (time >= opens || time <= 1) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *shays = [[EateryDoc alloc]
                        initWithTitle:@"Shays Pub & Wine Bar"
                        foodtype:@"dinner, grill, beer, mexican, sandwiches, burgers, fries"
                        rating:4
                        description:@"Drop into Shays for a delicious burger, handcut fries or one of their excellent Mexican dishes. You will want to order every single item on the menu!"
                        opensAt:opens
                        closesAt:1
                        isItOpen:isit
                        address:@"58 JFK Street, Cambridge, MA 02138"
                        number:@"tel:6178649161"
                        website:@"http://www.shayspubandwinebar.com/"
                        thumbImage:[UIImage imageNamed:@"shaysThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"shays.jpg"]
                        latitude:42.3717688
                        longitude:-71.1207992
                        distance:111111];
    
#pragma mark - Spice Thai Cuisine
    
    if (weekday >= 2 && weekday <= 5) {
        opens = 11.3;
        closes = 22;
    }
    else if (weekday == 6) {
        opens = 11.3;
        closes = 22.3;
    }
    else if (weekday == 7){
        opens = 12;
        closes = 22.3;
    }
    else if (weekday == 1) {
        opens = 12;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    
    EateryDoc *spice = [[EateryDoc alloc]
                        initWithTitle:@"Spice Thai Cuisine"
                        foodtype:@"dinner, curry, thai"
                        rating:3
                        description:@"Looking for something with a kick? Stop by Spice for a great Thai meal!"
                        opensAt:opens
                        closesAt:closes
                        isItOpen:isit
                        address:@"24 Holyoke Street, Cambridge, MA 02138"
                        number:@"tel:6178689560"
                        website:@"http://www.spicethaicuisine.com/"
                        thumbImage:[UIImage imageNamed:@"spiceThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"spice.jpg"]
                        latitude:42.3721411
                        longitude:-71.1184277
                        distance:111111];
    
#pragma mark - Starbuck's (Church St)
    
    if (weekday != 7 && weekday != 1) {
        opens = 6;
    }
    else {
        opens = 6.3;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *starbucksChurch = [[EateryDoc alloc]
                                  initWithTitle:@"Starbucks (Church St)"
                                  foodtype:@"Coffee, sandwiches"
                                  rating:3
                                  description:@"Frapps, lattes, sandwiches, cookies, WiFi and plain old coffee too. It'll cost you, but it's worth it! More quaint than the other two locations. Check it out!"
                                  opensAt:opens
                                  closesAt:22.3
                                  isItOpen:isit
                                  address:@"31 Church Street, MA 02138"
                                  number:@"tel:6174927870"
                                  website:@"http://www.starbucks.com/"
                                  thumbImage:[UIImage imageNamed:@"StarbucksThumb.jpg"]
                                  fullImage:[UIImage imageNamed:@"Starbucks.jpg"]
                                  latitude:42.3745203
                                  longitude:-71.12019
                                  distance:111111];
    
#pragma mark - Starbucks (Garage)
    
    // Mon-Fri
    if (weekday != 7 && weekday != 1) {
        opens = 6.3;
    }
    // Sat-Sun
    else {
        opens = 7.3;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *starbucksGarage = [[EateryDoc alloc]
                                  initWithTitle:@"Starbucks (Garage)"
                                  foodtype:@"Coffee, sandwiches"
                                  rating:3
                                  description:@"Frapps, lattes, sandwiches, cookies, WiFi and plain old coffee too. It'll cost you, but it's worth it! Located in the Garage!"
                                  opensAt:opens
                                  closesAt:22.3
                                  isItOpen:isit
                                  address:@"36 JFK Street, Cambridge, MA  02138"
                                  number:@"tel:6174924881"
                                  website:@"http://www.starbucks.com/"
                                  thumbImage:[UIImage imageNamed:@"StarbucksThumb.jpg"]
                                  fullImage:[UIImage imageNamed:@"Starbucks.jpg"]
                                  latitude:42.3726417
                                  longitude:-71.1198562
                                  distance:111111];
    
#pragma mark - Starbucks (Square)
    
    if (time >= 5 || time <= 1) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    EateryDoc *starbucksSquare = [[EateryDoc alloc]
                                  initWithTitle:@"Starbucks (Square)"
                                  foodtype:@"Coffee, sandwiches"
                                  rating:4
                                  description:@"Frapps, lattes, sandwiches, cookies, WiFi and plain old coffee too. It'll cost you, but it's worth it!"
                                  opensAt:5
                                  closesAt:1
                                  isItOpen:isit
                                  address:@"1380 Massachusetts Ave, Cambridge, MA  02138"
                                  number:@"tel6173543726"
                                  website:@"http://www.starbucks.com"
                                  thumbImage:[UIImage imageNamed:@"StarbucksThumb.jpg"]
                                  fullImage:[UIImage imageNamed:@"Starbucks.jpg"]
                                  latitude:42.3733731
                                  longitude:-71.1191679
                                  distance:111111];
    
#pragma mark - Subway
    
    if (time >= 8 && time <= 22) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *subway = [[EateryDoc alloc]
                         initWithTitle:@"Subway"
                         foodtype:@"sandwiches, cookies, dinner, cheap"
                         rating:3
                         description:@"Eat something fresh and fit today! Come to Subway for the sandwiches you know and love. Grab the $5 footlongs!"
                         opensAt:8
                         closesAt:22
                         isItOpen:isit
                         address:@"36 JFK Street, Cambridge, MA  02138"
                         number:@"tel:6174410011"
                         website:@"http://www.subway.com/subwayroot/default.aspx"
                         thumbImage:[UIImage imageNamed:@"subwayThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"subway.jpg"]
                         latitude:42.3726417
                         longitude:-71.1198562
                         distance:111111];
    
#pragma mark - Sweet
    
    // Sun-Tues
    if (weekday >= 1 && weekday <= 3) {
        closes = 21;
    }
    // Wed-Sat
    else {
        closes = 22;
    }
    
    if (time >= 11 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *sweet = [[EateryDoc alloc]
                        initWithTitle:@"Sweet"
                        foodtype:@"dessert, chocolate, coffee, tea"
                        rating:3
                        description:@"Visit Sweet for gourmet cupcakes or a cup of coffee or tea! All of their products are made with the highest quality ingredients!"
                        opensAt:11
                        closesAt:closes
                        isItOpen:isit
                        address:@"0 Brattle Street, Cambridge MA 02138"
                        number:@"tel:6175472253"
                        website:@"http://www.sweetcupcakes.com/"
                        thumbImage:[UIImage imageNamed:@"sweetThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"sweet.jpg"]
                        latitude:42.3732905
                        longitude:-71.1200106
                        distance:111111];
    
    
#pragma mark - Takemura Japanese Restaurant
    
    // Lunch Monday-Saturdsay
    if (time < 17.3 && (weekday != 1)) {
        opens = 11.3;
        closes = 14.30;
    }
    // Dinner Monday-Sat
    else if ((time >= 17.30 && time <= 24) && (weekday != 1)) {
        opens = 17.3;
        closes = 23;
    }
    // Sunday
    else {
        opens = 12.3;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *takemura = [[EateryDoc alloc]
                           initWithTitle:@"Takemura Japanese Restaurant"
                           foodtype:@"asian, chinese, dinner, sushi, bbq, barbecue"
                           rating:3
                           description:@"Takemura is an excellent Japanese Restaurant located in the basement at 18 Eliot Street. Come by for sushi, teriyaki, Korean barbecue and more!"
                           opensAt:opens
                           closesAt:closes
                           isItOpen:isit
                           address:@"18 Eliot Street, Cambridge, MA 02138"
                           number:@"tel:(617)-492-6700"
                           website:@"http://www.yelp.com/biz/takemura-japanese-restaurant-cambridge"
                           thumbImage:[UIImage imageNamed:@"takemuraThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"takemura.jpg"]
                           latitude:42.372091
                           longitude:-71.121394
                           distance:111111];
    
#pragma mark - Tamarind Bay
    
    // Lunch Mon-Fri
    if (time < 17 && (weekday != 7 && weekday != 1)) {
        closes = 14.3;
    }
    // Dinner Mon-Fri
    else if (time >= 17 && (weekday != 7 && weekday != 1)) {
        closes = 22;
    }
    // Lunch Sat-Sun
    else if (time < 17 && (weekday == 7 || weekday == 1)) {
        closes = 15;
    }
    // Dinner Sat-Sun
    else {
        closes = 22;
    }
    
    if (time >= 12 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *tamarind = [[EateryDoc alloc]
                           initWithTitle:@"Tamarind Bay"
                           foodtype:@"dinner, indian, curry"
                           rating:3
                           description:@"Come to Tamarind Bay for high quality Indian food in a modern and comfortable setting!"
                           opensAt:12
                           closesAt:closes
                           isItOpen:isit
                           address:@"75 Winthrop Street, Cambridge, MA 02138"
                           number:@"tel:617-491-4552"
                           website:@"http://www.tamarind-bay.com/"
                           thumbImage:[UIImage imageNamed:@"tamarindThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"tamarind.jpg"]
                           latitude:42.3723438
                           longitude:-71.1201938
                           distance:111111];
    
#pragma mark - Tanjore
    
    // Lunch Mon-Fri
    if (time < 17 && (weekday >= 2 && weekday <= 6)) {
        opens = 11.3;
        closes = 15;
    }
    // Dinner Mon-Sat
    else if (time >= 17 && (weekday >= 2 && weekday <= 6)) {
        opens = 17;
        closes = 23;
    }
    // Lunch Sun-Sat
    else if (time < 17 && (weekday == 7 || weekday == 1)) {
        opens = 12;
        closes = 16;
    }
    // Dinner Sunday
    else {
        opens = 17;
        closes = 22.3;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *tanjore = [[EateryDoc alloc]
                          initWithTitle:@"Tanjore"
                          foodtype:@"dinner, indian, curry"
                          rating:3
                          description:@"Come to Tamarind Bay for high quality Indian food in a modern and comfortable setting!"
                          opensAt:opens
                          closesAt:closes
                          isItOpen:isit
                          address:@"18 Eliot Street, Cambridge, MA 02138"
                          number:@"tel:(617) 868-1900"
                          website:@"http://www.tanjoreharvardsq.com/"
                          thumbImage:[UIImage imageNamed:@"tanjoreThumb.jpg"]
                          fullImage:[UIImage imageNamed:@"tanjore.jpg"]
                          latitude:42.372091
                          longitude:-71.121394
                          distance:111111];
    
#pragma mark - Temple Bar
    
    // Mon-Fri
    if (weekday != 7 && weekday != 1) {
        opens = 17;
    }
    else {
        opens = 10;
    }
    
    if (time >= opens || time <= 1) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *temple = [[EateryDoc alloc]
                         initWithTitle:@"Temple Bar"
                         foodtype:@"bar, dinner, beer, wine, cocktails, grill"
                         rating:3
                         description:@"Temple Bar is a great place to go to unwind, enjoy a specialty cocktail and savor the flavor of Chef Greg Boschetti's exquisite menu."
                         opensAt:opens
                         closesAt:1
                         isItOpen:isit
                         address:@"1688 Massachusetts Avenue, Cambridge, MA 02138"
                         number:@"tel:617.547.5055"
                         website:@"http://www.templebarcambridge.com/"
                         thumbImage:[UIImage imageNamed:@"templeThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"temple.jpg"]
                         latitude:42.382751
                         longitude:-71.1198133
                         distance:111111];
    
#pragma mark - Ten Tables Cambridge
    
    if (weekday >= 2 && weekday <= 5) {
        opens = 17.3;
        closes = 22;
    }
    else if (weekday == 6 || weekday == 7) {
        opens = 17.3;
        closes = 22.3;
    }
    else {
        opens = 17;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *tenTables = [[EateryDoc alloc]
                            initWithTitle:@"Ten Tables Cambridge"
                            foodtype:@"bar, dinner, beer, wine, cocktails, grill"
                            rating:4
                            description:@"Ten Tables is a special restaurant the truly pays attention to the details. Ingredients are carefully selected and cocktails carefully mixed. Come by for a quality dining experience."
                            opensAt:opens
                            closesAt:closes
                            isItOpen:isit
                            address:@"5 Craigie Street Circle, Cambridge, MA 02139"
                            number:@"tel:617-388-8324"
                            website:@"http://www.tentables.net/"
                            thumbImage:[UIImage imageNamed:@"tenTablesThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"tenTables.jpg"]
                            latitude:42.3736158
                            longitude:-71.1097335
                            distance:111111];
    
#pragma mark - The Maharaja
    
    if (weekday >= 2 && weekday <= 5) {
        opens = 11.3;
        closes = 22;
    }
    else if (weekday == 6) {
        opens = 11.3;
        closes = 23;
    }
    else if (weekday == 7) {
        opens = 12;
        closes = 23;
    }
    else {
        opens = 12;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *maharaja = [[EateryDoc alloc]
                           initWithTitle:@"The Maharaja"
                           foodtype:@"indian, dinner, curry"
                           rating:3
                           description:@"Located in the heart of Harvard Square, The Maharaja serves up traditional Indian dishes in a beautiful, cultured setting."
                           opensAt:opens
                           closesAt:closes
                           isItOpen:isit
                           address:@"57 JFK Street, Cambridge, MA 02138"
                           number:@"tel:617-547-2757"
                           website:@"http://www.maharajaboston.com/"
                           thumbImage:[UIImage imageNamed:@"maharajaThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"maharaja.jpg"]
                           latitude:42.3721459
                           longitude:-71.1209169
                           distance:111111];
    
#pragma mark - the red house
    
    // before midight Tuesday-Thurs, Sun
    if (time < 24 && weekday != 2 && weekday != 6 && weekday != 7) {
        opens = 12;
        closes = 24;
    }
    // after midight Tues-Thurs, Sun
    else if (time < 5 && weekday != 3 && weekday != 7 && weekday != 1) {
        opens = 12;
        closes = 24;
    }
    // before midnight Fri-Sat
    else if (time < 24 && (weekday == 6 || weekday == 7)) {
        opens = 12;
        closes = 1;
    }
    
    if (closes == 1) {
        if (time >= opens || time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= opens && time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    
    EateryDoc *redHouse = [[EateryDoc alloc]
                           initWithTitle:@"the red house"
                           foodtype:@"dinner, grill, beer, wine, bar"
                           rating:4
                           description:@"the red house is a great restaurant with an old soul. All of the food comes from a local farm and it pays off. Enjoy sitting in the recently renovated main dining room or on the lovely patio!"
                           opensAt:opens
                           closesAt:closes
                           isItOpen:isit
                           address:@"98 Winthrop Street, Cambridge, MA 02138"
                           number:@"tel:617-576-0605"
                           website:@"http://www.theredhouse.com/"
                           thumbImage:[UIImage imageNamed:@"redHouseThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"redHouse.jpg"]
                           latitude:42.372386
                           longitude:-71.1211576
                           distance:111111];
    
#pragma mark - The Regattabar
    
    if (weekday == 3 || weekday == 4 || weekday == 5) {
        opens = 19.3;
        closes = 22;
    }
    // Friday-Sat first seating
    else if (time < 22 && (weekday == 6 || weekday == 7)) {
        opens = 20.3;
        closes = 22;
    }
    // Fri-Say second seating
    else if (time <= 24 && (weekday == 6 || weekday == 7)) {
        opens = 22;
        closes = 24;
    }
    // closed on Sunday and Monday
    if (weekday == 1 || weekday == 2) {
        isit = NO;
        closes = 25;
    }
    else if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *regattabar = [[EateryDoc alloc]
                             initWithTitle:@"The Regattabar"
                             foodtype:@"beer, wine, bar, jazz"
                             rating:4
                             description:@"Located in the Charles Hotel, the Regattabar is more than just a bar. It is one of New England's premier jazz clubs. There's music on Tuesday-Saturday nights! Stop by for delicious bar food, cocktails and a foot-tappin' time! Call or go online for tickets!"
                             opensAt:opens
                             closesAt:closes
                             isItOpen:isit
                             address:@"1 Bennett Street, Cambridge, MA 02138"
                             number:@"tel:617.395.7757 "
                             website:@"http://www.regattabarjazz.com/"
                             thumbImage:[UIImage imageNamed:@"regattabarThumb.jpg"]
                             fullImage:[UIImage imageNamed:@"regattabar.jpg"]
                             latitude:42.372258
                             longitude:-71.122667
                             distance:111111];
    
#pragma mark - Insomnia Cookies
    
    if (time >= 11 || time <= 3) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *insomnia = [[EateryDoc alloc]
                           initWithTitle:@"Insomnia Cookies"
                           foodtype:@"dessert"
                           rating:4
                           description:@"Insomnia Cookies keeps the lights on until 3 am every night! AND they deliver! The cookies are fresh and delicious, but beware: some say they're addictive."
                           opensAt:11
                           closesAt:3
                           isItOpen:isit
                           address:@"65 Mount Auburn Street, Cambridge, Massachusetts 02138"
                           number:@"tel:8776326654"
                           website:@"https://insomniacookies.com/"
                           thumbImage:[UIImage imageNamed:@"insomniaThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"insomnia.jpg"]
                           latitude:42.3719479
                           longitude:-71.1181612
                           distance:111111];
    
#pragma mark - Tory Row
    
    if (time >= 9 || time <= 1) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *tory = [[EateryDoc alloc]
                       initWithTitle:@"Tory Row"
                       foodtype:@""
                       rating:4
                       description:@"Tory Row is a late-night hotspot as well as a fabulous modern restaurant all day long. Come by for a menu where everything is delicious and nothing is ordinary!"
                       opensAt:9
                       closesAt:1
                       isItOpen:isit
                       address:@"3 Brattle Street, Cambridge, Massachusetts 02138"
                       number:@"tel:6178768769"
                       website:@"http://www.toryrow.us/"
                       thumbImage:[UIImage imageNamed:@"toryThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"tory.jpg"]
                       latitude:42.3735449
                       longitude:-71.1195765
                       distance:111111];
    
#pragma mark - Trattoria Pulcinella
    
    if (time >= 17 && time <= 22) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *trattoria = [[EateryDoc alloc]
                            initWithTitle:@"Trattoria Pulcinella"
                            foodtype:@"dinner, italian"
                            rating:4
                            description:@"This down to earth establishment is focused on delivering quality dining experiences based on a fundamental, Mediterranean style of cooking. Come by for a delicious meal!"
                            opensAt:17
                            closesAt:22
                            isItOpen:isit
                            address:@"147 Huron Ave, Cambridge, Massachusetts 02138"
                            number:@"tel:617-491-6336"
                            website:@"http://www.trattoriapulcinella.net/"
                            thumbImage:[UIImage imageNamed:@"trattoriaThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"trattoria.jpg"]
                            latitude:42.38256
                            longitude:-71.1308553
                            distance:111111];
    
#pragma mark - Uno Chicago Grill
    
    // Sun-Thurs before midnight
    if ((time >= 5 && time <= 24) && (weekday >= 1 && weekday <= 5)) {
        closes = 24.30;
    }
    // Sun-Thurs after midnight
    else if (time < 5 && (weekday >= 2 && weekday <= 6)) {
        closes = 24.30;
    }
    // Fri-Sat before midnight
    else if ((time >= 5 && time <= 24) && (weekday == 6 || weekday == 7)) {
        closes = 1;
    }
    // Fri-Sat after midnight
    else {
        closes = 1;
    }
    
    if (closes == 1) {
        if (time >= 11 || time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        if (time >= 11 && time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    
    EateryDoc *unos = [[EateryDoc alloc]
                       initWithTitle:@"Uno Chicago Grill"
                       foodtype:@"dinner, pizza, salads, sandwiches, bar, burgers, dessert"
                       rating:3
                       description:@"At Unos, you won't leave hungry! Come on in for delicious deep dish pizzas, creative appetizers, big burgers, fresh salads and even juicy steaks! Go big or go home."
                       opensAt:11
                       closesAt:closes
                       isItOpen:isit
                       address:@"22 JFK Street, Cambridge, Massachusetts 02138"
                       number:@"tel:6174971530"
                       website:@"http://www.unos.com/"
                       thumbImage:[UIImage imageNamed:@"unosThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"unos.jpg"]
                       latitude:42.3729782
                       longitude:-71.1196811
                       distance:111111];
    
#pragma mark - UpStairs on the Square
    
    if (time >= 11 || time <= 1) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *upstairs = [[EateryDoc alloc]
                           initWithTitle:@"UpStairs on the Square"
                           foodtype:@"dinner, wine, bar"
                           rating:4
                           description:@"At UpStairs on the Square, you can expect to be treated well. Here, customer satisfaction starts the moment you walk in the door and doesn't stop until you're well on your way home! Dinner stops around 10 or 11 but the bar serves till 1 every night!"
                           opensAt:11
                           closesAt:1
                           isItOpen:isit
                           address:@"91 Winthrop Street, Cambridge, MA 02138"
                           number:@"tel:617-864-1933"
                           website:@"http://www.upstairsonthesquare.com/"
                           thumbImage:[UIImage imageNamed:@"upstairsThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"upstairs.jpg"]
                           latitude:42.3724175
                           longitude:-71.1209446
                           distance:111111];
    
#pragma mark - Veggie Planet
    
    if (time >= 11.3 && time <= 22.3) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *veggie = [[EateryDoc alloc]
                         initWithTitle:@"Veggie Planet"
                         foodtype:@"dinner, pizza, beer, wine"
                         rating:3
                         description:@"Looking for something different? Come to Veggie Planet for delicious all-vegetarian pizzas! Now serving beer and wine! Stop by in the evening to catch great folk music!"
                         opensAt:11.3
                         closesAt:22.3
                         isItOpen:isit
                         address:@"47 Palmer Street, Cambridge, MA 02138"
                         number:@"tel:617-661-1513"
                         website:@"http://www.veggieplanet.net/"
                         thumbImage:[UIImage imageNamed:@"veggieThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"veggie.jpg"]
                         latitude:42.3738466
                         longitude:-71.1199904
                         distance:111111];
    
#pragma mark - Wagamama
    
    // Mon-Wed
    if (weekday == 2 || weekday == 3 || weekday == 4) {
        opens = 11.3;
        closes = 22;
    }
    // Thurs-Sat
    else if (weekday == 5 || weekday == 6 || weekday == 7) {
        opens = 11.3;
        closes = 23;
    }
    else {
        opens = 12;
        closes = 22;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *wagamama = [[EateryDoc alloc]
                           initWithTitle:@"Wagamama"
                           foodtype:@"dinner, chinese, asian, japanese, salad, wine, beer"
                           rating:4
                           description:@"Wagamama is an international noodle restaurant located right in Harvard Square! Stop in for excellent Asian-fusion food ranging from various kinds of noodle and rice dishes to dumplings and soup!"
                           opensAt:opens
                           closesAt:closes
                           isItOpen:isit
                           address:@"57 JFK Street, Cambridge, MA 02138"
                           number:@"tel:617-499-0930"
                           website:@"http://www.wagamama.us/"
                           thumbImage:[UIImage imageNamed:@"wagamamaThumb.jpg"]
                           fullImage:[UIImage imageNamed:@"wagamama.jpg"]
                           latitude:42.3721459
                           longitude:-71.1209169
                           distance:111111];
    
#pragma mark - Zinneken's
    
    if (weekday >= 2 && weekday <= 5) {
        closes = 23;
    }
    else if (weekday == 6 || weekday == 7) {
        closes = 24;
    }
    else {
        closes = 21;
    }
    
    if (time >= 8 && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *zinnekens = [[EateryDoc alloc]
                            initWithTitle:@"Zinneken's"
                            foodtype:@"dessert, chocolate, cake"
                            rating:4
                            description:@"Zinneken's makes gourmet Belgian waffles fresh every day. Looking for something sweet AND savory, then Zinneken's is the place for you. A must-see!"
                            opensAt:8
                            closesAt:closes
                            isItOpen:isit
                            address:@"1154 Massachusetts Avenue, Cambridge, MA 02138"
                            number:@"tel:6176063295"
                            website:@"http://www.yelp.com/biz/zinnekens-cambridge"
                            thumbImage:[UIImage imageNamed:@"zinnekensThumb.jpg"]
                            fullImage:[UIImage imageNamed:@"zinnekens.jpg"]
                            latitude:42.371471
                            longitude:-71.1147083
                            distance:111111];
    
#pragma mark - Zoe's
    
    if (weekday == 2 || weekday == 3 || weekday == 4) {
        opens = 7.3;
        closes = 21;
    }
    else if (weekday == 5 || weekday == 6 || weekday == 7) {
        opens = 7.3;
        closes = 22;
    }
    else {
        opens = 8;
        closes = 21;
    }
    
    if (time >= opens && time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *zoes = [[EateryDoc alloc]
                       initWithTitle:@"Zoe's"
                       foodtype:@"greek, diner"
                       rating:3
                       description:@"Remember that classic diner from your childhood? Well step back in time and visit Zoe's! This quintessential Greek diner serves the classics, including breakfast all day!"
                       opensAt:opens
                       closesAt:closes
                       isItOpen:isit
                       address:@"1105 Massachusetts Avenue, Cambridge, MA 02138"
                       number:@"tel:617-495-0055"
                       website:@"http://www.yelp.com/biz/zoes-cambridge"
                       thumbImage:[UIImage imageNamed:@"zoesThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"zoes.jpg"]
                       latitude:42.370649
                       longitude:-71.1136497
                       distance:111111];
    
#pragma mark - IHOP
    
    if (time >= 7 || time <= 4) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *ihop = [[EateryDoc alloc]
                       initWithTitle:@"IHOP"
                       foodtype:@"diner, pancakes, burgers, fries, dinner"
                       rating:4
                       description:@"The International House of Pancakes is great at any time of day and is the ultimate late-night destination for Harvard students and Cambridge-ites. Stop in for delicious pancakes, omelets, burgers and more!"
                       opensAt:7
                       closesAt:4
                       isItOpen:isit
                       address:@"16 Eliot Street, Cambridge, MA 02138"
                       number:@"tel:(617) 354-0999"
                       website:@"http://www.ihop.com/"
                       thumbImage:[UIImage imageNamed:@"ihopThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"ihop.jpg"]
                       latitude:42.3720291
                       longitude:-71.1215069
                       distance:111111];
    
#pragma mark - Quincy Grille
    
    // Sun-Wed before midnight
    if ((time >= 5 && time <= 24) && (weekday >= 1 && weekday <= 4)) {
        closes = 2;
    }
    // Sun-Wed after midnight
    else if (time < 5 && (weekday >= 2 && weekday <= 5)) {
        closes = 2;
    }
    // Thurs before midnight
    else if ((time >= 5 && time <= 24) && (weekday == 5)) {
        closes = 3;
    }
    // Thurs after midnight
    else if (time < 5 && weekday == 6) {
        closes = 3;
    }
    // Fri-Sat before midnight
    else if ((time >= 5 && time <= 24) && (weekday == 6 || weekday == 7)) {
        closes = 4;
    }
    // Fri-Sat after midnight
    else if (time < 5 && (weekday == 7 || weekday == 1)) {
        closes = 4;
    }
    
    if (time >= 22 || time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *quincy = [[EateryDoc alloc]
                         initWithTitle:@"Quincy Grille"
                         foodtype:@"late, grill, burgers, french fries, harvard"
                         rating:4
                         description:@"For Harvard students, the grilles provide a great place to get a snack and meet up with friends when just about everything else is closed! Try the sweet potato fries!"
                         opensAt:22
                         closesAt:closes
                         isItOpen:isit
                         address:@"50 Plympton Street, Cambridge, MA 02138"
                         number:@"NONE"
                         website:@"http://www.thecrimson.com/article/2010/10/12/grille-pm-menu-quad/"
                         thumbImage:[UIImage imageNamed:@"annenbergThumb.jpg"]
                         fullImage:[UIImage imageNamed:@"annenberg.jpg"]
                         latitude:42.3713751
                         longitude:-71.117056
                         distance:111111];
    
#pragma mark - Eliot Grille
    
    // Closed Mon-Wed
    if ((time >= 5 && time <= 24) && (weekday == 2 || weekday == 3 || weekday == 4)) {
        isit = NO;
        closes = 25;
    }
    else if (time < 5 && (weekday == 3 || weekday == 4 || weekday == 5)) {
        isit = NO;
        closes = 25;
    }
    else {
        closes = 2;
    }
    
    if (closes == 2) {
        if (time >= 22 || time <= closes) {
            isit = YES;
        }
        else {
            isit = NO;
        }
    }
    else {
        isit = NO;
    }
    
    EateryDoc *eliot = [[EateryDoc alloc]
                        initWithTitle:@"Eliot Grille"
                        foodtype:@"late, grill, burgers, french fries, milkshakes, harvard"
                        rating:4
                        description:@"For Harvard students, the grilles provide a great place to get a snack and meet up with friends when just about everything else is closed! Head down to 'The Inferno' and try the milkshakes! (Closed Mon-Wed)"
                        opensAt:22
                        closesAt:closes
                        isItOpen:isit
                        address:@"100 Dunster Street, Cambridge, MA 02138"
                        number:@"NONE"
                        website:@"http://www.thecrimson.com/article/2010/10/12/grille-pm-menu-quad/"
                        thumbImage:[UIImage imageNamed:@"annenbergThumb.jpg"]
                        fullImage:[UIImage imageNamed:@"annenberg.jpg"]
                        latitude:42.3716096
                        longitude:-71.1196882
                        distance:111111];
    
#pragma mark - Quad Grille
    
    // Sun-Thurs before midnight
    if ((time >= 5 && time <= 24) && (weekday >= 1 && weekday <= 5)) {
        closes = 1.3;
    }
    // Sun-Thurs after midnight
    else if (time < 5 && (weekday >= 2 && weekday <= 6)) {
        closes = 1.3;
    }
    // Fri-Sat before midnight
    else if ((time >= 5 && time <= 24) && (weekday == 6 || weekday == 7)) {
        closes = 2.3;
    }
    // Fri-Sat after midnight
    else if (time < 5 && (weekday == 7 || weekday == 1)) {
        closes = 2.3;
    }
    
    if (time >= 22.3 || time <= closes) {
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    
    EateryDoc *quad = [[EateryDoc alloc]
                       initWithTitle:@"Quad Grille"
                       foodtype:@"late, grill, burgers, french fries, milkshakes, harvard"
                       rating:4
                       description:@"For Harvard students, the grilles provide a great place to get a snack and meet up with friends when just about everything else is closed! So come on, hike out to the Quad and grab a chicken snack wrap!"
                       opensAt:22.30
                       closesAt:closes
                       isItOpen:isit
                       address:@"60 Linnaean Street, Cambridge, MA 02138"
                       number:@"NONE"
                       website:@"http://www.thecrimson.com/article/2010/10/12/grille-pm-menu-quad/"
                       thumbImage:[UIImage imageNamed:@"annenbergThumb.jpg"]
                       fullImage:[UIImage imageNamed:@"annenberg.jpg"]
                       latitude:42.3818309
                       longitude:-71.1245817
                       distance:111111];
    
# pragma mark - Tasty Burger
    
    if (time >= 11 || time < 4){
        isit = YES;
    }
    else {
        isit = NO;
    }
    
    EateryDoc *tastyBurger = [[EateryDoc alloc]
                              initWithTitle:@"Tasty Burger"
                              foodtype:@"late, burgers, grill, french fries, milkshakes, sandwiches, dinner"
                              rating:5
                              description:@"Located right in the middle of Harvard Square is the brand new Tasty Burger. Stop in for delicious old-school burgers, fries, shakes and more. Now head over!"
                              opensAt:11
                              closesAt:4
                              isItOpen:isit
                              address:@"40 JFK Street, Cambridge, MA 02138"
                              number:@"tel:617-425-4444"
                              website:@"http://www.tastyburger.com/tasty-burger-harvard-square/"
                              thumbImage:[UIImage imageNamed:@"tastyThumb.jpg"]
                              fullImage:[UIImage imageNamed:@"tasty.jpg"]
                              latitude:42.3733023
                              longitude:-71.1195091
                              distance:111111];
    
    
    // add to mutable array
    NSMutableArray *loadedEateries = [NSMutableArray arrayWithObjects: als, annenberg, auBonPain, bGood, benAndJerrys, berryLine, bertuccis, boloco, bonChon, borderCafe, burdicks, cambridge, cardullos, charlies, chipotle, chutneys, clover, crazyDoughs, crema, dado, darwins, dunkin, eliot, falafel, felipes, finale, fire, firstPrinter, flatPatties, grafton, grendels, harvest, hongKong, ihop, insomnia, jpLicks, johnHarvards, lamole, legal, lizzys, maharaja, midwest, mrBartleys, noir, nubar, oggi, orinoco, otto, panera, pamplona, park, peets, pinkberry, pinocchios, qdoba, quad, quincy, redHouse, regattabar, rialto, russellHouse, sabra, sandrines, shabuya, shays, spice, starbucksChurch, starbucksGarage, starbucksSquare, subway, sushi, sweet, takemura, tamarind, tanjore, tastyBurger, temple, tenTables, tory, trattoria, unos, upstairs, veggie, wagamama, zinnekens, zoes, nil];
    
    // set them to master view controller
    
    UINavigationController *navController =  (UINavigationController *) self.window.rootViewController;
    MasterViewController *masterController = [navController.viewControllers objectAtIndex:0];
    NSLog(@"objectAtIndex 0 on navController is: %@", navController);
    masterController.eateries = loadedEateries;
    [masterController viewDidAppear:YES];
    [masterController.tableView reloadData];
    
}
				
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UINavigationController *navController = (UINavigationController *) self.window.rootViewController;
    MasterViewController *masterController = [navController.viewControllers objectAtIndex:0];
    NSLog(@"objectAtIndex 0 on navController is: %@", navController);
    [self loadData];
    [masterController.tableView reloadData];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
