//
//  NLGameViewController.m
//  StressIt
//
//  Created by Виталий Давыдов on 19.11.12.
//  Copyright (c) 2012 NIALSoft. All rights reserved.
//

#import "NLGameViewController.h"
#import "Generator.h"

#define kDefaultRandomNumberOfWordsToPlay 100

@interface NLGameViewController ()

@end

@implementation NLGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (int)randomIndex {
    return [Generator generateNewNumberWithStart:0 Finish:kDefaultRandomNumberOfWordsToPlay-1];
}

- (void)setUpLabel {
    self.word = [[NLLabel alloc] initWithWord:[self.wordsForGame objectAtIndex:[self randomIndex]]];
    
    self.word.center = self.view.center;
    [self.view addSubview:self.word];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wordsForGame = [NLCD_Word getRandomWordsInAmount:kDefaultRandomNumberOfWordsToPlay];
    self.playerScores = 0;
    self.myScores.text = self.apponentScore.text = [NSString stringWithFormat:@"%d", self.playerScores];
    
    [self setUpLabel];
//    [self setUpConnection];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark navigation

- (IBAction)menuButtonPressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark connection

- (void)setUpConnection {
    GKPeerPickerController *picker = [[GKPeerPickerController alloc]init];
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    picker.delegate = self;
    [picker show];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
    GKSession *session = [[GKSession alloc] initWithSessionID:@"Stress It" displayName:nil sessionMode:GKSessionModePeer];
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    self.session = session;
    self.session.delegate = self;
    picker.delegate = nil;
    
    NSLog(@"main peer %@ did connect peer %@", self.session.peerID, [self.session peersWithConnectionState:GKPeerStateConnected].lastObject);
    
    [picker dismiss];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    if (state == GKPeerStateConnected) {
        NSLog(@"succsessful connection");
        [session setDataReceiveHandler:self withContext:NULL];
    }
    else{
        NSLog(@"smth wrong");
        self.session.delegate = nil;
        self.session = nil;
    }
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    int *arr = (int *)[data bytes];
    BOOL answer = *arr;
    int apponentScore = *(arr+1);
    if (answer) {
        self.apponentScore.text = [NSString stringWithFormat:@"%d", apponentScore];
    }
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
    NSLog(@"user canseled connection");
    picker.delegate =  nil;
    picker = nil;
    [picker dismiss];
    [self menuButtonPressed];
}

#pragma mark send data via NLLabelDelegate

- (void)userTouchedOnLetter:(NSNumber *)letter {
        NSLog(@"letter %@ touched", letter);
}

- (void)changeWordAndScore {
    [self.word changeWordWithWord:[self.wordsForGame objectAtIndex:[self randomIndex]]];
    [UIView animateWithDuration:3 animations:^{
        self.myScores.text = [NSString stringWithFormat:@"%d", self.playerScores];
    }];
}

- (void)userAnsweredWithAnswer:(BOOL)answer {
    if (answer) {
        ++self.playerScores;
        [self changeWordAndScore];
        NSLog(@"right answer");
    }
    else {
        NSLog(@"wrong answer");
    }
    if (self.session) {
        int arr[2];
        arr[0] = answer;
        arr[1] = self.playerScores;
        
        NSData *data = [[NSData alloc] initWithBytes:arr length:sizeof(arr)];
        NSError *err;
        [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&err];
    }
    else {
        NSLog(@"invalid session");
    }
}

#pragma mark unload

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setMyScores:nil];
    [self setApponentScore:nil];
    [self setWord:nil];
    [super viewDidUnload];
}

@end
