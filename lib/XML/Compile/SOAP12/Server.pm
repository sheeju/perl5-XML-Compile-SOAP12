# This code is part of distribution XML-Compile-SOAP12.  Meta-POD processed
# with OODoc into POD and HTML manual-pages.  See README.md
# Copyright Mark Overmeer.  Licensed under the same terms as Perl itself.

package XML::Compile::SOAP12::Server;
use base 'XML::Compile::SOAP12', 'XML::Compile::SOAP::Server';

use warnings;
use strict;

use Log::Report 'xml-compile-soap';

use XML::Compile::Util         qw/pack_type unpack_type SCHEMA2001/;
use XML::Compile::SOAP::Util   qw/XC_DAEMON_NS/;
use XML::Compile::SOAP12::Util qw/SOAP12ENV SOAP12NEXT/;

=chapter NAME
XML::Compile::SOAP12::Server - SOAP1.2 server needs

=chapter SYNOPSIS

=chapter DESCRIPTION
This module does not implement an actual soap server, but the
needs to create the server side.  The server daemon is implemented
by M<XML::Compile::SOAP::Daemon>

=chapter METHODS

=cut

sub init($)
{   my ($self, $args) = @_;
    $self->XML::Compile::SOAP12::init($args);
    $self->XML::Compile::SOAP::Server::init($args);
    $self;
}

sub makeError(@)
{   my ($self, %args) = @_;

    my %error;
    $error{Role}   = $args{Role}   || $args{faultactor};
    $error{Detail} = $args{Detail} || $args{detail};

    $error{Code}   = $args{Code}
       || { Value   => pack_type(SOAP12ENV, 'Receiver')
          , Subcode => { Value => $args{faultcode} }
          };

    $error{Reason} = $args{Reason}
       || { Text    => [ { lang => 'en', _ => $args{faultstring} } ] };

    info "Fault: $error{Reason}{Text}[0]{_}";
    $self->faultWriter->(Fault => \%error);
}

sub faultValidationFailed($$)
{   my ($self, $name, $exception) = @_;

    my $message =
      __x"operation {name} for {version} called with invalid data"
        , name => $name, version => 'SOAP12';

    my $errors = XML::LibXML::Element->new('error');
    $errors->appendText($exception->message->toString);
    my $detail = XML::LibXML::Element->new('detail');
    $detail->addChild($errors);

    $self->makeError
      ( faultcode   => pack_type(SOAP12ENV, 'validationFailed')
      , faultstring => $message
      , faultactor  => $self->role
      , detail      => $detail
      );
}

sub faultResponseInvalid($$)
{   my ($self, $name, $exception) = @_;

    my $message  =
      __x"procedure {name} for {version} produced an invalid response"
       , name => $name, version => 'SOAP12';

# Namespace qualified?
    my $errors = XML::LibXML::Element->new('error');
    $errors->appendText($exception->message->toString);
    my $detail = XML::LibXML::Element->new('Detail');
    $detail->addChild($errors);

    $self->makeError
      ( faultcode   => pack_type(SOAP12ENV, 'invalidResponse')
      , faultstring => $message
      , faultactor  => $self->role
      , detail      => $detail
      );
}

sub faultNotImplemented($)
{   my ($self, $name) = @_;

    my $message = __x"procedure {name} for {version} is not yet implemented"
      , name => $name, version => 'SOAP12';

    $self->makeError
      ( faultcode   => pack_type(SOAP12ENV, 'notImplemented')
      , faultstring => $message
      , faultactor  => SOAP12NEXT
      );
}

sub faultNoAnswerProduced($)
{   my ($self, $name) = @_;
 
    my $message = __x"callback {name} did not return an answer", name => $name;
    $self->makeError
      ( faultcode   => pack_type(SOAP12ENV, 'noAnswerProduced')
      , faultstring => $message
      , faultactor  => $self->role
      );
}

sub faultMessageNotRecognized($$$)
{   my ($self, $name, $action, $handlers) = @_;

    my $message;
    if($handlers && @$handlers)
    {   my $sa = $action ? " (soapAction $action)" : '';
        $message = __x"{version} body element {name}{sa} not recognized, available ports are {def}"
         , version => 'SOAP12', name => $name, sa => $sa, def => $handlers;
    }
    else
    {   $message =
          __x"{version} there are no handlers available, so also not for {name}"
            , version => 'SOAP12', name => $name;
    }

    $self->makeError
      ( faultcode   => pack_type(SOAP12ENV, 'notRecognized')
      , faultstring => $message
      , faultactor  => SOAP12NEXT
      );
}

sub faultTryOtherProtocol($$)
{   my ($self, $name, $other) = @_;

    my $message =
        __x"body element {name} not available in {version}, try {other}"
          , name => $name, version => 'SOAP12', other => $other;

    $self->makeError
      ( faultcode   => pack_type(SOAP12ENV, 'tryUpgrade')
      , faultstring => $message
      , faultactor  => SOAP12NEXT
      );
}

1;
