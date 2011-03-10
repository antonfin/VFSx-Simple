package VFSx::Simple;

use strict;
use warnings;

use File::Spec;

our $VERSION = 0.01;

my $err;

# return error last message
sub error { $err }

# constants
sub ROOT_PATH()         { 0 }
sub ROOT_SPLIT_PATH()   { 1 }
sub CUR_PATH()          { 2 }

# create new object
sub new {
    my ($class, $path) = @_;

    die "Path $path must be absolute\n"
        unless File::Spec->file_name_is_absolute( $path );

    my @sp = File::Spec->splitdir($path);
    return bless [ $path, \@sp, [ File::Spec->rootdir() ] ] => $class;
}

# change directory method
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

# return current directory
sub cwd {
    File::Spec->catdir( @{ shift->[ CUR_PATH ] } );
}

# creates a new filename linked to the old filename
sub link {
    my ($self, $old_file, $new_file) = @_;

    return 1 if 
        CORE::link $self->_make_path( $old_file ), $self->_make_path( $new_file );

    $err = $!;

    undef
}

# rename files or folders
sub rename {
    my ($self, $old_path, $new_path) = @_;

    return 1 if 
        rename $self->_make_path( $old_path ), $self->_make_path( $new_path );

    $err = $!;

    undef
}

# create new directory
sub mkdir {
    my ($self, $path, $mask) = @_;

    return 1 if defined $mask
            ? CORE::mkdir( $self->_make_path( $path ), $mask )
            : CORE::mkdir( $self->_make_path( $path ) );

    $err = $!;

    undef
}

# returns the value of a symbolic link
sub readlink {
    my ($self, $symlink) = @_;

    my $r_symlink = $self->_make_path( $symlink );

    unless ( -l $r_symlink ) {
        $err = "$symlink is not symbolic link";
        return undef;
    }

    my @path = File::Spec->splitdir( CORE::readlink( $r_symlink ) );
    splice( @path, 0, scalar( @{$self->[ ROOT_SPLIT_PATH ]} ));
    
    File::Spec->catdir( File::Spec->rootdir, @path );
}

# delete directory
sub rmdir {
    my ($self, $path, $mask) = @_;

    return 1 if CORE::rmdir( $self->_make_path( $path ) );

    $err = $!;

    undef
}

# return root folder
sub root { shift->[ ROOT_PATH ] }

# creates a new filename symbolically linked to the old filename
sub symlink {
    my ($self, $old_file, $new_file) = @_;

    return 1 if 
        CORE::symlink $self->_make_path( $old_file ), $self->_make_path( $new_file );

    $err = $!;

    undef

}

# unlink file
sub unlink {
    my ( $self, $file ) = @_;

    return 1 if CORE::unlink( $self->_make_path( $file ) );

    $err = $!;

    undef
}

###########################         Utils
#
# create virtual directory name
sub _make_path {
    my ($self, $path) = @_;

    my @sp      = File::Spec->splitdir( $path );
    my $is_abs  = File::Spec->file_name_is_absolute( $path );

    my @path    = (
        @{ $self->[ ROOT_SPLIT_PATH ] },
        _del_dots(
            $is_abs ? () : @{$self->[ CUR_PATH ] },
            @sp
        )
    );

    File::Spec->catdir( @path );
}

# delete dots ('.' and '..') directory name's from path list
sub _del_dots {
    my @list = @_;
    my @_l;
    for ( @list ) {
        if ( $_ eq '..' ) {
            pop @_l 
        }
        elsif ( $_ ne '.' ) {
            push @_l, $_;
        }
    }

    return @_l;
}

1;

__END__

=head1 NAME

VFSx::Simple -

=head1 VERSION

This documentation refers to <VFSx::Simple> version 0.01

=head1 AUTHOR

<Anton Morozov>  (<anton@antonfin.kiev.ua>)

=head1 SYNOPSIS

use VFSx::Simple;

=head1 DESCRIPTION

=head1 METHODS

from Fuse package hooks
    chmod
    chown
    flush
    fsync
    getattr
    getdir
    getxattr
    link        - OK
    listxattr
    mkdir       - OK
    mknod
    open
    read
    readdir
    readlink
    release
    removexattr 
    rename      - OK
    rmdir       - OK
    setxattr
    statfs
    symlink     - OK
    truncate
    unlink      - OK
    utime
    write

=head2 cwd

Return current directory. Shell analog

        print "Current directory is " . $vfs->cwd . "\n";

=head2 chdir

Change current directory. Shell analog.

        # for unix system
        # was default '/' current folder
        
        print $vfs->cwd . "\n";     # was printed '/';
        
        $vfs->chdir( '/tmp' );
        
        # now /tmp - current directory
        print $vfs->cwd . "\n";     # was printed '/tmp';

=head2 link

Create new link

        $vfs->link( '/tmp/test/file.txt', '/tmp/test/link-by-file.txt' ) or die "Can't create link\n";

=head2 mkdir

Create new directory

        if ( $vfs->mkdir("/tmp/test") ) {
            print "New folder /tmp/test was succesfully created\n";
        }
        else {
            die q|Coudn't create new folder /tmp/test. Error [| . $vfs->error . "]\n";
        }
=head2 readlink

Returns the value of a symbolic link

        print "Link $link -> " . $vfs->readlink( $link ) . "\n";

    NOTE! All symlinks created like absolut symlinks. And readlink method was returned absolut
    virtual symlink

=head2 rename

Rename files or directories
        
        if ( $vfs->rename('/tmp/test/file.txt', '/tmp/test/old.file.txt') ) {
            print "File /tmp/test/file.txt was succesfully renamed to '/tmp/test/old.file.txt'\n";
        }

        # or

        if ( $vfs->chdir('/tmp/test') and $vfs->rename('file.txt', 'old.file.txt') ) {
            print "File file.txt was succesfully renamed to 'old.file.txt'\n";
        }

=head2 rmdir

Delete directory

        if ( $vfs->rmdir("/tmp/test") ) {
            print "Folder /tmp/test was succesfully deleted\n";
        }
        else {
            die q|Coudn't delte folder /tmp/test. Error [| . $vfs->error . "]\n";
        }

=head2 symlink

Creates a new filename symbolically linked to the old filename

        $vfs->symlink('/home/test/script.sh', '/etc/init.d/bla-bla' )
            or die q|Coudn't create symlink. Error [| . $vfs->error . "]\n";

    NOTE! All symlinks created like absolut symlinks

=head2 unlink

Delete file

        $vfs->unlink("/tmp/test/file.txt") ) 
            or die q|Coudn't delte file /tmp/test/file.txt. Error [| . $vfs->error . "]\n";

=head1 LICENSE AND COPYRIGHT

    Copyright (c) 2011 (anton@antonfin.kiev.ua)
    All rights reserved.

=cut

