package MakeTestPath;

use strict;
use warnings;

use FindBin qw/$Bin/;
use File::Path 'rmtree';

my $v_path = "$Bin/tmp";

# init
sub init {
    mkdir $v_path              or die $! unless -d $v_path;
    mkdir "$v_path/test1"      or die $! unless -d "$v_path/test1";
    mkdir "$v_path/test2"      or die $! unless -d "$v_path/test2";
    mkdir "$v_path/test3"      or die $! unless -d "$v_path/test3";
    mkdir "$v_path/test1/test" or die $! unless -d "$v_path/test1/test";

    return $v_path;
}

sub remove {
    rmtree( $v_path );
}

1;

__END__

=head1 NAME

MakeTestPath - 

=head1 VERSION

This documentation refers to <MakeTestPath> version 0.1

=head1 AUTHOR

<Anton Morozov>  (<anton@antonfin.kiev.ua>)

=head1 SYNOPSIS

use MakeTestPath;

=head1 DESCRIPTION

=head1 METHODS

=head1 LICENSE AND COPYRIGHT

    Copyright (c) 2011 (anton@antonfin.kiev.ua)
    All rights reserved.

=cut


