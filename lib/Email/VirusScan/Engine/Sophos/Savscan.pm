package Email::VirusScan::Engine::Sophos::Savscan;
use strict;
use warnings;
use Carp;

use Email::VirusScan::Engine;
use vars qw( @ISA );
@ISA = qw( Email::VirusScan::Engine );

use Cwd 'abs_path';

use Email::VirusScan::Result;

sub new
{
	my ($class, $conf) = @_;

	if(!$conf->{command}) {
		croak "Must supply a 'command' config value for $class";
	}

	my $self = {
		command => $conf->{command},
		args    => [ '-f', '-mime', '-all', '-cab', '-oe', '-tnef', '-archive', '-ss' ],
	};

	return bless $self, $class;
}

sub scan_path
{
	my ($self, $path) = @_;

	if(abs_path($path) ne $path) {
		return Email::VirusScan::Result->error("Path $path is not absolute");
	}

	my ($exitcode, $scan_response) = eval { $self->_run_commandline_scanner(join(' ', $self->{command}, @{ $self->{args} }, $path, '2>&1'), qr/(?:>>> Virus)|(?:Password)|(?:Could not check)/,); };

	if($@) {
		return Email::VirusScan::Result->error($@);
	}

	if(0 == $exitcode) {
		return Email::VirusScan::Result->clean();
	}

	if(1 == $exitcode) {
		return Email::VirusScan::Result->error('Virus scan interrupted');
	}

	if(2 == $exitcode) {

		# This is technically an error code, but Sophos chokes
		# on a lot of M$ docs with this code, so we let it
		# through...
		# TODO: Legacy commment from MIMEDefang. Figure this
		# out and see if this is sane behaviour.
		return Email::VirusScan::Result->clean();
	}

	if(3 == $exitcode) {
		my ($virus_name) = $scan_response =~ m/\s*>>> Virus '(\S+)'/;
		$virus_name ||= 'unknown-Savscan-virus';
		return Email::VirusScan::Result->virus($virus_name);
	}

	return Email::VirusScan::Result->error("Unknown return code from savscan: $exitcode");
}

1;
__END__

=head1 NAME

Email::VirusScan::Engine::Sophos::Savscan - Email::VirusScan backend for scanning with Sophos Savscan

=head1 SYNOPSIS

    use Email::VirusScanner;
    my $s = Email::VirusScanner->new({
	engines => {
		'-Sophos::Savscan' => {
			command => '/path/to/savscan',
		},
		...
	},
	...
}

=head1 DESCRIPTION

Email::VirusScan backend for scanning using Sophos savscan command-line scanner.

This class inherits from, and follows the conventions of,
Email::VirusScan::Engine.  See the documentation of that module for
more information.

=head1 CLASS METHODS

=head2 new ( $conf )

Creates a new scanner object.  B<$conf> is a hashref containing:

=over 4

=item command

Fully-qualified path to the 'savscan' binary.

=back

=head1 INSTANCE METHODS

=head2 scan_path ( $pathname )

Scan the path provided using the savscan binary provided to the
constructor.  Returns an Email::VirusScan::Result object.

=head1 DEPENDENCIES

L<Cwd>, L<Email::VirusScan::Result>,

=head1 SEE ALSO

L<http://www.sophos.com>

=head1 AUTHORS

David Skoll (dfs@roaringpenguin.com),

Dave O'Neill (dmo@roaringpenguin.com),

Adam Lanier

Nicholas Brealey

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007 Roaring Penguin Software, Inc.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
