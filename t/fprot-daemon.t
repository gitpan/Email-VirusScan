package TestVirusScan::FPROT::Daemon;
use strict;
use warnings;

use lib qw( t/lib );
use base qw( TestVirusPlugin );

use Test::More;
use Test::Exception;
use File::Temp ();

use Email::VirusScan::Engine::FPROT::Daemon;

sub under_test { 'Email::VirusScan::Engine::FPROT::Daemon' };
sub required_arguments {
	{ host => '127.0.0.1' }
}

sub testable_live
{
	my ($self) = @_;

	# TODO: how to quickly check if it's available for testing?
	return 0;
}

sub constructor_failures : Test(2)
{
	my ($self) = @_;

	dies_ok { $self->under_test->new() } 'Constructor dies with no arguments';
	like( $@, qr/Must supply a 'host' config value/, ' ... error as expected');
}

__PACKAGE__->runtests() unless caller();
1;
