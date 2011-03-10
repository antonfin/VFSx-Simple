#
#===============================================================================
#
#  DESCRIPTION:  test symlink method
#
#       AUTHOR:  Anton Morozov (anton@antonfin.kiev.ua)
#      CREATED:  10.03.2011 13:07:57
#===============================================================================

use strict;
use warnings;

use Test::More tests => 23;
use FindBin qw/$Bin/;
use File::Spec;
use lib "$Bin/lib";
use MakeTestPath;

my $v_path = MakeTestPath->init();

use_ok('VFSx::Simple');
my $vfs = VFSx::Simple->new( $v_path );
ok ( $vfs, 'Object was successfully created' );

SKIP: {
    skip 21, "For unix system only" if $^O =~ /win/i;
# Tests

    my $root = File::Spec->rootdir();

# test 1 abs. path (file)

# virtual path
    my $_old = File::Spec->catdir( $root, 'file_list', 'text1.txt'        );
    my $_new = File::Spec->catdir( $root, 'file_list', 'symlink-01.info'   );

# real path
    my $path_old = File::Spec->catdir( $v_path, 'file_list', 'text1.txt'  );
    my $path_new = File::Spec->catdir( $v_path, 'file_list', 'symlink-01.info' );

    main_test( $_old, $_new, $path_old, $path_new );


# test 2 rel. path (file)

# virtual path
    $_old = File::Spec->catdir( 'file_list', 'text2.txt'        );
    $_new = File::Spec->catdir( 'file_list', 'symlink-02.info'   );

# real path
    $path_old = File::Spec->catdir( $v_path, 'file_list', 'text2.txt'  );
    $path_new = File::Spec->catdir( $v_path, 'file_list', 'symlink-02.info' );

    main_test( $_old, $_new, $path_old, $path_new );


# test 3 rel. path (file) v2

    ok( $vfs->chdir( 'file_list' ), 'Chdir to file_list folder' );

# virtual path
    $_old = File::Spec->catdir( 'text3.txt'        );
    $_new = File::Spec->catdir( 'symlink-03.info'   );

# real path
    $path_old = File::Spec->catdir( $v_path, 'file_list', 'text3.txt'  );
    $path_new = File::Spec->catdir( $v_path, 'file_list', 'symlink-03.info' );

    main_test( $_old, $_new, $path_old, $path_new );


# test 4 rel. path (file) v3

# virtual path
    $_old = File::Spec->catdir( '..', 'text4.txt'  );
    $_new = File::Spec->catdir( 'symlink-04.info'   );

# real path
    $path_old = File::Spec->catdir( $v_path, 'text4.txt'  );
    $path_new = File::Spec->catdir( $v_path, 'file_list', 'symlink-04.info' );
    main_test( $_old, $_new, $path_old, $path_new );

}

sub main_test {
    my ( $_old, $_new, $path_old, $path_new ) = @_;
    ok ( -f $path_old,                  "File $_old exists" );
    ok ( not(-f $path_new),             "File $_new doesn't exist" );
    ok ( $vfs->symlink( $_old, $_new ), "Symlink file $_old to $_new" );
    ok ( -f $path_old,                  "File $_old exists yet" );
    ok ( -l $path_new,                  "File $_new exists already" );
}

MakeTestPath->remove();

1;

