package Iston::XS::Utils::PP;

use 5.16.0;

use Exporter;
use List::MoreUtils qw/any uniq/;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw/find_uniq_pixels find_matching_pixels/;

sub find_uniq_pixels {
    my ($ptr) = @_;
    my @interesting_colors =
        uniq unpack('L*', $$ptr);
    my %uniq_pixels = map { $_ => $_ } @interesting_colors;
    return \%uniq_pixels;
}

sub find_matching_pixels {
    my ($ptr, $pattern) = @_;
    my @uniq_pixels = uniq unpack('L*', $$ptr );
    my @matched_colors;
    for my $color (@$pattern) {
        if (any {$_ eq $color} @uniq_pixels) {
            #say "Found color: ", sprintf('%x', $color), " on step $s";
            push @matched_colors, $color;
        }
    }
    return \@matched_colors;
}

1;
