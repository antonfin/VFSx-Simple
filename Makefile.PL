
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME	    => 'VFSx::Simple',
    VERSION_FROM=> 'lib/VFSx/Simple.pm',
    AUTHOR      => 'Anton Morozov <anton@antonfin.kiev.ua>',
    ABSTRACT    => 'Make virtual chroom to selected path',
    LICENSE     => 'artistic_2',
    test        => { TESTS => 't/*.t' },
    PREREQ_PM => {
        'File::Spec'    => 0,
        'FindBin'       => 0,
        'IO::File'      => 0,
    }
);

1;

