
BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.08

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/DateTime/Format/Strptime.pm',
    't/00-compile.t',
    't/00-report-prereqs.dd',
    't/00-report-prereqs.t',
    't/001_load.t',
    't/002_dates.t',
    't/003_every.t',
    't/004_locale_defaults.t',
    't/005_croak.t',
    't/006_locales.t',
    't/007_edge.t',
    't/008_epoch.t',
    't/009_regexp.t',
    't/author-001_all_locales.t',
    't/author-pod-spell.t',
    't/release-eol.t',
    't/release-no-tabs.t',
    't/release-pod-coverage.t',
    't/release-pod-linkcheck.t',
    't/release-pod-syntax.t',
    't/release-portability.t'
);

notabs_ok($_) foreach @files;
done_testing;
