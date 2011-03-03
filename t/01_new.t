#
#===============================================================================
#
#  DESCRIPTION:  test new methods
#
#       AUTHOR:  Anton Morozov (anton@antonfin.kiev.ua)
#      CREATED:  18.02.2011 14:48:05
#===============================================================================

use strict;
use warnings;

use Test::More tests => 3;                      # last test to print
use FindBin qw/$Bin/;
use lib 'lib/';
use lib "$Bin/lib";
use MakeTestPath;

my $v_path = MakeTestPath->init();

# Tests
use_ok('VFSx::Simple');
my $vfs = VFSx::Simple->new( $v_path );
ok ( $vfs, 'Object was successfully created, check 1' );
is ( ref $vfs, 'VFSx::Simple', 'Object was successfully created, check 2' );
#----------------------------

MakeTestPath->remove();

1;

