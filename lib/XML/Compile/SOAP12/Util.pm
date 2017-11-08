# may be incomplete.... please add
use warnings;
use strict;

package XML::Compile::SOAP12::Util;
use base 'Exporter';

my @soap12  = qw/SOAP12ENV SOAP12ENC SOAP12RPC
 SOAP12BIND SOAP12MEP SOAP12FEATURES/;

my @roles   = qw/SOAP12NONE SOAP12NEXT SOAP12ULTIMATE/;

my @context = qw/SOAP12CONTEXT SOAP12CTXPATTERN SOAP12CTXFAILURE
  SOAP12CTXROLE SOAP12CTXSTATE/;

my @features= qw/SOAP12WEBMETHOD SOAP12METHODPROP SOAP12ACTION
  SOAP12ACTIONPROP/;

my @mep     = qw/SOAP12MEP SOAP12REQRESP SOAP12RESP
  SOAP12MEPOUT SOAP12MEPIN SOAP12MEPDEST SOAP12MEPSEND/;

our @EXPORT = (@soap12, @roles, @context, @features, @mep);
our %EXPORT_TAGS =
  ( soap12   => \@soap12
  , roles    => \@roles
  , context  => \@context
  , features => \@features
  , mep      => \@mep
  );

=chapter NAME
XML::Compile::SOAP12::Util - general purpose routines for XML::Compile::SOAP12

=chapter SYNOPSIS
 use XML::Compile::SOAP12::Util;

=chapter DESCRIPTION
This module collects functions which are useful on many places in the
SOAP 1.2 implemention, just as M<XML::Compile::Util> does for general XML
implementations (often you will needs things from both).

On the moment, only constant URIs are exported.

=chapter FUNCTIONS

The export TAG C<:soap12> groups the SOAP version 1.2 related exported
constants

=over 4
=item basic constants
C<SOAP12ENV>, C<SOAP12ENC>, C<SOAP12RPC>, C<SOAP12BIND>, C<SOAP12MEP>,
C<SOAP12FEATURES>.
=cut

use constant SOAP12 => 'http://www.w3.org/2003/05/';

use constant
 { SOAP12ENV      => SOAP12.'soap-envelope'
 , SOAP12ENC      => SOAP12.'soap-encoding'
 , SOAP12RPC      => SOAP12.'soap-rpc'
 , SOAP12BIND     => SOAP12.'soap/bindingFramework'
 , SOAP12MEP      => SOAP12.'soap/mep'
 , SOAP12FEATURES => SOAP12.'soap/features'
 };

=item role abbreviations
C<SOAP12NONE>, C<SOAP12NEXT>, C<SOAP12ULTIMATE>
=cut

use constant
 { SOAP12NONE     => SOAP12ENV.'/role/none'
 , SOAP12NEXT     => SOAP12ENV.'/role/next'
 , SOAP12ULTIMATE => SOAP12ENV.'/role/ultimateReceiver'
 };

=item binding framework
C<SOAP12CONTEXT>
=cut

use constant
 { SOAP12CONTEXT  => SOAP12BIND.'/ExchangeContext'
 };

=item exchange context
C<SOAP12CTXPATTERN>, C<SOAP12CTXFAILURE>, C<SOAP12CTXROLE>,
C<SOAP12CTXSTATE>
=cut

use constant
 { SOAP12CTXPATTERN => SOAP12CONTEXT.'/ExchangePatternName'
 , SOAP12CTXFAILURE => SOAP12CONTEXT.'/FailureReason'
 , SOAP12CTXROLE    => SOAP12CONTEXT.'/Role'
 , SOAP12CTXSTATE   => SOAP12CONTEXT.'/State'
 };

=item Features
C<SOAP12WEBMETHOD>, C<SOAP12METHODPROP>, C<SOAP12ACTION>, C<SOAP12ACTIONPROP>
=cut

use constant
 { SOAP12WEBMETHOD  => SOAP12FEATURES.'/web-method/'
 , SOAP12ACTION     => SOAP12FEATURES.'/action/'
 };

use constant
 { SOAP12METHODPROP => SOAP12WEBMETHOD.'Method'
 , SOAP12ACTIONPROP => SOAP12ACTION.'Action'
 };

=item MEP
C<SOAP12REQRESP>, C<SOAP12RESP>,
C<SOAP12MEPOUT>, C<SOAP12MEPIN>, C<SOAP12MEPDEST>, C<SOAP12MEPSEND>
=cut

use constant
 { SOAP12REQRESP    => SOAP12MEP.'/request-response/'
 , SOAP12RESP       => SOAP12MEP.'/soap-response/'
 , SOAP12MEPOUT     => SOAP12MEP.'/OutboundMessage'
 , SOAP12MEPIN      => SOAP12MEP.'/IntboundMessage'
 , SOAP12MEPDEST    => SOAP12MEP.'/ImmediateDestination'
 , SOAP12MEPSEND    => SOAP12MEP.'/ImmediateSender'
 };

=back
=cut

1;
