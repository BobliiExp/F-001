//
//  localization.h
//  PYHero
//
//  Created by Bob Lee on 2018/8/21.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#ifndef localization_h
#define localization_h

#import "localization_sentence.h"

#define kLZ_Sentence    @"localization_sentence"

#define kAFLocalize(key)            NSLocalizedString(key, nil)
#define kAFLocalizeEx(key,localization_fileName)   NSLocalizedStringFromTable(key, localization_fileName, nil)

#define kActBack        @"actBack"
#define kActRefresh     @"actRefresh"
#define kActDownload    @"actDownload"
#define kActIgnore      @"actIgnore"
#define kActEdit        @"actEdit"
#define kActUpTop       @"actUpTop"
#define kActCancelTop   @"actCancelTop"
#define kActDelete      @"actDelete"
#define kActRevoke      @"actRevoke"
#define kActSendFish    @"actSendFish"
#define kActAdd         @"actAdd"
#define kActCancel      @"actCancel"
#define kActConfirm     @"actConfirm"
#define kActSearch      @"actSearch"
#define kActSend        @"actSend"
#define kActSave        @"actSave"
#define kActTakePicture @"actTakePicture"
#define kActSelectPicture  @"actSelectPicture"
#define kActRecord      @"actRecord"
#define kActTakeVideo   @"actTakeVideo"
#define kActSelectVideo @"actSelectVideo"
#define kActPreview     @"actPreview"
#define kActLeave       @"actLeave"
#define kActClose       @"actClose"
#define kActSuccess       @"actSuccess"
#define kActFailed       @"actFailed"

#define kActCopy        @"actCopy"
#define kActTransmit    @"actTransmit"
#define kActResend      @"actResend"
#define kActInform      @"actInform"
#define kActPlay        @"actPlay"
#define kActPlayMicro   @"actPlayMicro"
#define kActPlayLoud    @"actPlayLoud"
#define kActPause       @"actPause"
#define kActUse         @"actUse"
#define kActRight       @"actRight"
#define kActWrong       @"actWrong"
#define kActAccept      @"actAccept"
#define kActRefuse      @"actRefuse"
#define kActStart       @"actStart"
#define kActContinue    @"actContinue"
#define kActOver        @"actOver"
#define kActGameRule    @"actGameRule"
#define kActBlcak       @"actBlcak"
#define kActCollect     @"actCollect"


/**************** Static text ***********************/

#define kStrYubang      @"strYubang"
#define kStrYuxin       @"strYuxin"
#define kStrYulong      @"strYulong"
#define kStrYuxi       @"strYuxi"
#define kStrYuchao      @"strYuchao"

#define kstrStartVoice      @"strStartVoice"
#define kstrRecord       @"strRecord"
#define kstrStartTime      @"strStartTime"
#define kstrTimespan       @"strTimespan"
#define kstrScoreCast      @"strScoreCast"

#define kStrYusen       @"strYusen"
#define kStrYucontact   @"strYucontact"
#define kStrYucenter    @"strYucenter"
#define kStrYuocean     @"strYuocean"
#define kStrYuground    @"strYuground"
#define kStrYuown       @"strYuown"
#define kStrYuwork      @"strYuwork"
#define kStrYustreet    @"strYustreet"
#define kStrYumsg       @"strYumsg"
#define kStrYulife      @"strYulife"
#define kStrGoldMall      @"strGoldMall"
#define kStrDiscover    @"strDiscover"
#define kStrYuluck      @"strYuluck"


#define kStrCrowHome    @"strCrowHome"
#define kStrCrowPublish @"strCrowPublish"
#define kStrCrowShow    @"strCrowShow"
#define kStrCrowOwn     @"strCrowOwn"

#define kStrRadioRank     @"strRadioRank"
#define kStrRadioOnline     @"strRadioOnline"

#define kStrTBaoOrder     @"strTBaoOrder"
#define kStrTBaoTB     @"strTBaoTB"
#define kStrTBaoJD     @"strTBaoJD"

#define kStrDiscountHome @"strDiscountHome"

#define kStrYuzaiDesc      @"strYuzaiDesc"
#define kStrYuzhuangDesc   @"strYuzhuangDesc"
#define kStrYubaoDesc      @"strYubaoDesc"
#define kStrYugeDesc       @"strYugeDesc"
#define kStrYuwangDesc     @"strYuwangDesc"

#define kStrRefreshing  @"strRefreshing"
#define kStrLoading     @"strLoading"

#define kStrSuccess     @"strSuccess"
#define kStrError       @"strError"
#define kStrWarning     @"strWarning"
#define kStrFail        @"strFail"

#define kStrMorning     @"strMorning"
#define kStrAfternood   @"strAfternood"
#define kStrYesterday   @"strYesterday"
#define kStrBefYesterday @"strBefYesterday"

#define kStrYear        @"strYear"
#define kStrMonth       @"strMonth"
#define kStrDay         @"strDay"
#define kStrHour        @"strHour"
#define kStrMinute      @"strMinute"
#define kStrSecond      @"strSecond"
#define kStrCurrentYear     @"strCurrentYear"
#define kStrCurrentMonth    @"strCurrentMonth"
#define kStrCurrentWeek     @"strCurrentWeek"
#define kStrToday           @"strToday"


#define kStrSunday           @"strSunday"
#define kStrSaturday         @"strSaturday"
#define kStrFriday           @"strFriday"
#define kStrMonday           @"strMonday"
#define kStrTuesday          @"strTuesday"
#define kStrWednesday        @"strWednesday"
#define kStrThursday         @"strThursday"

#endif /* localization_h */
