#
#===============================================================================
#
#  DESCRIPTION:  test unlink method
#
#       AUTHOR:  Anton Morozov (anton@antonfin.kiev.ua)
#      CREATED:  10.03.2011 11:07:57
#===============================================================================

use strict;
use warnings;

use Test::More tests => 15;
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
my ($file, $real_file);

# test 1 abs. path (file)

# virtual path
$file = File::Spec->catdir( $root, 'file_list', 'text1.txt'        );

# real path
$real_file = File::Spec->catdir( $v_path, 'file_list', 'text1.txt'  );

main_test( $real_file, $file );


# test 2  rel. path (file)

# virtual path
$file = File::Spec->catdir( 'file_list', 'text2.txt'        );

# real path
$real_file = File::Spec->catdir( $v_path, 'file_list', 'text2.txt'  );

main_test( $real_file, $file );


# test 3  rel. path (file) v2

ok( $vfs->chdir( 'file_list' ), 'Chdir to file_list folder' );

# virtual path
$file = File::Spec->catdir( 'text3.txt'        );

# real path
$real_file = File::Spec->catdir( $v_path, 'file_list', 'text3.txt'  );

main_test( $real_file, $file );


# test 4 rel. path (file) v3

# virtual path
$file = File::Spec->catdir( '..', 'text4.txt'  );

# real path
$real_file = File::Spec->catdir( $v_path, 'text4.txt'  );

main_test( $real_file, $file );


MakeTestPath->remove();

sub main_test {
    my ( $real_file, $file ) = @_;
    ok ( -f $real_file,        "File $real_file exists" );
    ok( $vfs->unlink( $file ), "Delete file $file" );
    ok ( not(-f $real_file),   "File $real_file doesn't exist already" );
}

1;

