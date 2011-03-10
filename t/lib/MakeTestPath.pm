package MakeTestPath;

use strict;
use warnings;

use FindBin qw/$Bin/;
use File::Path 'rmtree';

my $v_path = "$Bin/tmp";

# init
sub init {

    # create folders
    mkdir $v_path              or die $! unless -d $v_path;
    mkdir "$v_path/test1"      or die $! unless -d "$v_path/test1";
    mkdir "$v_path/test2"      or die $! unless -d "$v_path/test2";
    mkdir "$v_path/test3"      or die $! unless -d "$v_path/test3";
    mkdir "$v_path/test1/test" or die $! unless -d "$v_path/test1/test";
    
    mkdir "$v_path/test_rename_1" or die $! 
        unless -d "$v_path/test_rename_1";
    
    mkdir "$v_path/test_rename_2" or die $! 
        unless -d "$v_path/test_rename_2";
    
    mkdir "$v_path/file_list"  or die $! unless -d "$v_path/file_list";

    # create files
    my $fh;
    open ( $fh, '>', "$v_path/file_list/text1.txt" ) or die $! unless -f "$v_path/file_list/text1.txt";
    close $fh or die $! if $fh;

    open ( $fh, '>', "$v_path/file_list/text2.txt" ) or die $! unless -f "$v_path/file_list/text2.txt";
    close $fh or die $! if $fh;

    open ( $fh, '>', "$v_path/file_list/text3.txt" ) or die $! unless -f "$v_path/file_list/text3.txt";
    close $fh or die $! if $fh;

    open ( $fh, '>', "$v_path/text4.txt" ) or die $! 
        unless -f "$v_path/text4.txt";
    close $fh or die $! if $fh;

    open ( $fh, '>', "$v_path/text5.txt" ) or die $! 
        unless -f "$v_path/text5.txt";

    close $fh or die $! if $fh;

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


