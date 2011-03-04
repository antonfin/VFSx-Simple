#
#===============================================================================
#
#  DESCRIPTION:  test root method
#
#       AUTHOR:  Anton Morozov (anton@antonfin.kiev.ua)
#      CREATED:  04.03.2011 09:28:54
#===============================================================================

use strict;
use warnings;

use Test::More tests => 3;                     # last test to print
use FindBin qw/$Bin/;
use lib "$Bin/lib";
use MakeTestPath;

my $v_path = MakeTestPath->init();

# Tests
use_ok('VFSx::Simple');
my $vfs = VFSx::Simple->new( $v_path );
ok ( $vfs, 'Object was successfully created' );

is ( $vfs->root, $v_path, 'root path - right' );
#----------------------------

MakeTestPath->remove();

1;


