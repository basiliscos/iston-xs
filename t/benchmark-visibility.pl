#!/usr/bin/env perl

use 5.16.0;

use Benchmark qw(:all) ;
use Iston::XS::Utils;
use Iston::XS::Utils::PP;
use SDL::Image;

my $sample = SDL::Image::load('t/data/2-colors.png');
my $ptr = $sample->get_pixels_ptr;

cmpthese(10, {
    'pure perl pattern extracting' => sub {
        Iston::XS::Utils::find_uniq_pixels($ptr);
    },
    'xs pattern extracting' => sub {
        Iston::XS::Utils::PP::find_uniq_pixels($ptr);
    },
});

my @pattern = keys %{ Iston::XS::Utils::find_uniq_pixels($ptr) };
cmpthese(10, {
    'pure perl pattern matching' => sub {
        Iston::XS::Utils::find_matching_pixels($ptr, \@pattern);
    },
    'xs pattern matching' => sub {
        Iston::XS::Utils::PP::find_matching_pixels($ptr, \@pattern);
    },
});
