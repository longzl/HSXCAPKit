//
//  ListWidget.m
//  EOSFramework
//
//  Created by Chang Sam on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPListWidget.h"
#import "CAPListM.h"
#import "ListWidgetCell.h"
#import "CJSONDeserializer.h"
#import "EGORefreshTableHeaderView.h"

@implementation ListSectionModel

-(id)initWithSection: (NSString *) s{
    self = [super init];
    if (self) {
        _header = [[NSMutableDictionary alloc] init];
        _footer = [[NSMutableDictionary alloc] init];
        _items = [[NSMutableArray alloc] init];
        _section = s;
    }
    return self;
}

@end

@implementation CAPListWidget

+(void)load{
    [WidgetMap bind: @"list" withModelClassName: NSStringFromClass([CAPListM class]) withWidgetClassName: NSStringFromClass([CAPListWidget class])];
}

-(CGRect)measureRect:(CGSize)parentSize{
    return [super measureSelfRect: parentSize];
}

-(id)initWithModel:(UIWidgetM *)m withPageSandbox:(CAPPageSandbox *)sandbox{
    self = [super initWithModel: m withPageSandbox: sandbox];
    
    if (self) {
        sectionList = [[NSMutableArray alloc] initWithCapacity: 2];
        sectionIndexTitles = [[NSMutableArray alloc] initWithCapacity: 2];
        sectionHeaderWidgetMap = [[NSMutableDictionary alloc] initWithCapacity: 2];
        sectionFooterWidgetMap = [[NSMutableDictionary alloc] initWithCapacity: 2];
        
        pendingReloadCellIndexPaths = [[NSMutableArray alloc] initWithCapacity: 2];

        heightCache = [NSMutableDictionary dictionaryWithCapacity: 10];

        super.clipsToBounds = YES;
    }
    
    return self;
}

- (void) onCreateView{
    _listView = [[UITableView alloc] initWithFrame: [self getActualCurrentRect] style: UITableViewStylePlain];
    _listView.backgroundColor = self.backgroundColor;
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listView.estimatedRowHeight = 0;

    if (@available(iOS 11, *)) {
        _listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    [self buildRefreshTableView];

    [_listView reloadData];
}

- (void) buildRefreshTableView{
    if ([self.model.dragDownLayout isKindOfClass: [CAPViewM class]] && self.model.dragDownMinMovement > 0) {
        [OSUtils runBlockOnMain:^{
            if (_refreshTableView) {
                _refreshTableView.delegate = nil;
                [_refreshTableView removeFromSuperview];
                _refreshTableView = nil;
            }

            _refreshTableView = [[EGORefreshTableHeaderView alloc] initWithWidget: self];
            _refreshTableView.delegate = self;
            [_listView addSubview: _refreshTableView];
        }];
    }
}

- (void) setDragDownMinMovement: (NSNumber *) movement{
    self.model.dragDownMinMovement = [movement floatValue];

    [self buildRefreshTableView];
}

- (void) setDragDownLayout: (NSDictionary *) dic{
    self.model.dragDownLayout = [ModelBuilder buildModel: dic];

    [self buildRefreshTableView];
}

- (void) setOnDragDownStateChanged: (LuaFunction *) func {
    if ([func isKindOfClass: [LuaFunction class]]) {
        self.model.onDragDownStateChanged = func;
    }
}

- (void) setOnDragDownAction: (LuaFunction *) func {
    if ([func isKindOfClass: [LuaFunction class]]) {
        self.model.onDragDownAction = func;
    }
}

- (void)closeDragDown{
    [OSUtils runBlockOnMain:^{
        [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading: _listView];
    }];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return dragDowning; // should return if data source model is reloading
}

-(UIView *)innerView{
    return _listView;
}

static NSInteger sort(ListSectionModel *obj1, ListSectionModel *obj2, void *context) {
    
    if(obj1.order < obj2.order)
        return NSOrderedAscending;
    else if(obj1.order > obj2.order)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

- (void) reloadCellAtIndexPath: (NSIndexPath *) path{
    @synchronized(pendingReloadCellIndexPaths){
        if (![pendingReloadCellIndexPaths containsObject: path]) {
            [pendingReloadCellIndexPaths addObject: path];
        }else{
            return;
        }

        if (reloadPending) {
            return;
        }
        reloadPending = YES;

    }
    
    double delayInSeconds = 0.05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        @synchronized(pendingReloadCellIndexPaths){
            //[listView reloadRowsAtIndexPaths: pendingReloadCellIndexPaths withRowAnimation: UITableViewRowAnimationTop];
            [_listView reloadData];
            
            [pendingReloadCellIndexPaths removeAllObjects];
            reloadPending = NO;
        }
    });
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];

    if ([self.delegate respondsToSelector: @selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging: scrollView willDecelerate: decelerate];
    }

    if ([self.model.ontouchup isKindOfClass: [LuaFunction class]]) {
        CGPoint point = scrollView.contentOffset;
        point.x = [[self.pageSandbox getAppSandbox].scale getRefLength: point.x];
        point.y = [[self.pageSandbox getAppSandbox].scale getRefLength: point.y];
        [self.model.ontouchup executeWithoutReturnValue: self, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshTableView egoRefreshScrollViewDidScroll: scrollView];

    if ([self.delegate respondsToSelector: @selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll: scrollView];
    }

    if ([self.model.ontouchmove isKindOfClass: [LuaFunction class]]) {
        CGPoint point = scrollView.contentOffset;
        point.x = [[self.pageSandbox getAppSandbox].scale getRefLength: point.x];
        point.y = [[self.pageSandbox getAppSandbox].scale getRefLength: point.y];

        [self.model.ontouchmove executeWithoutReturnValue: self, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [BMXSwipableCell hideBasementOfAllCells];

    if ([self.model.ontouchdown isKindOfClass: [LuaFunction class]]) {
        CGPoint point = scrollView.contentOffset;
        point.x = [[self.pageSandbox getAppSandbox].scale getRefLength: point.x];
        point.y = [[self.pageSandbox getAppSandbox].scale getRefLength: point.y];
        [self.model.ontouchdown executeWithoutReturnValue: self, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
    }
}

- (void) setDataProvider: (id) object {
    [super setDataProvider: object];

    NSDictionary *data = nil;
    if ([object isKindOfClass: [NSString class]]) {
        data = [[CJSONDeserializer deserializer] deserializeAsDictionary: [object dataUsingEncoding: NSUTF8StringEncoding] error: nil];
    }else if ([object isKindOfClass: [NSDictionary class]]) {
        data = (NSDictionary *) object;
    }
    
    [sectionHeaderWidgetMap removeAllObjects];
    [sectionFooterWidgetMap removeAllObjects];
    
    NSDictionary *sectionInfoMap = [data valueForKey: @"sections"];
    
    NSMutableDictionary *sectionMap = [[NSMutableDictionary alloc] initWithCapacity: 2];
    for (NSString *key in sectionInfoMap) {
        ListSectionModel *sectionItem = [[ListSectionModel alloc] initWithSection: key];
        NSDictionary *sectionInfo = [sectionInfoMap valueForKey: key];
        [sectionItem.header addEntriesFromDictionary: [sectionInfo valueForKey: @"header"]];
        [sectionItem.footer addEntriesFromDictionary: [sectionInfo valueForKey: @"footer"]];
        sectionItem.order = [[sectionInfo valueForKey: @"order"] intValue];
        sectionItem.indexTitle = [sectionInfo valueForKey: @"indexTitle"];
        [sectionMap setValue: sectionItem forKey: key];
    }
    NSArray *items = [data valueForKey: @"items"];
    for (NSDictionary *item in items) {
        NSString *section = nil;
        if ([((CAPListM *) self.model).groupBy isKindOfClass: [NSString class]]) {
            section = [item valueForKey: ((CAPListM *) self.model).groupBy];
        }
        if (![section isKindOfClass: [NSString class]]) {
            section = @"$default";
        }
        ListSectionModel *sectionItem = [sectionMap valueForKey: section];
        if (sectionItem == nil) {
            sectionItem = [[ListSectionModel alloc] initWithSection: section];
            NSDictionary *sectionInfo = [sectionInfoMap valueForKey: section];
            [sectionItem.header addEntriesFromDictionary: [sectionInfo valueForKey: @"header"]];
            [sectionItem.footer addEntriesFromDictionary: [sectionInfo valueForKey: @"footer"]];
            
            [sectionMap setValue: sectionItem forKey: section];
        }
        [sectionItem.items addObject: [NSMutableDictionary dictionaryWithDictionary: item]];
    }
    
    [OSUtils runBlockOnMain:^{
        [sectionList removeAllObjects];
        [sectionList addObjectsFromArray: [sectionMap allValues]];
        [sectionList sortUsingFunction: sort context: nil];
        [sectionIndexTitles removeAllObjects];
        
        for (int i = 0; i < [sectionList count]; i++) {
            ListSectionModel *section = [sectionList objectAtIndex: i];
            if (section.indexTitle) {
                [sectionIndexTitles addObject: section.indexTitle];
            }else {
                [sectionIndexTitles addObject: @"#"];
            }
        }
        [_listView reloadData];
    }];
}

- (void) setEditing: (NSNumber *) value {
    _listView.editing = YES;
}

- (void) scrollToIndexByTitle: (NSString *) title{
    [self scrollToIndexByTitle: title : [NSNumber numberWithBool: YES]];
}

- (void) scrollToIndexByTitle: (NSString *) title : (NSNumber *) animated{
    if (![title isKindOfClass: [NSString class]]) {
        title = [title description];
    }
    NSUInteger idx = [sectionIndexTitles indexOfObject: title];
    if (idx != NSNotFound) {
        [OSUtils runBlockOnMain:^{
            [_listView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: NSNotFound inSection: idx]
                            atScrollPosition: UITableViewScrollPositionTop animated: [animated boolValue]];
        }];
    }
}

- (void) scrollTo: (NSNumber *) section : (NSNumber *) row{
    [self scrollTo: section : row : [NSNumber numberWithBool: YES]];
}

- (void) scrollTo: (NSNumber *) section {
    [self scrollTo: section : [NSNumber numberWithInteger: NSNotFound] : [NSNumber numberWithBool: YES]];
}

- (void) scrollTo: (NSNumber *) section : (NSNumber *) row : (NSNumber *) animated{
    if (!row || ![row respondsToSelector: @selector(intValue)] || [row intValue] < 0) {
        row = [NSNumber numberWithInteger: NSNotFound];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: [row integerValue] inSection: [section intValue]];
    [OSUtils runBlockOnMain:^{
        [_listView scrollToRowAtIndexPath: indexPath
                        atScrollPosition: UITableViewScrollPositionTop animated: [animated boolValue]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.model.__row_count) {
        return [OSUtils getInteger: self.model.__row_count
                        withObject: self
                        withObject: [NSNumber numberWithInteger: section]
                        withObject: nil];
    }
    return [((ListSectionModel *)[sectionList objectAtIndex: section]).items count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.model.__section_count) {
        return [OSUtils getInteger: self.model.__section_count
                        withObject: self
                        withObject: nil
                        withObject: nil];
    }
    return [sectionList count];
}

-(void)setViewFrame:(CGRect)rect{
    [super setViewFrame: rect];

    if (_refreshTableView && _refreshTableView.contentWidget) {
        _refreshTableView.frame = CGRectMake(0, -rect.size.height, rect.size.width, rect.size.height);
        CGRect contentRect = [_refreshTableView.contentWidget measureRect: [[self.pageSandbox getAppSandbox].scale getRefSize: rect.size]];
        _refreshTableView.contentWidget->currentRect = contentRect;
        [_refreshTableView.contentWidget reloadRect];
    }

    //[listView reloadData];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(((CAPListM *) self.model).indexable){
        if (self.model.__index_titles) {
            return [OSUtils getArray: self.model.__index_titles
                            withObject: self
                            withObject: nil
                            withObject: nil];
        }
        return sectionIndexTitles;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (((CAPListM *) self.model).indexable) {
        if (self.model.__title_index) {
            return [OSUtils getInteger: self.model.__title_index
                            withObject: self
                            withObject: title
                            withObject: [NSNumber numberWithInteger: index]];
        }
        return index;
    }else {
        return -1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *HeaderCellIdentifier = @"HeadCell";
    static NSString *BodyCellIdentifier = @"BodyCell";
    static NSString *FooterCellIdentifier = @"FooterCell";
    
    ListWidgetCell *cell = nil;
    CGFloat cellHeight = [[heightCache valueForKey:
                           [NSString stringWithFormat: @"%ld_%ld", [indexPath section], [indexPath row]]] floatValue];


    CAPListM *m = (CAPListM *) self.model;
    NSInteger rowCount = 0;
    NSDictionary *dic = nil;
    if (self.model.__row_count) {
        rowCount = [OSUtils getInteger: self.model.__row_count
                            withObject: self
                            withObject: [NSNumber numberWithInteger: [indexPath section]]
                            withObject: nil];
    } else {
        if ([sectionList count] == 0) {
            return nil;
        }
        ListSectionModel *sectionItem = [sectionList objectAtIndex: [indexPath section]];
        rowCount = [sectionItem.items count];
    }
    
    if (self.model.__row_data) {
        dic = [OSUtils getDictionary: self.model.__row_data
                          withObject: self
                          withObject: [NSNumber numberWithInteger: [indexPath section]]
                          withObject: [NSNumber numberWithInteger: [indexPath row]]];
    } else {
        if ([sectionList count] == 0) {
            return 0;
        }
        ListSectionModel *sectionItem = [sectionList objectAtIndex: [indexPath section]];
        dic = [sectionItem.items objectAtIndex: [indexPath row]];
    }
    
    NSString *identifier = [dic valueForKey: @"identifier"];

    if ([identifier isKindOfClass: [NSString class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    }
    
    if (cell == nil) {
        UIWidgetM *cm = nil;

        if (self.model.__row_layout && [identifier isKindOfClass: [NSString class]]) {
            NSDictionary *cellmodeldic = [OSUtils getObject: self.model.__row_layout
                                                 withObject: self
                                                 withObject: identifier
                                                 withObject: nil];
            
            
            if ([cellmodeldic isKindOfClass: [NSDictionary class]]) {
                cm = [ModelBuilder buildModel: cellmodeldic];
            }
        }
        
        if (!cm){
            NSUInteger row = [indexPath row];
            if (row == 0 && rowCount > 1 && m.header != nil) {
                cm = [m.header copy];
                identifier = HeaderCellIdentifier;
            }else if(row == rowCount - 1 && rowCount > 1 && m.footer != nil){
                cm = [m.footer copy];
                identifier = FooterCellIdentifier;
            }else{
                cm = [m.body copy];
                identifier = BodyCellIdentifier;
            }
            
            cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        }

        if (cell == nil && cm) {
            cell = [[ListWidgetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: identifier];
            cell.widget = [WidgetBuilder buildWidget: cm withPageSandbox: self.pageSandbox];
            [cell.widget createView];
        }
    }

    if (self.model.__row_action) {
        NSMutableDictionary *dic = [OSUtils getObject: self.model.__row_action
                                           withObject: self
                                           withObject: [NSNumber numberWithInteger: [indexPath section]]
                                           withObject: [NSNumber numberWithInteger: [indexPath row]]
                                    ];

        if ([dic isKindOfClass: [NSDictionary class]]) {
            if (cell.action) {
                [[cell.action innerView] removeFromSuperview];
            }
            UIWidgetM *actionModel = [ModelBuilder buildModel: dic];
            cell.action = [WidgetBuilder buildWidget: actionModel withPageSandbox: self.pageSandbox];
            if (actionModel.width && !actionModel.width.percentage) {
                cell.basementVisibleWidth = [[self.pageSandbox getAppSandbox].scale getActualLength: actionModel.width.value];
            } else {
                cell.basementVisibleWidth = 100;
            }

            [cell.action createView];
            CGRect rect = [cell.action measureRect:
             [[self.pageSandbox getAppSandbox].scale getRefSize: CGSizeMake(cell.basementVisibleWidth, cellHeight)]];
            cell.action->currentRect = rect;
            [cell.action reloadRect];

            [cell.basementView addSubview: [cell.action innerView]];
            cell.basementConfigured = YES;
            cell.swipeEnabled = YES;
        } else {
            cell.swipeEnabled = NO;
        }
    } else {
        cell.swipeEnabled = NO;
    }

    [cell.widget suspendLayout];
    [cell.widget doResetBeforeDataProvider];
    [cell.widget setDataProvider: dic];
    [cell.widget resumeLayout];

    if ([dic isKindOfClass: [NSMutableDictionary class]]) {
        cell.dp = (NSMutableDictionary *) dic;
    }
    cell.indexPath = indexPath;
//    cell.showsReorderControl = reording;
    cell.listWidget = self;

    cell.contentView.clipsToBounds = YES;
    [cell.contentView addSubview: [cell.widget innerView]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.model.onselected executeWithoutReturnValue: self, [NSNumber numberWithInteger: [indexPath section]], [NSNumber numberWithInteger: [indexPath row]], nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    CAPListM *m = (CAPListM *) self.model;
    if (self.model.__row_height) {
        NSUInteger height = [OSUtils getInteger: self.model.__row_height
                                     withObject: self
                                     withObject: [NSNumber numberWithInteger: [indexPath section]]
                                     withObject: [NSNumber numberWithInteger: [indexPath row]]];
        CGFloat value = [[self.pageSandbox getAppSandbox].scale getActualLength: height];

        [heightCache setValue: @(value) forKey: [NSString stringWithFormat: @"%ld_%ld", [indexPath section], [indexPath row]]];

        return value;
    }
    
    if ([sectionList count] == 0) {
        return 0;
    }
    
    ListSectionModel *sectionItem = [sectionList objectAtIndex: [indexPath section]];
    NSDictionary *dic = [sectionItem.items objectAtIndex: [indexPath row]];
    
    if ([dic valueForKey: @"height"]) {
        return [[self.pageSandbox getAppSandbox].scale getActualLength: [[dic valueForKey: @"height"] floatValue]];
    }
    
    if (row == 0 && [sectionItem.items count] > 0) {
        if (m.header != nil) {
            return [[self.pageSandbox getAppSandbox].scale getActualLength: m.header.height.value];
        }
    }else if(row < [sectionItem.items count] - 1){
        return [[self.pageSandbox getAppSandbox].scale getActualLength: m.body.height.value];
    }else{
        if (m.footer != nil) {
            return [[self.pageSandbox getAppSandbox].scale getActualLength: m.footer.height.value];
        }
    }
    return [[self.pageSandbox getAppSandbox].scale getActualLength: m.body.height.value];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CAPListM *m = (CAPListM *) self.model;
    if (m.sectionHeader == nil) {
        return 0;
    }
    if (self.model.__section_header_height) {
        CGFloat height = [OSUtils getInteger: self.model.__section_header_height
                        withObject: self
                        withObject: [NSNumber numberWithInteger: section]
                        withObject: nil];

        return [[self.pageSandbox getAppSandbox].scale getActualLength: height];
    }
    return [[self.pageSandbox getAppSandbox].scale getActualLength: m.sectionHeader.height.value];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.model.sectionHeader && !self.model.__section_header_layout) {
        return nil;
    }

    NSDictionary *data = nil;
    
    if (self.model.__section_header_data) {
        data = [OSUtils getDictionary: self.model.__section_header_data
                           withObject: self
                           withObject: [NSNumber numberWithInteger: section]
                           withObject: nil];
    } else {
        if ([sectionList count] == 0) {
            return nil;
        }
        ListSectionModel *sectionItem = [sectionList objectAtIndex: section];
        data = sectionItem.header;
    }

    NSString *identifier = data[@"identifier"];
    UIWidgetM *sectionHeader = nil;
    if ([identifier isKindOfClass: [NSString class]] && self.model.__section_header_layout) {
        NSDictionary *modeldic = [OSUtils getObject: self.model.__section_header_layout
                                         withObject: self
                                         withObject: identifier
                                         withObject: nil];

        if ([modeldic isKindOfClass: [NSDictionary class]]) {
            sectionHeader = [ModelBuilder buildModel: modeldic];
        }
    }

    if (!sectionHeader) {
        if (!self.model.sectionHeader) {
            return nil;
        } else {
            sectionHeader = [self.model.sectionHeader copy];
        }
    }

    NSNumber *key = [NSNumber numberWithInteger: section];
    CAPAbstractUIWidget *widget = [sectionHeaderWidgetMap objectForKey: key];
    if (widget == nil) {
        widget = [WidgetBuilder buildWidget: sectionHeader withPageSandbox: self.pageSandbox];
        [widget createView];
        
        if(widget != nil){
            [sectionHeaderWidgetMap setObject: widget forKey: key];
        }
    }
    if (widget == nil) {
        return nil;
    }
    [widget suspendLayout];
    [widget reset];
    [widget setDataProvider: data];
    [widget resumeLayout];

    CGSize size = [[self.pageSandbox getAppSandbox].scale getRefSize: _listView.frame.size];
    if (self.model.__section_header_height) {
        size.height = [OSUtils getInteger: self.model.__section_header_height
                                  withObject: self
                                  withObject: [NSNumber numberWithInteger: section]
                                  withObject: nil];
    }
    CGRect rect = [widget measureRect: size];
    widget->currentRect = rect;
    [widget reloadRect];

    return [widget innerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CAPListM *m = (CAPListM *) self.model;
    if (m.sectionFooter == nil) {
        return 0;
    }
    if (self.model.__section_footer_height) {
        CGFloat height = [OSUtils getInteger: self.model.__section_footer_height
                        withObject: self
                        withObject: [NSNumber numberWithInteger: section]
                        withObject: nil];
        return [[self.pageSandbox getAppSandbox].scale getActualLength: height];
    }
    return [[self.pageSandbox getAppSandbox].scale getActualLength: m.sectionFooter.height.value];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.model.sectionFooter == nil && !self.model.__section_footer_layout) {
        return nil;
    }

    NSDictionary *data = nil;
    
    if (self.model.__section_footer_data) {
        data = [OSUtils getDictionary: self.model.__section_footer_data
                           withObject: self
                           withObject: [NSNumber numberWithInteger: section]
                           withObject: nil];
    } else {
        if ([sectionList count] == 0) {
            return nil;
        }
        ListSectionModel *sectionItem = [sectionList objectAtIndex: section];
        data = sectionItem.footer;
    }

    NSString *identifier = data[@"identifier"];
    UIWidgetM *sectionFooter = nil;
    if ([identifier isKindOfClass: [NSString class]] && self.model.__section_footer_layout) {
        NSDictionary *modeldic = [OSUtils getObject: self.model.__section_footer_layout
                                         withObject: self
                                         withObject: identifier
                                         withObject: nil];

        if ([modeldic isKindOfClass: [NSDictionary class]]) {
            sectionFooter = [ModelBuilder buildModel: modeldic];
        }
    }

    if (!sectionFooter) {
        if (!self.model.sectionFooter) {
            return nil;
        } else {
            sectionFooter = [self.model.sectionFooter copy];
        }
    }

    NSNumber *key = [NSNumber numberWithInteger: section];
    CAPAbstractUIWidget *widget = [sectionFooterWidgetMap objectForKey: key];
    if (widget == nil) {
        widget = [WidgetBuilder buildWidget: sectionFooter withPageSandbox: self.pageSandbox];
        [widget createView];
        if(widget != nil){
            [sectionFooterWidgetMap setObject: widget forKey: key];
        }
    }
    if (widget == nil) {
        return nil;
    }
    [widget suspendLayout];
    [widget reset];
    [widget setDataProvider: data];
    [widget resumeLayout];

    CGSize size = [[self.pageSandbox getAppSandbox].scale getRefSize: _listView.frame.size];
    if (self.model.__section_header_height) {
        size.height = [OSUtils getInteger: self.model.__section_footer_height
                               withObject: self
                               withObject: [NSNumber numberWithInteger: section]
                               withObject: nil];
    }
    CGRect rect = [widget measureRect: size];
    widget->currentRect = rect;
    [widget reloadRect];
    
    return [widget innerView];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model.__row_moveable) {
        return [OSUtils getBOOL: self.model.__row_moveable
                     withObject: self
                     withObject: [NSNumber numberWithInteger: [indexPath section]]
                     withObject: [NSNumber numberWithInteger: [indexPath row]]];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if ([self.model.__row_onmove isKindOfClass: [LuaFunction class]]) {
        [(LuaFunction *)self.model.__row_onmove executeWithoutReturnValue: self, @([sourceIndexPath section]), @([sourceIndexPath row]), @([destinationIndexPath section]), @([destinationIndexPath row]), nil];
    } else {
        NSLog(@"Unhandled Reordering, please use __row_onmove.");
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#define GETSET(TYPE,KEY)    \
- (void)set##KEY: (TYPE) value{ \
    self.model.KEY = value; \
}\
- (TYPE)get##KEY{ \
    return self.model.KEY; \
}\

GETSET(NSObject *, __section_header_height)
GETSET(NSObject *, __section_header_data)
GETSET(NSObject *, __section_header_layout)
GETSET(NSObject *, __section_footer_height)
GETSET(NSObject *, __section_footer_data)
GETSET(NSObject *, __section_footer_layout)
GETSET(NSObject *, __section_count)
GETSET(NSObject *, __row_count)
GETSET(NSObject *, __row_data)
GETSET(NSObject *, __row_height)
GETSET(NSObject *, __row_moveable)
GETSET(NSObject *, __row_onmove)
GETSET(NSObject *, __row_action)
GETSET(NSObject *, __index_titles)
GETSET(NSObject *, __row_layout)

GETSET(LuaFunction *, onselected)

- (void) reload: (NSNumber *) section : (NSNumber *) row{
    if (![section isKindOfClass: [NSNumber class]] || ![row isKindOfClass: [NSNumber class]]) {
        return;
    }
    
    [OSUtils runBlockOnMain:^{
        [_listView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: [row integerValue] inSection: [section integerValue]]]
                        withRowAnimation: UITableViewRowAnimationNone];
    }];
}

-(void)onHiddenChanged{
    [super onHiddenChanged];
    
    if (self.model.hidden) {
        [_listView reloadData];
    }
}

- (void) _LUA_reload{
    [OSUtils runBlockOnMain:^{
        [heightCache removeAllObjects];
        
        [_listView reloadData];
    }];
}

@end
