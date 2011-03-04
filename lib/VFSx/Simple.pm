package VFSx::Simple;

use strict;
use warnings;

use File::Spec;

our $VERSION = 0.1;

my $err;

sub error { $err } 

sub ROOT_PATH()         { 0 }
sub ROOT_SPLIT_PATH()   { 1 }
sub CUR_PATH()          { 2 }

sub new {
    my ($class, $path) = @_;
    
    die "Path $path must be absolute\n" 
        unless File::Spec->file_name_is_absolute( $path );
    
    my @sp = File::Spec->splitdir($path);
    return bless [ $path, \@sp, [ File::Spec->rootdir() ] ] => $class;
}

sub chdir {
    my ($self, $path) = @_;

    my @sp      = File::Spec->splitdir( $path );
    my $is_abs  = File::Spec->file_name_is_absolute( $path );

    my @path = $is_abs ? @sp : (@{$self->[ CUR_PATH ] }, @sp);
    if ( -d File::Spec->catdir( @{ $self->[ ROOT_SPLIT_PATH ] }, @path ) ) {
        $self->[ CUR_PATH ] = \@path;
        return 1;
    }

    $err = qq/Path $path doesn't exist/;

    undef
}

sub cwd {
    File::Spec->catdir( @{ shift->[ CUR_PATH ] } );
}

sub mkdir {
    my ($self, $path, $mask) = @_;

    return 1 if defined $mask
            ? CORE::mkdir( $self->_make_path( $path ), $mask )
            : CORE::mkdir( $self->_make_path( $path ) );
    
    $err = $!;
    
    undef
}

sub root { shift->[ ROOT_PATH ] }

sub _make_path {
    my ($self, $path) = @_;

    my @sp      = File::Spec->splitdir( $path );
    my $is_abs  = File::Spec->file_name_is_absolute( $path );

    my @path    = (
        @{ $self->[ ROOT_SPLIT_PATH ] },
        $is_abs ? () : @{$self->[ CUR_PATH ] },
        @sp
    );

    File::Spec->catdir( @path );
}

1;

__END__

=head1 NAME

VFSx::Simple - 

=head1 VERSION

This documentation refers to <VFSx::Simple> version 0.1

=head1 AUTHOR

<Anton Morozov>  (<anton@antonfin.kiev.ua>)

=head1 SYNOPSIS

use VFSx::Simple;

=head1 DESCRIPTION

=head1 METHODS

=head1 LICENSE AND COPYRIGHT

    Copyright (c) 2011 (anton@antonfin.kiev.ua)
    All rights reserved.

=cut


