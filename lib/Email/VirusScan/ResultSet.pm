package Email::VirusScan::ResultSet;
use strict;
use warnings;
use vars qw( @ISA );
use Data::ResultSet;
@ISA = qw( Data::ResultSet );

__PACKAGE__->make_wrappers(qw( is_virus is_error is_clean ));

1;
__END__

=head1 NAME

Email::VirusScan::ResultSet - Holds Email::VirusScan::Result objects.

=head1 SYNOPSIS

   use Email::VirusScan;
   use Email::VirusScan::ResultSet;

   my $scanner = Email::VirusScan->new( ... );

   my $resultset = $scanner->scan( $some_mail_object );

   if( $resultset->has_error() ) {
      # Errors running virus scanner.  Do something.
      my @error_results = $resultset->get_error();
      ...
   } elsif( $resultset->has_virus() ) {
      # Viruses found.  Do something
      my @virus_results = $resultset->get_virus();
      ...
   }

=head1 METHODS

=head2 all_virus ( )

True if all results return true for ->is_virus()

=head2 all_error ( )

True if all results return true for ->is_error()

=head2 all_clean ( )

True if all results return true for ->is_clean()

=head2 has_virus ( )

True if at least one result returns true for ->is_virus()

=head2 has_error ( )

True if at least one result returns true for ->is_error()

=head2 has_clean ( )

True if at least one result returns true for ->is_clean()

=head2 get_clean ( )

Return all result objects for which ->is_clean is true

=head2 get_not_clean ( )

Return all result objects for which ->is_clean is false

=head2 get_error ( )

Return all result objects for which ->is_error is true

=head2 get_not_error ( )

Return all result objects for which ->is_error is false

=head2 get_virus ( )

Return all result objects for which ->is_virus is true

=head2 get_not_virus ( )

Return all result objects for which ->is_virus is false

=head1 SEE ALSO

L<Data::ResultSet>, L<Email::VirusScan::Result>

=head1 AUTHOR

Dave O'Neill (dmo@roaringpenguin.com)

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007 Roaring Penguin Software, Inc.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
