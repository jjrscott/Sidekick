#!/usr/bin/perl -CSL

# This script checks for issues in storyboards that ibtool does not worry about.
# $ check_storyboard.pl "${SOURCE_ROOT}"

use utf8;
use strict;
use Data::Dumper;
use File::Slurp;

use DirHandle;

my $hasError = 0;

foreach my $path (@ARGV)
{
	search(\&processStoryboard, $path);
}

exit $hasError;


sub processStoryboard
{
	my $file = join "/", @_;
	if (-d $file)
	{
		return;
	}


	if ($file =~ /\.storyboard$/)
	{
		my $storyboardContent = read_file( $file );

		if ($storyboardContent !~ m~<document [^>]*?initialViewController="[^"]+"[^>]*>~)
		{
			$hasError=1;
			printf qq(%s:: error: Initial View Controller is not set.\n), $file;
		}
	}
}

sub search
{
  my ($function, @stack) = @_;
  my $handle = DirHandle->new(join "/", @stack);
  my @entries = $handle->read;
  $handle->close;
  foreach my $entry (@entries)
  {
    next if $entry =~ /^.{1,2}$/;
    $function->(@stack, $entry);
    if (-d join "/", @stack, $entry)
    {
      search($function, @stack, $entry);
    }
  }
}