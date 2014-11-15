package Iston::XS::Utils;

use 5.16.0;

require Exporter;
our @ISA = qw(Exporter);

our @EXPORT_OK = qw/find_uniq_pixels find_matching_pixels/;

our $VERSION  = '0.01';
require XSLoader;
XSLoader::load("Iston::XS::Utils", $VERSION);

1;
