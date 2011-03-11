#
#===============================================================================
#
#  DESCRIPTION:  check chdir method
#
#       AUTHOR:  Anton Morozov (anton@antonfin.kiev.ua)
#      CREATED:  03.03.2011 18:19:24
#===============================================================================

use strict;
use warnings;

use Test::More tests => 22;                     # last test to print
use FindBin qw/$Bin/;
use lib 'lib/';
use lib "$Bin/lib";
use MakeTestPath;

my $v_path = MakeTestPath->init();

# Tests
use_ok('VFSx::Simple');
my $vfs = VFSx::Simple->new( $v_path );
ok ( $vfs, 'Object was successfully created' );

my $root = File::Spec->rootdir();

# 1
ok($vfs->chdir( 'test1' ), 'chdir to ./test1');

my $path = $vfs->cwd;

is ( $path, File::Spec->catdir( $root, "test1" ), 'Cur path must be ("/test1") dir' );

# 2
ok($vfs->chdir( 'test' ), 'chdir to ./test');

$path = $vfs->cwd;

is ( $path, File::Spec->catdir( $root, 'test1', 'test' ), 'Cur path must be ("/test1/test") dir' );

# 3
ok($vfs->chdir( $root ), 'chdir to "/"');

$path = $vfs->cwd;

is ( $path, $root, 'Cur path must be ("/") dir' );

# 4
ok($vfs->chdir( File::Spec->catdir( $root, 'test1', 'test' ) ), 'chdir to /test1/test');

$path = $vfs->cwd;

is ( $path, File::Spec->catdir( $root, 'test1', 'test' ), 'Cur path must be ("/test1/test") dir' );

# 5
ok($vfs->chdir( File::Spec->catdir( $root, 'test2' )), 'chdir to /test2');

$path = $vfs->cwd;

is ( $path, File::Spec->catdir( $root, 'test2' ), 'Cur path must be ("/test2") dir' );

{
    ok(!$vfs->chdir( File::Spec->catdir( 'test_Test_NO_' . rand(99999) ) ), 'chdir to non-exists dir' );
    ok( $vfs->error, 'error message exist' );
}

# 6

ok($vfs->chdir( File::Spec->catdir( $root, 'test1', 'test' ) ), 'chdir to /test1/test');

# check 2 file and 1 folder
ok( $vfs->X('-f', '../text6.txt'), "Check exists by /test1/text6.txt file" );
ok( $vfs->X('-f', '../../text4.txt'), "Check exists by /text4.txt file" );
ok( $vfs->X('-d', '../../file_list'), "Check exists by /file_list folder" );

SKIP: {
    skip 4, "For unix system only" if $^O =~ /win/i; 

    ok($vfs->chdir( '/test1/test/' ), 'chdir to /test1/test');
    ok( $vfs->X('-f', '../text6.txt'), "Check exists by /test1/text6.txt file" );
    ok( $vfs->X('-f', '../../text4.txt'), "Check exists by /text4.txt file" );
    ok( $vfs->X('-d', '../../file_list'), "Check exists by /file_list folder" );


}

#----------------------------

MakeTestPath->remove();

1;

