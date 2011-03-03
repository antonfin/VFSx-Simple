#
#===============================================================================
#
#  DESCRIPTION: test cwd method 
#
#       AUTHOR:  Anton Morozov (anton@antonfin.kiev.ua)
#      CREATED:  03.03.2011 18:18:52
#===============================================================================

use strict;
use warnings;

use Test::More tests => 5;                     # last test to print
use FindBin qw/$Bin/;
use lib 'lib/';
use lib "$Bin/lib";
use MakeTestPath;

my $v_path = MakeTestPath->init();

# Tests
use_ok('VFSx::Simple');
my $vfs = VFSx::Simple->new( $v_path );
ok ( $vfs, 'Object was successfully created' );

my $path = $vfs->cwd;

my $root = File::Spec->rootdir();
is ( $path, $root, 'Cur path must be ("/") dir' );

ok($vfs->chdir( 'test1' ));

$path = $vfs->cwd;
is ( $path, File::Spec->catdir( $root, "test1" ), 'Cur path must be ("/test1") dir' );

#----------------------------

MakeTestPath->remove();

1;

