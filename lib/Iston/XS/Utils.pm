package Iston::XS::Utils;

use 5.16.0;
use Iston::XS;

require Exporter;
our @ISA = qw(Exporter);

our @EXPORT_OK = qw/find_uniq_pixels find_matching_pixels/;

require XSLoader;
XSLoader::load("Iston::XS::Utils", $Iston::XS::VERSION);

1;
