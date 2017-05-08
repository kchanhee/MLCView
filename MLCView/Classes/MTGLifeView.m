//
//  MTGLifeView.m
//  Pods
//
//  Created by Chan on 5/6/17.
//
//

#import "MTGLifeView.h"

@interface MTGLifeView ()
@property (strong, nonatomic) UIButton *upButton;
@property (strong, nonatomic) UIButton *downButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (assign) NSInteger score;
@property (strong, nonatomic) NSMutableArray *scoreLedger;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation MTGLifeView
-(instancetype)init {
    if (self = [super init]) {
        // Setting up the buttons baybee
        self.upButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
        self.downButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 100, 100)];
        [self.upButton setImage:[UIImage imageNamed:@"up_icon"] forState:UIControlStateNormal];
        [self.downButton setImage:[UIImage imageNamed:@"down_icon"] forState:UIControlStateNormal];
        
        UITapGestureRecognizer *upTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapUp)];
        UITapGestureRecognizer *downTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapDown)];
        
        [self.upButton addGestureRecognizer:upTap];
        [self.downButton addGestureRecognizer:downTap];
        
        // Setting up the labels baybee
        self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 50, 50)];
        self.scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.scoreLabel.text = @"20";
        self.score = 20;
        
        // Setting up the tableview
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(200, 50, 100, 400)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        // score keeper
        self.scoreLedger = [[NSMutableArray alloc] initWithArray:@[@[@(20),@(0)]]];
        
        [self addSubview:self.upButton];
        [self addSubview:self.downButton];
        [self addSubview:self.scoreLabel];
        [self addSubview:self.tableView];
        [self.tableView reloadData];
    }
    return self;
}

# pragma mark - Button Actions
-(void)doTapUp {
    self.score++;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)self.score];
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateScore) userInfo:nil repeats:NO];
}

-(void)doTapDown {
    self.score--;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)self.score];
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateScore) userInfo:nil repeats:NO];
}

-(void)updateScore {
    NSInteger lastScore = (NSInteger) [[self.scoreLedger lastObject] firstObject];
    if (self.score == lastScore) {
        return; // Score is the same (don't add it to ledger)
    } else { // Score is different, add to ledger
        [self.scoreLedger addObject:@[@[@(self.score),@(lastScore - self.score)]]];
        [self.tableView reloadData];
    }
    
}
# pragma mark - Tableview datasource / delegate methods

-(UIView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    long int row = indexPath.row;
    static NSString *CellIdentifier = @"PeopleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.bounds = CGRectMake(0, 0, tableView.frame.size.width, cell.bounds.size.height);
    }
    UILabel *scoreIdx = [[UILabel alloc] init];
    if (row == 0) {
        scoreIdx.text = @"20";
    } else {
        NSArray *arr = [[NSArray alloc] initWithArray:self.scoreLedger[row]];
        if ((int)arr[1] < 0) {
            scoreIdx.text = [NSString stringWithFormat:@"%d (+%d)", (int)arr[0], (int)arr[1]];
        } else {
            scoreIdx.text = [NSString stringWithFormat:@"%d (-%d)", (int)arr[0], (int)arr[1]];
        }
        
    }
    [cell addSubview:scoreIdx];
    scoreIdx.frame = CGRectMake(0, 0, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scoreLedger.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


@end
