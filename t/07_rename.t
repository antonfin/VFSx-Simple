#
#===============================================================================
#
#  DESCRIPTION:  test rename method
#
#       AUTHOR:  Anton Morozov (anton@antonfin.kiev.ua)
#      CREATED:  10.03.2011 11:07:57
#===============================================================================

use strict;
use warnings;

use Test::More tests => 33;
use FindBin qw/$Bin/;
use File::Spec;
use lib "$Bin/lib";
use MakeTestPath;

my $v_path = MakeTestPath->init();

# Tests
use_ok('VFSx::Simple');
my $vfs = VFSx::Simple->new( $v_path );
ok ( $vfs, 'Object was successfully created' );

my $root = File::Spec->rootdir();

# test 1 rename absolute path (dir)

# virtual path
my $_old = File::Spec->catdir( $root, 'test_rename_1' );
my $_new = File::Spec->catdir( $root, 'test-rename-01' );

# real path
my $path_old = File::Spec->catdir( $v_path, 'test_rename_1'  );
my $path_new = File::Spec->catdir( $v_path, 'test-rename-01' );

ok ( -d $path_old,                  "Folder $_old exists" );
ok ( not(-d $path_new),             "Folder $_new doesn't exist" );
ok( $vfs->rename( $_old, $_new ),   "Rename folder $_old to $_new" );
ok ( not(-d $path_old),             "Folder $_old doesn't exist already" );
ok ( -d $path_new,                  "Folder $_new exists already" );

# test 2 rename rel. path (dir)

# virtual path
$_old = File::Spec->catdir( 'test_rename_2' );
$_new = File::Spec->catdir( 'test-rename-02' );

# real path
$path_old = File::Spec->catdir( $v_path, 'test_rename_2'  );
$path_new = File::Spec->catdir( $v_path, 'test-rename-02' );

ok ( -d $path_old,                  "Folder $_old exists" );
ok ( not(-d $path_new),             "Folder $_new doesn't exist" );
ok( $vfs->rename( $_old, $_new ),   "Rename folder $_old to $_new" );
ok ( not(-d $path_old),             "Folder $_old doesn't exist already" );
ok ( -d $path_new,                  "Folder $_new exists already" );


# test 3 rename abs. path (file)

# virtual path
$_old = File::Spec->catdir( $root, 'file_list', 'text1.txt'        );
$_new = File::Spec->catdir( $root, 'file_list', 'rename-01.info'   );

# real path
$path_old = File::Spec->catdir( $v_path, 'file_list', 'text1.txt'  );
$path_new = File::Spec->catdir( $v_path, 'file_list', 'rename-01.info' );

ok ( -f $path_old,                  "File $_old exists" );
ok ( not(-f $path_new),             "File $_new doesn't exist" );
ok( $vfs->rename( $_old, $_new ),   "Rename file $_old to $_new" );
ok ( not(-f $path_old),             "File $_old doesn't exist already" );
ok ( -f $path_new,                  "File $_new exists already" );


# test 4 rename rel. path (file)

# virtual path
$_old = File::Spec->catdir( 'file_list', 'text2.txt'        );
$_new = File::Spec->catdir( 'file_list', 'rename-02.info'   );

# real path
$path_old = File::Spec->catdir( $v_path, 'file_list', 'text2.txt'  );
$path_new = File::Spec->catdir( $v_path, 'file_list', 'rename-02.info' );

ok ( -f $path_old,                  "File $_old exists" );
ok ( not(-f $path_new),             "File $_new doesn't exist" );
ok( $vfs->rename( $_old, $_new ),   "Rename file $_old to $_new" );
ok ( not(-f $path_old),             "File $_old doesn't exist already" );
ok ( -f $path_new,                  "File $_new exists already" );


# test 5 rename rel. path (file) v2

ok( $vfs->chdir( 'file_list' ), 'Chdir to file_list folder' );

# virtual path
$_old = File::Spec->catdir( 'text3.txt'        );
$_new = File::Spec->catdir( 'rename-03.info'   );

# real path
$path_old = File::Spec->catdir( $v_path, 'file_list', 'text3.txt'  );
$path_new = File::Spec->catdir( $v_path, 'file_list', 'rename-03.info' );

ok ( -f $path_old,                  "File $_old exists" );
ok ( not(-f $path_new),             "File $_new doesn't exist" );
ok( $vfs->rename( $_old, $_new ),   "Rename file $_old to $_new" );
ok ( not(-f $path_old),             "File $_old doesn't exist already" );
ok ( -f $path_new,                  "File $_new exists already" );


# test 6 rename rel. path (file) v3

# virtual path
$_old = File::Spec->catdir( '..', 'text4.txt'  );
$_new = File::Spec->catdir( 'rename-04.info'   );

# real path
$path_old = File::Spec->catdir( $v_path, 'text4.txt'  );
$path_new = File::Spec->catdir( $v_path, 'file_list', 'rename-04.info' );

ok ( -f $path_old,                  "File $_old exists" );
ok ( not(-f $path_new),             "File $_new doesn't exist" );
ok( $vfs->rename( $_old, $_new ),   "Rename file $_old to $_new" );
ok ( not(-f $path_old),             "File $_old doesn't exist already" );
ok ( -f $path_new,                  "File $_new exists already" );

MakeTestPath->remove();

1;

