#
#  Copyright (C) 2008 Search Solution Corporation. 
#  Copyright (c) 2016 CUBRID Corporation.
# 
#  Redistribution and use in source and binary forms, with or without modification,
#  are permitted provided that the following conditions are met:
# 
#  - Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 
#  - Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
#  - Neither the name of the <ORGANIZATION> nor the names of its contributors
#    may be used to endorse or promote products derived from this software without
#    specific prior written permission.
# 
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
#  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
#  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
#  OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
#  OF SUCH DAMAGE.
# 
#

use 5.008;
use ExtUtils::MakeMaker;
use Config;
use strict;
require DBI::DBD;

my $os = $^O;
my $sep;

if ($os =~ /linux/i) {
    $sep = "/";
}
else {
    $sep = "\\";
}

my $CUBRID_INCLUDE = $ENV{CUBRID} . $sep . "include";
my $CUBRID_LIB = $ENV{CUBRID} . $sep . "lib";
my $dbi_arch_dir = DBI::DBD::dbd_dbi_arch_dir();

my %opts = (
    'NAME'          => 'DBD::cubrid',
    'VERSION_FROM'  => 'cubrid.pm',
    'INC'           => "-I$CUBRID_INCLUDE -I$dbi_arch_dir",
    'LIBS'          => ["-L$CUBRID_LIB -lcascci"],
    'AUTHOR'        => 'Zhang Hui',
    'ABSTRACT'      => 'CUBRID database driver for the DBI module',
    'dist'          => { 'SUFFIX'   => '.gz',
                         'COMPRESS' => 'gzip -9f' },
    'clean'         => { 'FILES' => '*.xsi' },
    'PREREQ_PM'     => { DBI => '1.61' },
    'OBJECT'        => '$(O_FILES)',
    'LINKTYPE'      => 'dynamic',
);

eval {require_version DBI 1.61;};
if ($@) {
    warn $@;
    print "Please install DBI version 1.61 or higher. Exit.\n";
    exit 1;
}

WriteMakefile(%opts);

package MY;

sub postamble {
    return DBI::DBD::dbd_postamble (@_);
}

sub libscan {
    my ($self, $path) = @_;
    ($path =~ m/\~$/) ? undef : $path;
}
