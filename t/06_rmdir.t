#
#===============================================================================
#
#  DESCRIPTION:  test rmdir method
#
#       AUTHOR:  Anton Morozov (anton@antonfin.kiev.ua)
#      CREATED:  04.03.2011 17:07:57
#===============================================================================

use strict;
use warnings;

use Test::More tests => 15;
use FindBin qw/$Bin/;
use lib "$Bin/lib";
use MakeTestPath;

my $v_path = MakeTestPath->init();

# Tests
use_ok('VFSx::Simple');
my $vfs = VFSx::Simple->new( $v_path );
ok ( $vfs, 'Object was successfully created' );

# test 1
my $new_folder = 'test_new_' . rand(9999999);
ok( $vfs->mkdir( $new_folder ), 'Create new folder test_new1' );

my $real_path = File::Spec->catdir( $v_path, $new_folder );
ok( -d $real_path, 'New folder test_new1 real exists' );
ok ( $vfs->rmdir( $new_folder ), 'Delete test folder' );
ok ( !-d $real_path, 'Folder was real deleted' );

# test 2
my $new_folder2 = 'test_new_' . rand(9999999);

ok( $vfs->chdir( "test1" ), "chdir - ok" );
ok( $vfs->mkdir( $new_folder2 ), 'Create new folder test_new2' );

$real_path = File::Spec->catdir( $v_path, 'test1', $new_folder2 );

ok( -d $real_path, 'New folder test_new2 real exists' );
ok ( $vfs->rmdir( $new_folder2 ), 'Delete test folder' );
ok ( !-d $real_path, 'Folder was real deleted' );

# test 3
my $root = File::Spec->rootdir();

my $new_folder3 = 'test_new_' . rand(9999999);

my $_r_new_folder3 = File::Spec->catdir( $root, 'test1', 'test', $new_folder3 );
ok( $vfs->mkdir( $_r_new_folder3 ), 'Create new folder test_new3' );

$real_path = File::Spec->catdir( $v_path, "test1", 'test', $new_folder3 );
ok( -d $real_path, 'New folder test_new2 real exists' );
ok ( $vfs->rmdir( $_r_new_folder3 ), 'Delete test folder (absolute path)' );
ok ( !-d $real_path, 'Folder was real deleted' );

#----------------------------

MakeTestPath->remove();

1;

