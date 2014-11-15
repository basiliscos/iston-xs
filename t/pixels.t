use 5.16.0;

use Test::More;
use Test::Warnings;
use SDL::Image;
use SDL::Surface;
use SDLx::Surface;

use Iston::XS::Utils;
use Iston::XS::Utils::PP;

my $sample = SDL::Image::load('t/data/2-colors.png');
my $ptr = $sample->get_pixels_ptr;

my $test_suite = sub {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my ($px_finder, $px_matcher) = @_;
    my $hash_ref = $px_finder->($ptr);
    ok $hash_ref;
    my @pattern_colors = values(%$hash_ref);
    is scalar(@pattern_colors), 2;
    is_deeply [sort {$a <=> $b} @pattern_colors],
        [0x00FFFFFF, 0xFF00FF00];

    subtest "test visibility on pattern itself" => sub {
        my $matched_colors = $px_matcher->($ptr, \@pattern_colors);
        is_deeply \@pattern_colors, $matched_colors;
    };

    subtest "simple matches" => sub {
        my $image = SDL::Surface->new(
            SDL_SWSURFACE, 2, 2, 32, 0xFF, 0xFF00, 0xFF0000, 0xFF000000,
        );
        my $matrix = SDLx::Surface->new( surface => $image);
        is_deeply $px_matcher->($image->get_pixels_ptr, \@pattern_colors), [],
            "nothing found on new/black image";

        $matrix->[0][0] = 0xFFFF0000; # red
        is_deeply $px_matcher->($image->get_pixels_ptr, \@pattern_colors), [],
            "nothing found on black image with red pixel";
        $matrix->[1][1] = 0xFF00FF00; # green
        is_deeply $px_matcher->($image->get_pixels_ptr, \@pattern_colors),
            [0xFF00FF00], "green pixel on artificial image";
    };

};

subtest "XS implementation" => sub {
    $test_suite->(\&Iston::XS::Utils::find_uniq_pixels, \&Iston::XS::Utils::find_matching_pixels);
};

subtest "pure perl implementation" => sub {
    $test_suite->(\&Iston::XS::Utils::PP::find_uniq_pixels, \&Iston::XS::Utils::PP::find_matching_pixels);
};

done_testing;
