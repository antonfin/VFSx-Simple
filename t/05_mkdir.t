#
#===============================================================================
#
#  DESCRIPTION:  
#
#       AUTHOR:  Anton Morozov (anton@antonfin.kiev.ua)
#      CREATED:  04.03.2011 09:33:56
#===============================================================================

use strict;
use warnings;

use Test::More tests => 12;
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
ok( -d File::Spec->catdir( $v_path, $new_folder ), 'New folder test_new1 real exists' );

# test 2
my $new_folder2 = 'test_new_' . rand(9999999);

ok( $vfs->chdir( "test1" ), "chdir - ok" );
ok( $vfs->mkdir( $new_folder2 ), 'Create new folder test_new2' );
ok( -d File::Spec->catdir( $v_path, 'test1', $new_folder2 ), 'New folder test_new2 real exists' );

# test 3
my $root = File::Spec->rootdir();

my $new_folder3 = 'test_new_' . rand(9999999);

my $_r_new_folder3 = File::Spec->catdir( $root, 'test1', 'test', $new_folder3 );
ok( $vfs->mkdir( $_r_new_folder3 ), 'Create new folder test_new3' );
ok( -d File::Spec->catdir( $v_path, "test1", 'test', $new_folder3 ), 'New folder test_new2 real exists' );

# test 1
SKIP: {
    skip 3, "For unix system only" if $^O =~ /win/i;

    my $new_folder4 = 'test_new_' . rand(9999999);
    ok( $vfs->mkdir( $new_folder4, 0700 ), 'Create new folder test_new4' );
    my $real_path = File::Spec->catdir( $v_path, 'test1', $new_folder4 );
    ok( -d $real_path, 'New folder test_new1 real exists' );
    my $mode = (stat($real_path))[2] & 07777;
    is ( $mode, 0700, 'Modes equal' );
}
#----------------------------

MakeTestPath->remove();

1;

