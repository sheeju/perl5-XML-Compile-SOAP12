use warnings;
use strict;

package XML::Compile::SOAP12;
use base 'XML::Compile::SOAP';

use Log::Report 'xml-compile-soap12', syntax => 'SHORT';

use XML::Compile::Util;
use XML::Compile::SOAP::Util;
use XML::Compile::SOAP12::Util;

my %roles =
 ( NEXT     => SOAP12NEXT
 , NONE     => SOAP12NONE
 , ULTIMATE => SOAP12ULTIMATE
 );
my %rev_roles = reverse %roles;

XML::Compile->addSchemaDirs(__FILE__);
XML::Compile->knownNamespace
 ( &SOAP12ENC => '2003-soap-encoding.xsd'
 , &SOAP12ENV => '2003-soap-envelope.xsd'
 , &SOAP12RPC => '2003-soap-rpc.xsd'
 );

=chapter NAME
XML::Compile::SOAP12 - base class for SOAP1.2 implementation

=chapter SYNOPSIS
**WARNING** Implementation not finished: not usable!!

=chapter DESCRIPTION
This module handles the SOAP protocol version 1.2.
See F<http://www.w3.org/TR/soap12/>).

The client specifics are implemented in M<XML::Compile::SOAP12::Client>,
and the server needs can be found in M<XML::Compile::SOAP12::Server>.

=chapter METHODS

=section Constructors

=method new OPTIONS

=option  header_fault <anything>
=default header_fault error
SOAP1.1 defines a header fault type, which not present in SOAP 1.2,
where it is replaced by a C<notUnderstood> structure.
=cut

sub new($@)
{   my $class = shift;
    (bless {}, $class)->init( {@_} );
}

sub init($)
{   my ($self, $args) = @_;
    $args->{version}     = 'SOAP12';
    $self->SUPER::init($args);

    $self->schemas->importDefinitions( [SOAP12ENC, SOAP12ENV, SOAP12RPC] );
    $self;
}

=section Accessors
=cut

sub sender($)
{   my ($self, $args) = @_;

    error __x"headerfault does only exist in SOAP1.1"
        if $args->{header_fault};

    $self->SUPER::sender($args);
}

sub roleURI($) { $roles{$_[1]} || $_[1] }

sub roleAbbreviation($) { $rev_roles{$_[1]} || $_[1] }

1;
