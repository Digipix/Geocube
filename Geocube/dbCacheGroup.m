/*
 * Geocube
 * By Edwin Groothuis <geocube@mavetju.org>
 * Copyright 2015 Edwin Groothuis
 * 
 * This file is part of Geocube.
 * 
 * Geocube is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Geocube is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Geocube.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "Geocube-Prefix.pch"

@implementation dbCacheGroup

@synthesize name, usergroup;

- (id)init:(NSId)__id name:(NSString *)_name usergroup:(BOOL)_usergroup
{
    self = [super init];
    _id = __id;
    name = _name;
    usergroup = _usergroup;
    [self finish];
    return self;
}

+ (void)cleanupAfterDelete
{
    // Delete all logs from caches not longer in an usergroup (should be zero)
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"delete from cache_group2caches where cache_id not in (select cache_id from cache_group2caches where cache_group_id in (select id from cache_groups where usergroup != 0))");
        DB_CHECK_OKAY;
        DB_FINISH;
    }

    // Delete all logs from caches not longer in an usergroup
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"delete from logs where cache_id not in (select cache_id from cache_group2caches where cache_group_id in (select id from cache_groups where usergroup != 0))");
        DB_CHECK_OKAY;
        DB_FINISH;
    }

    // Delete all travelbugs from caches not longer in an usergroup
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"delete from travelbug2cache where cache_id not in (select cache_id from cache_group2caches where cache_group_id in (select id from cache_groups where usergroup != 0))");
        DB_CHECK_OKAY;
        DB_FINISH;
    }

    // Delete all attributes from caches not longer in an usergroup
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"delete from attribute2cache where cache_id not in (select cache_id from cache_group2caches where cache_group_id in (select id from cache_groups where usergroup != 0))");
        DB_CHECK_OKAY;
        DB_FINISH;
    }

    // Delete all travelbugs from caches not longer in an usergroup
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"delete from travelbug2cache where cache_id not in (select cache_id from cache_group2caches where cache_group_id in (select id from cache_groups where usergroup != 0))");
        DB_CHECK_OKAY;
        DB_FINISH;
    }

    // Delete all caches which are not longer in a usergroup
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"delete from caches where id not in (select cache_id from cache_group2caches where cache_group_id in (select id from cache_groups where usergroup != 0))");
        DB_CHECK_OKAY;
        DB_FINISH;
    }
}

- (void)dbEmpty
{
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"delete from cache_group2caches where cache_group_id = ?");

        SET_VAR_INT(req, 1, _id);

        DB_CHECK_OKAY;
        DB_FINISH;
    }

    [dbCacheGroup cleanupAfterDelete];
}


+ (dbCacheGroup *)dbGetByName:(NSString *)name
{
    dbCacheGroup *cg;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select id, name, usergroup from cache_groups where name = ?");

        SET_VAR_TEXT(req, 1, name);

        DB_IF_STEP {
            INT_FETCH_AND_ASSIGN(req, 0, _id);
            TEXT_FETCH_AND_ASSIGN(req, 1, name);
            INT_FETCH_AND_ASSIGN(req, 2, ug);
            cg = [[dbCacheGroup alloc] init:_id name:name usergroup:ug];
        }
        DB_FINISH;
    }
    return cg;
}

+ (NSMutableArray *)dbAll
{
    NSMutableArray *cgs = [[NSMutableArray alloc] initWithCapacity:20];
    dbCacheGroup *cg;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select id, name, usergroup from cache_groups");

        DB_WHILE_STEP {
            INT_FETCH_AND_ASSIGN(req, 0, __id);
            TEXT_FETCH_AND_ASSIGN(req, 1, _name);
            INT_FETCH_AND_ASSIGN(req, 2, _ug);
            cg = [[dbCacheGroup alloc] init:__id name:_name usergroup:_ug];
            [cgs addObject:cg];
        }
        DB_FINISH;
    }
    return cgs;
}

+ (NSArray *)dbAllByCache:(NSId)c_id
{
    NSMutableArray *cgs = [[NSMutableArray alloc] initWithCapacity:20];
    dbCacheGroup *cg;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select cache_group_id from cache_group2caches where cache_id = ?");

        SET_VAR_INT(req, 1, c_id);

        DB_WHILE_STEP {
            INT_FETCH_AND_ASSIGN(req, 0, cgid);
            cg = [dbc CacheGroup_get:cgid];
            [cgs addObject:cg];
        }
        DB_FINISH;
    }
    return cgs;
}

- (NSInteger)dbCountCaches
{
    NSInteger count = 0;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select count(id) from cache_group2caches where cache_group_id = ?");

        SET_VAR_INT(req, 1, self._id);

        DB_IF_STEP {
            INT_FETCH_AND_ASSIGN(req, 0, c);
            count = c;
        }
        DB_FINISH;
    }
    return count;
}

+ (NSId)dbCreate:(NSString *)_name isUser:(BOOL)_usergroup
{
    NSId __id;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"insert into cache_groups(name, usergroup) values(?, ?)");

        SET_VAR_TEXT(req, 1, _name);
        SET_VAR_BOOL(req, 2, _usergroup);

        DB_CHECK_OKAY;
        DB_GET_LAST_ID(__id);
        DB_FINISH;
    }
    return __id;
}

- (void)dbDelete
{
    [dbCacheGroup dbDelete:self._id];
}

+ (void)dbDelete:(NSId)__id
{
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"delete from cache_groups where id = ?");

        SET_VAR_INT(req, 1, __id);

        DB_CHECK_OKAY;
        DB_FINISH;
    }

    [dbCacheGroup cleanupAfterDelete];
}

- (void)dbUpdateName:(NSString *)newname
{
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"update cache_groups set name = ? where id = ?");

        SET_VAR_TEXT(req, 1, newname);
        SET_VAR_INT(req, 2, _id);

        DB_CHECK_OKAY;
        DB_FINISH;
    }
}

- (void)dbAddCache:(NSId)__id
{
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"insert into cache_group2caches(cache_group_id, cache_id) values(?, ?)");

        SET_VAR_INT(req, 1, self._id);
        SET_VAR_INT(req, 2, __id);

        DB_CHECK_OKAY;
        DB_FINISH;
    }
}

- (BOOL)dbContainsCache:(NSId)c_id
{
    NSInteger count = 0;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select count(id) from cache_group2caches where cache_group_id = ? and cache_id = ?");

        SET_VAR_INT(req, 1, self._id);
        SET_VAR_INT(req, 2, c_id);

        DB_IF_STEP {
            INT_FETCH_AND_ASSIGN(req, 0, c);
            count = c;
        }
        DB_FINISH;
    }
    return count == 0 ? NO : YES;
}

@end
