use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
    module_name        => 'Iston::XS',
    dist_version_from  => 'lib/Iston/XS/Utils.pm',
    dist_author        => 'DMOL, dmol@cpan.org',
    dist_abstract      => 'XS helpers for Iston',
    dynamic_config     => 1,
    license            => 'perl',
    configure_requires => {
        'perl'                    => '5.016',
        'Module::Build'           => '0.42',
    },
    requires           => {
      'perl'            => 5.016,
      'Carp'            => 0,
      'List::MoreUtils' => 0,
    },
    test_requires => {
        'Test::Fatal'    => 0,
        'Test::More'     => 0,
        'Test::Warnings' => 0,
        'SDL'            => 0,
    },
    c_source             => 'src',
    needs_compiler       => 1,
    add_to_cleanup       => [ 'build_done' ],
    meta_merge => {
        resources  => {
            bugtracker => 'https://github.com/basiliscos/iston-xs/issues',
            repository => 'https://github.com/basiliscos/iston-xs'
        }
    },
);

$build->create_build_script;
